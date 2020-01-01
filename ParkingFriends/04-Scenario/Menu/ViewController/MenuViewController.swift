//
//  MenuViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/30.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension MenuViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Side Menu"
    }
}

class MenuViewController: UIViewController {
    @IBOutlet weak var levelGuideButton: UIButton!
    
    private lazy var viewModel: LevelGuideViewModelType = LevelGuideViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupButtonBinding() {
        levelGuideButton.rx.tap.asDriver()
        .drive(onNext: { _ in
            self.navigateToLevelGuide()
        })
        .disposed(by: disposeBag)
    }
      
    // MARK: - Initialize

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupButtonBinding()
        
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Navigation

    func navigateToLevelGuide() {
        let target = Storyboard.menu.instantiateViewController(withIdentifier: "LevelGuideViewController") as! LevelGuideViewController
        
        self.modal(target, animated: true)
    }
     
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
