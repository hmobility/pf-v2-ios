//
//  HttpSession.swift
//  ParkingFriends
//
//  Created by mkjwa on 2019/10/17.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class HttpSession: NSObject {

    private var configuration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default //URLSessionConfiguration.background(withIdentifier: "background.app.com.parkingfriends")
        configuration.timeoutIntervalForRequest = 10
        configuration.requestCachePolicy = .useProtocolCachePolicy
        //configuration.timeoutIntervalForResource = 10
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        
        return configuration
    }
    
    private var httpSession:SessionManager {
        if let sessionManager = sessionManager {
            return sessionManager
        } else {
            sessionManager = Alamofire.SessionManager(configuration: configuration)
            return sessionManager!
        }
    }
    
    private var sessionManager:SessionManager?

    private let acceptableStatusCodes:[Int] = [200, 400, 405, 500]
    private let acceptableContentType:[String] = ["application/json", "text/json", "text/plain", "text/html"]

    // MARK: - Public Functions
    
    func adapt(_ urlRequest: RequestAdapter) {
        self.httpSession.adapter = urlRequest
    }
    
    func dataTask(httpMethod:HttpMethod, auth authType:APIAuthType = .none, path:URL, parameters params:Params, completion:@escaping([String:Any]?, String) -> Void) -> DataRequest {
     //  let endpoint:String = self.baseUrl + path
        let method = HTTPMethod(rawValue: httpMethod.rawValue)!
        
        switch authType {
        case .OAuth2:
            self.adapt(AccessTokenAdapter(accessToken: "accessToken"))
        case .serviceKey:
            self.adapt(ServiceKeyAdapter(serviceKey: AppInfo.serviceKey))
        default:
            self.adapt(AppTokenAdapter(appVersion: AppInfo.appVersion))
            break
        }

        let dataTask = self.httpSession.request(path, method: method, parameters:params, encoding:JSONEncoding.default)

        dataTask.validate(statusCode: acceptableStatusCodes).validate(contentType: acceptableContentType).responseJSON(completionHandler:{ (response) in
            response.result.ifSuccess ({
                let object = response.result.value as! [String : Any]
                let status = response.response?.statusCode
                
                if status == 405 {
                    if let result = ServerError(JSON: object) {
                        completion(nil, result.error_message)
                    }
                } else {
                    completion((object["data"] as! [String : Any]) , "")
                }
            })
            
            response.result.ifFailure ({
                let message = response.result.error?.localizedDescription
                
                completion(nil, message!)
            })
        })

        return dataTask
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    static var shared:HttpSession {
        if HttpSession.sharedManager == nil {
            HttpSession.sharedManager = HttpSession()
        }
        
        return HttpSession.sharedManager
    }
    
    private static var sharedManager:HttpSession!
}
