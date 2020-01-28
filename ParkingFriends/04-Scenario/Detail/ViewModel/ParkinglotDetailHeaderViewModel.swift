//
//  ParkinglotDetailHeaderViewModel.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/28.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import Foundation

protocol ParkinglotDetailHeaderViewModelType {
    var imageList: BehaviorRelay<[ImageElement]> { get }

    var favoriteState: BehaviorRelay<Bool> { get }
    
    func setDetailModelView(_ viewModel:ParkinglotDetailViewModel) 
    
    func setFavorite(_ flag:Bool)
    func changeFavorite(_ flag:Bool)
    func setHeaderImages(_ images:[ImageElement])
}

class ParkinglotDetailHeaderViewModel: ParkinglotDetailHeaderViewModelType {
    
    var favoriteState: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var imageList: BehaviorRelay<[ImageElement]> = BehaviorRelay(value: [])
    
    private var detailViewModel:ParkinglotDetailViewModelType?
    
    private var localizer:LocalizerType
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    init(localizer: LocalizerType = Localizer.shared) {
        self.localizer = localizer
    }
    
    // MARK: - Public Methods
    
    func setDetailModelView(_ viewModel:ParkinglotDetailViewModel) {
        detailViewModel = viewModel
    }
    
    func setFavorite(_ flag:Bool) {
        favoriteState.accept(flag)
    }
    
    func changeFavorite(_ flag:Bool) {
        if let viewModel = detailViewModel {
            viewModel.changeBookmark(flag)
        }
    }
    
    func setHeaderImages(_ images:[ImageElement]) {
        imageList.accept(images)
    }
}
