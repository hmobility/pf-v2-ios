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
        return "Guide Screen"
    }
}

class GuideViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    
    private var pageViewController: UIPageViewController?
    fileprivate var guideList: Array<GuideContentViewController> = []
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialize
    
    private func setupPage() {
        for n in 0...4 {
            let contentViewController = Storyboard.tutorial.instantiateViewController(withIdentifier: "GuideContentViewController") as! GuideContentViewController
            guideList.append(contentViewController[n])
        }
        
        self.pageViewController?.setViewControllers([guideList[0]], direction: .forward, animated: false, completion:nil)
    }
    
    private func initialize() {
        setupPage()
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreen()
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

extension GuideViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let curIndex = guideList.firstIndex(of: viewController as! GuideContentViewController)else{ return nil }
         
         let prePageIndex = curIndex - 1
        
         if prePageIndex < 0 {
             return nil
         } else {
             return guideList[prePageIndex]
         }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let curIndex = guideList.firstIndex(of: viewController as! GuideContentViewController) else { return nil }
        
        let prePageIndex = curIndex + 1
        
        if prePageIndex >= guideList.count {
            return nil
        } else {
            return guideList[prePageIndex]
        }
    }
}
    
