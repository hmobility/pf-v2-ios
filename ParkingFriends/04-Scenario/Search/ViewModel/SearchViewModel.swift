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
    var searchHistoryWordsText:String { get }
    var searchHistoryFavoriteText:String { get }
    
    func getTapItems() -> Observable<[String]>
}

class SearchViewModel: SearchViewModelType {
    var phSearchParkinglotText: Driver<String>
    var searchHistoryDeleteText: Driver<String>
    
    var searchHistoryWordsText:String
    var searchHistoryFavoriteText:String
    
    private var localizer:LocalizerType
     
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
        
        phSearchParkinglotText = localizer.localized("ph_search_parkinglot")
        searchHistoryDeleteText = localizer.localized("btn_search_history_delete")
        searchHistoryWordsText = localizer.localized("ttl_search_words_recent")
        searchHistoryFavoriteText = localizer.localized("ttl_search_favorite")
    }
    
    // MARK: - Public Methods
    
    public func getTapItems() -> Observable<[String]> {
        return Observable.of([searchHistoryWordsText, searchHistoryFavoriteText])
    }
    
    // MARK: - Network
    
    func requestSearch(with query:String ){
        NaverMap.geocode(query: query)
            .subscribe(onNext: { (geocode, response) in
            
            })
            .disposed(by: disposeBag)
    }
}
