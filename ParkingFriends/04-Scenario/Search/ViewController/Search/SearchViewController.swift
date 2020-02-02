//
//  ParkingSearchViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/01.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    private var viewModel: SearchViewModelType = SearchViewModel()
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    private func setupNavigation() {
        
    }
    
    private func initialize() {
        setupNavigation()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
