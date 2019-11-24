//
//  EventViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/13.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    @IBOutlet weak var contentsImageView: UIImageView!
    @IBOutlet weak var noDisplayButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Button Action
    
    @IBAction func noDisplayButtonAction(_ sender: Any) {
        self.dismissModal()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
         self.dismissModal()
    }
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
