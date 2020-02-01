//
//  GuideViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension GuideViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] Guide"
    }
}

class GuideViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    private var pageViewController: UIPageViewController?
    fileprivate var guideList: Array<GuideContentViewController> = []
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: GuideViewModelType
    
    private var currentPageIndex: Int = 0
    
    // MARK: - Button Action
    
    @IBAction func skipButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let nextPageIndex = currentPageIndex + 1
        
        if movePage(nextPageIndex) == false {
            navigateGuideFinished()
        }
    }
    
    // MARK: - Initialize
    
    private func setupPage() {
        for n in 0...3 {
            let contentViewController = Storyboard.tutorial.instantiateViewController(withIdentifier: "GuideContentViewController") as! GuideContentViewController
            guideList.append(contentViewController[n])
        }
        
        self.pageViewController?.setViewControllers([guideList[0]], direction: .forward, animated: false, completion:nil)
    }
    
    private func initialize() {
        setupPage()
        setupBindings()
    }
    
    // MARK: - Binding

    private func setupBindings() {
        viewModel.skipText
            .drive(skipButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.nextText
            .drive(nextButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    // MARK: - Life Cycle
    
    init() {
        self.viewModel = GuideViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = GuideViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreen()
    }
    
    // MARK: - Local Methods
    
    // reutrn false, when over the length of guide list
    
    private func movePage(_ pageIndex:Int) -> Bool {
        if pageIndex > guideList.count - 1 {
            return false
        }
        
        let guideIndex = pageIndex % guideList.count
    
        if let _ = self.pageViewController, guideList.count > 0 {
            currentPageIndex = guideIndex
            self.pageViewController?.setViewControllers([guideList[guideIndex]], direction: .forward, animated: true, completion:nil)
        }
        
        return true
    }
    
    private func navigateGuideFinished() {
        let target = Storyboard.tutorial.instantiateViewController(withIdentifier: "GuideFinishedViewController") as! GuideFinishedViewController
        let lastPageIndex = currentPageIndex + 1
        
        if let controller = self.navigationController {
            controller.pushViewController(target[lastPageIndex], animated: true)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GuideContent":
            guard let viewController = segue.destination as? UIPageViewController else {
                print("PageViewController is not generated."); return }
            self.pageViewController = viewController
            self.pageViewController?.dataSource = self
        default:
            break
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension GuideViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let curIndex = guideList.firstIndex(of: viewController as! GuideContentViewController) else {
            return nil
        }
        
        let previousIndex = curIndex - 1
        
        guard previousIndex >= 0 else {
            return guideList.last
        }
        
        guard guideList.count > previousIndex else {
            return nil
        }
        
        return guideList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let curIndex = guideList.firstIndex(of: viewController as! GuideContentViewController) else {
            return nil
        }
        
        let nextIndex = curIndex + 1
        
        guard nextIndex < guideList.count else {
            return guideList.first
        }
        
        guard guideList.count > nextIndex else {
            return nil
        }
        
        return guideList[nextIndex]
    }
}
    
