//
//  CamHttpSession.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/17.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import CloudCCTVSDK
import Alamofire
import ObjectMapper
import SwiftyJSON

class CctvHttpSession: NSObject {
    static let cctvSDK: CloudCCTVSDK = {
        return CloudCCTVSDK()
    }()
    
    static func login() -> Observable<CamLogin?> {
        return Observable.create { observer -> Disposable in
            cctvSDK.login(userId: CamInfo.userId, userPwd: CamInfo.userPassword, deviceId: CamInfo.deviceId, appId: CamInfo.appId, cflag: CamInfo.cflag) { (response, code, error) in
                if code == 200 {
                    let result = Mapper<CamLogin>().map(JSONString: response!.rawString()!)
                    observer.onNext(result)
                    observer.onCompleted()
                } else {
                    debugPrint("[CCTV][Login][Error]", error?.localizedDescription as Any, terminator: "\\")
                    let statusCode = code ?? -1
                    observer.onError(NSError(domain: "", code: statusCode, userInfo: nil))
                }
            }
            
            return Disposables.create()
        }
    }
    
    static func getCamList(projectId:String, projectAuth:String, deviceId:String, userId:String) -> Observable<CamList?> {
        return Observable.create { observer -> Disposable in
                   cctvSDK.getCameraList(projectId: projectId, projectAuth: projectAuth, deviceId: deviceId,
                                         order:nil, userId: userId) { (response, code, error) in
                       if code == 200 {
                           let result = Mapper<CamList>().map(JSONString: response!.rawString()!)
                                              
                           observer.onNext(result)
                           observer.onCompleted()
                       } else {
                        debugPrint("[CCTV][CAMP][Error]", error?.localizedDescription as Any, terminator: "\\")
                           let statusCode = code ?? -1
                           observer.onError(NSError(domain: "", code: statusCode, userInfo: nil))
                       }
                   }
                   
                   return Disposables.create()
               }
    }
    
    static func getCamLiveURL(projectId:String, projectAuth:String, deviceId:String, camId:Int) -> Observable<CamLive?> {
        return Observable.create { observer -> Disposable in
            cctvSDK.getLiveUrl(projectId: projectId, projectAuth: projectAuth, deviceId: deviceId, camId: String(camId)) { (response, code, error) in
                if code == 200 {
                    let result = Mapper<CamLive>().map(JSONString: response!.rawString()!)
                                       
                    observer.onNext(result)
                    observer.onCompleted()
                } else {
                    debugPrint("[CCTV][Live][Error]", error?.localizedDescription, terminator: "\\")
                    let statusCode = code ?? -1
                    observer.onError(NSError(domain: "", code: statusCode, userInfo: nil))
                }
            }
            
            return Disposables.create()
        }
    }
}
