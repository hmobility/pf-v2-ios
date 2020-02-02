//
//  SearchViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol SearchViewModelType {
    var phSearchParkinglotText: Driver<String> { get }
    var searchHistoryDeleteText: Driver<String> { get }
    var searchHistoryWordsText: Driver<String> { get }
    var searchHistoryFavoriteText: Driver<String> { get }
}

class SearchViewModel: SearchViewModelType {
    var phSearchParkinglotText: Driver<String>
    var searchHistoryDeleteText: Driver<String>
    var searchHistoryWordsText: Driver<String>
    var searchHistoryFavoriteText: Driver<String>
    
    private var localizer:LocalizerType
     
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        phSearchParkinglotText = localizer.localized("ph_search_parkinglot")
        searchHistoryDeleteText = localizer.localized("btn_search_history_delete")
        searchHistoryWordsText = localizer.localized("ttl_search_words_recent")
        searchHistoryFavoriteText = localizer.localized("ttl_search_favorite")
    }
}
