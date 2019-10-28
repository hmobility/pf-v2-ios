//
//  AppTokenAdapter.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/22.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire

class AppTokenAdapter: RequestAdapter {
    private let osType: String
    private let device: String
    private let appVersion: String
    
    init(osType: String = "iOS", device: String = "iPhone", appVersion: String) {
        self.osType = osType
        self.device = device
        self.appVersion = appVersion
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if (urlRequest.url?.absoluteString) != nil {
            urlRequest.setValue(osType, forHTTPHeaderField: "osType")
            urlRequest.setValue(appVersion, forHTTPHeaderField: "appVersion")
            urlRequest.setValue(device, forHTTPHeaderField: "device")
        }

        return urlRequest
    }
}
