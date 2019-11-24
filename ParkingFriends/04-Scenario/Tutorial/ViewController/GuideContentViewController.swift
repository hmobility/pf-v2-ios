//
//  GuideContentViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxViewController

extension GuideContentViewController : AnalyticsType {
    var screenName: String {
        return "Guide Content Screen"
    }
}

class GuideContentViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var guideImageView: UIImageView!
    
    var disposeBag = DisposeBag()
    var viewModel: GuideContentViewModelType
    
    subscript(index: Int) -> GuideContentViewController {
        get {
            let pageIndex = index % 4
            self.viewModel = GuideContentViewModel(pageIndex)
            return self
        }
        
        set(newValue) {
            let pageIndex = index % 4
            self.viewModel = GuideContentViewModel(pageIndex)
        }
    }
 
    // MARK: - Binding

    private func setupBindings() {
        viewModel.titleText
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.subtitleText
            .drive(subtitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pageNumber
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        viewModel.guideImage
            .bind(to: guideImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    init(index:Int) {
        self.viewModel = GuideContentViewModel(index)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = GuideContentViewModel()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         trackScreen()
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
