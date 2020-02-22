//
//  MemberInfo.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/20.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol MemberInfoType {
    func load()
    func getUsername() -> Observable<String>
    func getUserPoints() -> Observable<Int>
}

class MemberInfo: NSObject, MemberInfoType {
    private var memberInfo: BehaviorRelay<Members?> = BehaviorRelay(value: nil)
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Local Methods
    
    private func updateMembers(_ item:Members) {
        memberInfo.accept(item)
    }
    
    // MARK: - Public Methods
    
    public func getUsername() -> Observable<String> {
        return getMemberInfo()
            .map {
                return $0.username
            }
    }
    
    public func getUserPoints() -> Observable<Int> {
        return getMemberInfo()
            .map {
                return $0.point
            }
    }
    
    public func load()  {
        _ = getMemberInfo() 
    }
    
    // MARK: - Network
    
    private func getMemberInfo() -> Observable<Members> {
        if memberInfo.value != nil {
            return self.memberInfo
                .asObservable()
                .filter { $0 != nil }
                .map { $0! }
        } else {
            return self.requestMembers()
                .asObservable()
                .map { item in
                    self.updateMembers(item)
                    return item
                }
                .map { $0! }
        }
    }
    
    private func requestMembers() -> Observable<Members> {
        return Member.members()
            .asObservable()
            .filter({ (members, status) in
                return members != nil
            })
            .map { (members, status) in
                return members!
            }
    }
    
    // MARK: - Initialize
    
    override init() {
        super.init()
    }
    
    static var shared:MemberInfo {
        if MemberInfo.sharedManager == nil {
            MemberInfo.sharedManager = MemberInfo()
        }
        
        return MemberInfo.sharedManager
    }
    
    private static var sharedManager:MemberInfo!

}
