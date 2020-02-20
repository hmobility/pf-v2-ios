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
    var searchHistoryWordsText: String { get }
    var searchHistoryFavoriteText: String { get }
    
    var historyItems: BehaviorRelay<[String]> { get }
    var searchResults: BehaviorRelay<[Place]?> { get }
    var favoriteItems: BehaviorRelay<[FavoriteElement]?> { get }
    
    func getTapItems() -> Observable<[String]>
    
    func resetSearch()
    func resetHistory()
    func removeHistory(with index:Int)
    
    func requestSearch(with query:String, coordinate:CoordType)
    func getFavoriteItems() -> Observable<[FavoriteElement]>
}

class SearchViewModel: SearchViewModelType {
    var phSearchParkinglotText: Driver<String>
    var searchHistoryDeleteText: Driver<String>
    var searchHistoryWordsText: String
    var searchHistoryFavoriteText: String
    
    var historyItems: BehaviorRelay<[String]> = BehaviorRelay(value:[])
    var searchResults: BehaviorRelay<[Place]?> = BehaviorRelay(value:nil)
    var favoriteItems: BehaviorRelay<[FavoriteElement]?> = BehaviorRelay(value:nil)
    
    private var localizer:LocalizerType
     
    private let disposeBag = DisposeBag()
    private let userData:UserData
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared, userData:UserData = UserData.shared) {
        self.localizer = localizer
        self.userData = userData
        
        phSearchParkinglotText = localizer.localized("ph_search_parkinglot")
        searchHistoryDeleteText = localizer.localized("btn_search_history_delete")
        searchHistoryWordsText = localizer.localized("ttl_search_words_recent")
        searchHistoryFavoriteText = localizer.localized("ttl_search_favorite")
        
        initialize()
    }
    
    func initialize() {
        setupHistoryBinding()
    }
    
    // MARK: - Binding
    
    func setupHistoryBinding() {
        if let items = userData.searchHistory.getItems() {
            historyItems.accept(items)
        }
    }
    
    
    // MARK: - Local Methods
    
    func updateSearchResults(_ items:[Place]) {
        searchResults.accept(items)
    }
    
    func updateSearchHistory(with query:String) {
        if let items = userData.searchHistory.addItem(query){
            historyItems.accept(items)
        }
    }
    
    func updateFavoriteItems(_ items:[FavoriteElement]) {
        favoriteItems.accept(items)
    }
    
    // MARK: - Public Methods
    
    public func getTapItems() -> Observable<[String]> {
        return Observable.of([searchHistoryWordsText, searchHistoryFavoriteText])
    }
    
    public func resetSearch() {
        searchResults.accept(nil)
    }
    
    public func resetHistory() {
        if let items = userData.searchHistory.resetAll() {
            historyItems.accept(items)
        }
    }
    
    public func removeHistory(with index:Int) {
        if let items = userData.searchHistory.removeItem(with: index){
            historyItems.accept(items)
        }
    }
    
    public func getFavoriteItems() -> Observable<[FavoriteElement]> {
        if favoriteItems.value != nil {
            return self.favoriteItems
                .asObservable()
                .filter { $0 != nil }
                .map { $0! }
        } else {
            return self.requestFavorites()
                .asObservable()
                .map { items in
                    self.updateFavoriteItems(items)
                    return items
                }
                .map { $0! }
        }
    }
    
    // MARK: - Network
    
    public func requestSearch(with query:String, coordinate:CoordType) {
        NaverMap.search(query: query, coordinate:coordinate)
            .subscribe(onNext: { [unowned self] (places, response) in
                if let items = places, response == .okay {
                    self.updateSearchHistory(with: query)
                    self.updateSearchResults(items)
                }
            })
            .disposed(by: disposeBag)
    }
    
    public func requestFavorites() -> Observable<[FavoriteElement]> {
        return ParkingLot.favorites()
            .asObservable()
            .map { (favorite, status) in
                if status == .success {
                    return favorite?.elements ?? []
                } else {
                    return []
                }
            }
    }
}
