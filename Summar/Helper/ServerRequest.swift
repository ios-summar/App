//
//  ServerRequest.swift
//  Summar
//
//  Created by mac on 2022/11/01.
//

import Foundation
import Alamofire

protocol ServerDelegate : class {
    func pushScreen(_ VC: UIViewController)
}

class ServerRequest {
    
    weak var delegate : ServerDelegate?
    
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
    
    
    func requestGETCheckId(requestUrl : String!){
        // URL 객체 정의
//                let url = URL(string: serverURL()+requestUrl)
                let urlStr = self.serverURL()+requestUrl
                print(urlStr)
                let encoded = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let myURL = URL(string: encoded!)
                // URLRequest 객체를 정의
                var request = URLRequest(url: myURL!)
                request.httpMethod = "GET"

                // HTTP 메시지 헤더
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // 서버가 응답이 없거나 통신이 실패
                    if let e = error {
//                        self.helper.showAlert(vc: self, message: "네트워크 상태를 확인해주세요.\n\(e)")
                    }

                    var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(responseString!)
                    DispatchQueue.main.async {
                        if responseString! == "true"{ // 회원가입 이력 있음
                            self.delegate?.pushScreen(HomeController())
                        }else { // 회원가입 이력 없음
                            self.delegate?.pushScreen(SignUpController())
                        }
                    }
                }
                task.resume()
    }
    
}
