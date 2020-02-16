//
//  SearchFavoriteEmptyViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/02.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension SearchFavoriteEmptyViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Search Favorite Empty"
    }
}

class SearchFavoriteEmptyViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var viewModel: SearchTextViewModelType = SearchTextViewModel()
       
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupBinding() {
        viewModel.favoriteNoResultText
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.favoriteNoResultDescText
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initiailize
    
    private func initialize() {
        setupBinding()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
