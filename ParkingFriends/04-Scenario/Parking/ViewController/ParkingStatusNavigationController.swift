//
//  ParkingStatusNavigationControll.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/20.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkingStatusNavigationController: UINavigationController {
    private var parkingCamViewController: ParkingCamViewController?
    private var parkingNormalViewController: ParkingNormalViewController?

    private var orderElement: OrderElement?
    
    var statusBarStyle:UIStatusBarStyle = .default {
        didSet {
            if statusBarStyle != oldValue {
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    // MARK: - Public Methods
    
    public func setOrderElement(with element:OrderElement?) {
        orderElement = element
    }
    
    // MARK: - Local Methods
    
    private func initialize() {
        if let element = orderElement {
            setParkingStatus(cctv: element.cctvFlag, with: element)
        }
    }
    
    private func setParkingStatus(cctv:Bool, with element:OrderElement) {
        let cc = true
        if cc == true {
            let target = Storyboard.parking.instantiateViewController(withIdentifier: "ParkingCamViewController") as! ParkingCamViewController
            target.setOrderElement(with: element)
            self.rootViewController = target
        } else {
            let target = Storyboard.parking.instantiateViewController(withIdentifier: "ParkingNormalViewController") as! ParkingNormalViewController
            target.setOrderElement(with: element)
            self.rootViewController = target
        }
    }
     
    // MARK: - Life Cycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
