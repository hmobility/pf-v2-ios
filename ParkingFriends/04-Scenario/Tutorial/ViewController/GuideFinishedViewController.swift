//
//  GuideFinishedViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxViewController

extension GuideFinishedViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Guide Finished"
    }
}

class GuideFinishedViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var guideImageView: UIImageView!
    @IBOutlet weak var beginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: GuideFinishedViewModelType
    
    // MARK: - Button Action

    @IBAction func beginButtonAction(_ sender: Any) {
        print("start app")
    }
    
    // MARK: - subscript
    
    subscript(index: Int) -> GuideFinishedViewController {
        get {
            let pageIndex = index % 5
            self.viewModel = GuideFinishedViewModel(pageIndex)
            return self
        }
        
        set(newValue) {
            let pageIndex = index % 5
            self.viewModel = GuideFinishedViewModel(pageIndex)
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
        
        viewModel.beginText
            .drive(beginButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBinding() {
        beginButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.navigateToMain()
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Initialize
    
    init(index:Int) {
        self.viewModel = GuideFinishedViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = GuideFinishedViewModel()
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBindings()
        setupButtonBinding()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         trackScreen()
     }
     
    // MARK: - Navigation
    
    private func navigateToMain() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let target = Storyboard.main.instantiateInitialViewController() as! UINavigationController
            window.rootViewController = target
        }
    }
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
