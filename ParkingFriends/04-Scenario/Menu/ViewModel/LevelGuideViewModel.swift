//
//  LevelGuideViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/31.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation

protocol LevelGuideViewModelType {
    var viewTitle: Driver<String> { get }
    var guideText: Driver<String> { get }
    var descriptionText: Driver<String> { get }
    var gaugeGuideText: Driver<String> { get }
    
    var levelItemList: BehaviorRelay<[(level:PointLevelType, title:String, desc:String, benefit:String)]> { get }
}

class LevelGuideViewModel: LevelGuideViewModelType {
    var viewTitle: Driver<String>
    var guideText: Driver<String>
    var descriptionText: Driver<String>
    var gaugeGuideText: Driver<String>

    var levelItemList: BehaviorRelay<[(level:PointLevelType, title:String, desc:String, benefit:String)]>
    
    var localizer:LocalizerType
    
    // MARK: - Initiailize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        viewTitle = localizer.localized("ttl_level_guide")
        guideText = localizer.localized("ttl_member_level")
        descriptionText = localizer.localized("dsc_memeber_level")
        gaugeGuideText = localizer.localized("dsc_point_gauge")
        
        levelItemList = BehaviorRelay(value:[(level: .level_1, title: localizer.localized("ttl_level_1"), desc:localizer.localized("dsc_level_1"), benefit: localizer.localized("txt_level_1_benefit")),
            (level: .level_2, title: localizer.localized("ttl_level_2"), desc:localizer.localized("dsc_level_2"), benefit:localizer.localized("txt_level_2_benefit")),
            (level: .level_3, title:localizer.localized("ttl_level_3"), desc:localizer.localized("dsc_level_3"), benefit:localizer.localized("txt_level_3_benefit")),
            (level: .level_4, title:localizer.localized("ttl_level_4"), desc:localizer.localized("dsc_level_4"), benefit:localizer.localized("txt_level_4_benefit")),
            (level: .level_5, title:localizer.localized("ttl_level_5"), desc:localizer.localized("dsc_level_5"), benefit:localizer.localized("txt_level_5_benefit"))]
        )
    }
}
