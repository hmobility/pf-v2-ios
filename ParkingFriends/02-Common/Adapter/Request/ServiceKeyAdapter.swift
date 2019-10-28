//
//  ServiceKeyAdapter.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/24.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire

class ServiceKeyAdapter: RequestAdapter {
    private let serviceKey: String

    init(serviceKey: String) {
        self.serviceKey = serviceKey
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if (urlRequest.url?.absoluteString) != nil {
            urlRequest.setValue(serviceKey, forHTTPHeaderField: "serviceKey")
        }

        return urlRequest
    }
}
