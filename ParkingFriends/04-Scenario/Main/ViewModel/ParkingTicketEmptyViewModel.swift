//
//  ParkingTicketEmptyViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/31.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import Foundation


protocol ParkingTicketEmptyViewModelType {
    var noDataTitle: Driver<String> { get }
    var noDataDescription: Driver<String> { get }
}

class ParkingTicketEmptyViewModel: ParkingTicketEmptyViewModelType {
    var noDataTitle: Driver<String>
    var noDataDescription: Driver<String>
    
    private var localizer:LocalizerType
     
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        noDataTitle = localizer.localized("ttl_no_ticket_time")
        noDataDescription = localizer.localized("dsc_no_ticket_time")
    }
    
}
