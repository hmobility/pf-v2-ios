//
//  CamType.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/25.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation


enum CamStatus:String {
    case connected = "1"                       // 연결
    case disconnected = "2"                    // 연결 끊김
    case recording = "3"                       // 녹화중
    case ready_to_verify = "4"                 // 인증 대기
    case updating_firmware = "5"               // 펌웨어 업데이트 중
    case pause = "10"                          // 중지
    case cancel = "90"                          // 해지
}

enum CameraType:String {
    case zero_conf_camera = "Y"                 // 제로컨프 카메라
    case normal_camera = "N"                    // 일반 카메라
}

