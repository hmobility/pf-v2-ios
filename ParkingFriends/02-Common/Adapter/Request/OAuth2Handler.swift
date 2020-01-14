//
//  OAuth2Handler.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/16.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import Alamofire

class OAuth2Handler: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void

    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        return SessionManager(configuration: configuration)
    }()

    private let lock = NSLock()

    private var accessToken: String
    private var refreshToken: String
    private var tokenType: String

    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []

    // MARK: - Initialization

    public init(accessToken: String, refreshToken: String, type:String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = type
    }

    // MARK: - RequestAdapter

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
         var urlRequest = urlRequest

         if (urlRequest.url?.absoluteString) != nil {
             urlRequest.setValue("\(tokenType) \(accessToken)", forHTTPHeaderField: "Authorization")
         }

         return urlRequest
     }

    // MARK: - RequestRetrier

    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)

            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken, refreshToken in
                    guard let strongSelf = self else { return }

                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }

                    if let accessToken = accessToken, let refreshToken = refreshToken {
                        strongSelf.accessToken = accessToken
                        strongSelf.refreshToken = refreshToken
                        self?.restoreToken(accessToken: accessToken, refrehToken: refreshToken)
                        debugPrint("[TOKEN] Reissued a token - Finished")
                    }

                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }

    // MARK: - Private - Refresh Tokens
    
    private func restoreToken(accessToken:String, refrehToken:String) {
        UserData.shared.setToken(access: accessToken, refresh: refrehToken)
    }

    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }

        isRefreshing = true

        let url = AuthAPI.refresh_token(refreshToken)
        
        sessionManager.request(url.url).responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
            
                debugPrint("[TOKEN] Reissued a token")
            
                if
                    let json = response.result.value as? [String: Any],
                    let data = json["data"] as? [String: Any],
                    let accessToken = data["accessToken"] as? String,
                    let refreshToken = data["refreshToken"] as? String
                {
                    completion(true, accessToken, refreshToken)
                } else {
                    completion(false, nil, nil)
                }

                strongSelf.isRefreshing = false
            }
    }
}
