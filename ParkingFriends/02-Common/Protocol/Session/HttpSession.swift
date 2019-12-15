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

    private let acceptableStatusCodes:[Int] = [200, 201, 204, 304, 400, 401, 403, 404, 410, 500, 503]
    private let acceptableContentType:[String] = ["application/json", "text/json", "text/plain", "text/html"]
    
    private func adapt(_ urlRequest: RequestAdapter) {
        self.httpSession.adapter = urlRequest
    }
    
    private func getAccessToken() -> (access:String, refresh:String) {
        if let result = UserData.shared.login {
            return (result.accessToken, result.refreshToken)
        }
        
        return ("no_acceess_token", "no_refresh_token")
    }
    
    // MARK: - Public Functions
    
    // Will be deprecated
    func dataTask(httpMethod:HttpMethod, auth authType:APIAuthType = .none, path:URL, parameters params:Params, completion:@escaping([String:Any]?, String?, ResponseCodeType) -> Void, failure:@escaping(String?) -> Void) -> DataRequest {
        let method = HTTPMethod(rawValue: httpMethod.rawValue)!
        
        switch authType {
        case .OAuth2:
            let token = getAccessToken()
            self.adapt(AccessTokenAdapter(accessToken: token.access, refreshToken: token.refresh))
        case .serviceKey:
            self.adapt(ServiceKeyAdapter(serviceKey: AppInfo.serviceKey))
        default:
            self.adapt(AppTokenAdapter(appVersion: AppInfo.appVersion))
            break
        }

        let dataTask = self.httpSession.request(path, method: method, parameters:params, encoding:JSONEncoding.default)

        dataTask.validate(statusCode: acceptableStatusCodes).validate(contentType: acceptableContentType).responseJSON(completionHandler:{ (response) in
            response.result.ifSuccess ({
                print("[R]", response.debugDescription)
                let object = response.result.value as! [String : Any]
                let result = ServerResult(JSON: object)!
                
                completion(result.data , result.message, result.codeType)
            })
            
            response.result.ifFailure ({
                let message = response.result.error?.localizedDescription
                failure(message)
            })
        })

        return dataTask
    }
    
    func dataTask(httpMethod:HttpMethod, auth authType:APIAuthType = .none, path:URL, parameters params:Params?) -> Observable<ServerResult> {
        
        switch authType {
        case .OAuth2:
            let token = getAccessToken()
            self.adapt(AccessTokenAdapter(accessToken: token.access, refreshToken: token.refresh))
        case .serviceKey:
            self.adapt(ServiceKeyAdapter(serviceKey: AppInfo.serviceKey))
        default:
            self.adapt(AppTokenAdapter(appVersion: AppInfo.appVersion))
            break
        }
        
        let method = HTTPMethod(rawValue: httpMethod.rawValue)!
        let dataTask = self.httpSession.request(path, method: method, parameters:params, encoding:JSONEncoding.default)
        
        return Observable.create { [unowned self] observer -> Disposable in
            dataTask.validate(statusCode: self.acceptableStatusCodes).validate(contentType: self.acceptableContentType).responseJSON(completionHandler:{ (response) in
                response.result.ifSuccess ({
                    print("[Success]", response.debugDescription)
                    let object = response.result.value as! [String : Any]
                    let result = ServerResult(JSON: object)!
                    
                    observer.onNext(result)
                    observer.onCompleted()
                })
                
                response.result.ifFailure ({
                    debugPrint("[Failure]", response.debugDescription)
                    let statusCode = response.response?.statusCode ?? -1
                    observer.onError(NSError(domain: "", code: statusCode, userInfo: nil))
                })
            })
            
            //  return dataTask
            return Disposables.create()
            
        }
    }
    
    // For Requests to Call Naver Map API
    func dataTask(path:URL, parameters params:Params?) -> Observable<MapResult> {

        self.adapt(NaverMapAdapter(clientId: MapInfo.clientId, clientSecret: MapInfo.clientSecret))
     
        let dataTask = self.httpSession.request(path, parameters:params, encoding:JSONEncoding.default)
           
        return Observable.create { [unowned self] observer -> Disposable in
            dataTask.validate(statusCode: self.acceptableStatusCodes).validate(contentType: self.acceptableContentType).responseJSON(completionHandler:{ (response) in
                response.result.ifSuccess ({
                    print("[Success]", response.debugDescription)
                    let object = response.result.value as! [String : Any]
                    let result = MapResult(JSON: object)!
                    
                    observer.onNext(result)
                    observer.onCompleted()
                })
                
                response.result.ifFailure ({
                    debugPrint("[Failure]", response.debugDescription)
                 //   let object = response.result.value as! [String : Any]
                   // let result = MapResult(JSON: object)!
                    let statusCode = response.response?.statusCode ?? -1
                    observer.onError(NSError(domain: "", code: statusCode, userInfo: nil))
                })
            })
            
            //  return dataTask
            return Disposables.create()
            
        }
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
