//
//  ViewController.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/14.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//import Firebase
import Alamofire

extension ViewController : AnalyticsType {
    var screenName: String {
        return "ViewTest"
    }
}

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var alertAction: UIButton!
    
    @IBAction func alertAction(_ sender: Any) {
        alert(title: "Title", message: "테스트", actions:  [AlertAction(title: "OK", type: 0, style: .default), AlertAction(title: "Cancel", type: 1, style: .cancel)],
              vc: self).observeOn(MainScheduler.instance)
            .subscribe(onNext: { index in
                print ("popup index: \(index)")
                self.trackLog()
                self.track("gender", forName:"female")
                self.track("location", forName:"parking")
                self.track("parking", forName:"unknown")
                self.track("male", forName:"gender")
                self.track("gender=male", forName:"gender")
                self.track("dev", ["p1": "open"])
                
                //self.callTest()
                
                print("[LOGIN] ", UserData.shared.load()?.login?.accessToken)

                Auth.login(username: "String", password: "String") { (login, message) in
                           print(login)
                           if login != nil {
                            UserData.shared.setAuth(login!).save()
            
                        //       result.fulfill()
                           } else {
                              
                           }
                       }
 
               
            }).disposed(by: disposeBag)
    }
    
    public func callTest() {
        let headers: HTTPHeaders = ["appVersion": "1.0.0", "device": "iPhone", "osType": "iOS"]
        
        Alamofire.request("http://52.231.157.88:4010/v2/auth/login", method: .post, parameters: ["username": "String", "password": "String"], encoding: JSONEncoding.default, headers: headers).validate(contentType: ["application/json"]).responseJSON { response in
            print("[DEBUG]", response.error.debugDescription)
            print("[RT]", response.result)
            debugPrint(response)
        }

    }
    /*
    private func trackLog() {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(screenName)",
            AnalyticsParameterItemName: screenName,
            AnalyticsParameterContentType: "cont"
        ])
        
        Analytics.logEvent("share_image", parameters: [
            "name": "test_name" as NSObject,
            "full_text": "test_text" as NSObject
        ])
        
        Analytics.setUserProperty("food", forName: "favorite_food")
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        trackScreen()
    }

}

