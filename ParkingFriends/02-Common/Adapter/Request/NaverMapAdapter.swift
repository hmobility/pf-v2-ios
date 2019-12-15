//
//  AppTokenAdapter.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/22.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire

class NaverMapAdapter: RequestAdapter {
    private let clientId: String
    private let clientSecret: String
    
    init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if (urlRequest.url?.absoluteString) != nil {
            urlRequest.setValue(clientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
            urlRequest.setValue(clientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        }

        return urlRequest
    }
}
