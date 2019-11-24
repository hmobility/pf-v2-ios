//
//  UIViewController+Extension.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/10/29.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension UIViewController {
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
        navigationController?.show(viewController, sender: self)
    }
    
    public func backToPrevious(animated: Bool = true) {
        if let presentingViewController = presentedViewController {
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
    
    public func dismissModal(completion: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: true, completion: completion)
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
