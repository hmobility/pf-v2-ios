//
//  UIViewController+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension UIViewController {
    public func modal(_ viewControllerToPresent: UIViewController, transparent:Bool = false, dimColor:UIColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1254901961, alpha: 0.6), animated flag:Bool = true, completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = transparent ? .overCurrentContext : .fullScreen
    
        present(viewControllerToPresent, animated: flag,
                completion: !transparent ? completion : ({
                    if flag {
                       UIView.animate(withDuration: 0.1) {
                            viewControllerToPresent.view.backgroundColor = dimColor
                        }
                    }
                })
        )
    }
    
    public func modal(_ viewControllerToPresent: UIViewController, animated flag:Bool = true, completion: (() -> Void)? = nil) {
           viewControllerToPresent.modalPresentationStyle = .fullScreen
           present(viewControllerToPresent, animated: flag, completion: completion)
       }
    
    public func modalTranslucent(_ viewController: UIViewController, modalTransitionStyle: UIModalTransitionStyle = .coverVertical, animated flag: Bool = true, completion: (() -> ())? = nil) {
        viewController.modalPresentationStyle = .custom
        viewController.modalTransitionStyle =  modalTransitionStyle
        view.window?.rootViewController?.modalPresentationStyle = .fullScreen
        present(viewController, animated: flag, completion: completion)
    }
    
    public func push(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    public func backToPrevious(animated: Bool = true) {
        if let presentingViewController = presentedViewController {
            presentingViewController.view.endEditing(true)
            presentingViewController.dismiss(animated: animated, completion: nil)
        } else {
            _ = navigationController?.popViewController(animated: animated)
        }
    }
    
    public func backToRoot(animated: Bool = true) {
        if let presentingViewController = presentedViewController {
            presentingViewController.dismiss(animated: animated, completion: nil)
        } else {
            _ = navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    public func dismissModal(animated: Bool = true, completion: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: animated, completion: completion)
    }
    
    public func dismissToTop(animated: Bool = true, completion: (() -> Void)? = nil) {
        var presentedViewController = self
        while let presentingViewController = presentedViewController.presentingViewController {
            presentedViewController = presentingViewController
        }
        presentedViewController.dismiss(animated: animated, completion: completion)
    }
    
    public func dismissRoot(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: true, completion: completion)
        }
    }
}
