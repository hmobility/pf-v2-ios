//
//  NicknameModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

fileprivate let size = (minimum:1, maximum:15)

public protocol NicknameModelType {
    var data: BehaviorRelay<String> { get set }
    
    func message(_ type:CheckType) -> String
}

final class NicknameModel: NicknameModelType {
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    // MARK: - Public Methods
    
    func validateCredentials() -> Bool {
        guard validateLength(text: data.value, size: (size.minimum, size.maximum)) else {
             return false
         }
                 
        return true
    }
    
    func message(_ type:CheckType) -> String {
        switch type {
        case .invalid:
            return ""
        default:
            return ""
        }
    }
    
    // MARK: - Local Methdos
      
    func validateLength(text: String, size: (min: Int, max:Int)) -> Bool {
        return (size.min...size.max).contains(text.count)
    }
}
