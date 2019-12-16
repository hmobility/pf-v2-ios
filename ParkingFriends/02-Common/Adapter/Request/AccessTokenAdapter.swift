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
    private let tokenType: String
    private let accessToken: String
    private let refreshToken: String
    
    init(type:String, accessToken: String, refreshToken:String) {
        self.tokenType = type
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if (urlRequest.url?.absoluteString) != nil {
            urlRequest.setValue("\(tokenType) \(accessToken)", forHTTPHeaderField: "authorization")
        }

        return urlRequest
    }
}
