//
//  ParkinglotDetailGuideViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/28.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkinglotDetailNoticeViewModelType {
    var viewTitleText: Driver<String> { get }
    
    func setContents(_ items:[String])
    func getNoticeList() -> Observable<(hidden:Bool, items:[String])>
}

class ParkinglotDetailNoticeViewModel: ParkinglotDetailNoticeViewModelType {
    var viewTitleText: Driver<String>
    
    private var stringItems:BehaviorRelay<[String]> = BehaviorRelay(value: [])

    private var localizer:LocalizerType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitleText = localizer.localized("ttl_detail_guideline")
    }
    
    // MARK: - Publice Methods
    
    public func setContents(_ items:[String]) {
        stringItems.accept(items)
    }
    
    public func getItemsState() -> Observable<Bool> {
        return stringItems.asObservable().map {
                return $0.count > 0
            }
    }
    
    public func getNoticeList() -> Observable<(hidden:Bool, items:[String])> {
        return stringItems.asObservable()
            .map { return (hidden: $0.count == 0, $0)}
            .asObservable()
    }
}
