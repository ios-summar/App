//
//  ServerRequest.swift
//  Summar
//
//  Created by mac on 2022/11/01.
//

import Foundation
import Alamofire

class ServerRequest {
    
    let serverURL = { () -> String in
        let url = Bundle.main.url(forResource: "Network", withExtension: "plist")
        let dictionary = NSDictionary(contentsOf: url!)

        // 각 데이터 형에 맞도록 캐스팅 해줍니다.
        #if DEBUG
        var LocalURL = dictionary!["DebugURL"] as? String
        #elseif RELEASE
        var LocalURL = dictionary!["ReleaseURL"] as? String
        #endif
        
        return LocalURL!
    }
    
    
//    func requestGETBOOL(requestUrl : String!) -> Bool{
//
//        do {
//            let urlStr = self.serverURL()+requestUrl
//            if let encoded = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
//               print(myURL)
//                let response = try String(contentsOf: myURL)
//                print("success")
//                print("#########response", response)
//                print(type(of: response))
//                if response == "true"{
//                    return true;
//                } else if response == "false"{
//                    return false;
//                } else{
//                    return false;
//                }
//            }
//        } catch let e as NSError {
//            print(e.localizedDescription)
//            return false;
//        }
//        return false
//    }
    
}
