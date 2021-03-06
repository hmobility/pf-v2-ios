//
//  Host.swift
//  ParkingFriends
//
//  Created by mkjwa on 2019/10/21.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

typealias HostType = (scheme:String, domain:String, port:Int, rootPath:String )

let host = HostType(scheme: "http", domain: "106.10.53.217", port:8081, rootPath:"/v1")
//let host = HostType(scheme: "https", domain: "napi.hmobility.co.kr", port:0, rootPath:"/v1")

let map_host = HostType(scheme: "https", domain: "naveropenapi.apigw.ntruss.com", port:0, rootPath:"")
