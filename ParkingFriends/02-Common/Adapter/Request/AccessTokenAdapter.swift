//
//  AccessTokenAdapter.swift
//  ParkingFriends
//
//  Created by misco on 2019/10/22.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation
import Alamofire

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    private let refreshToken: String
    
    init(accessToken: String, refreshToken:String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if (urlRequest.url?.absoluteString) != nil {
            urlRequest.setValue(accessToken, forHTTPHeaderField: "authorization")
        }

        return urlRequest
    }
}
