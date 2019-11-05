//
//  PhoneVerifyViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class CodeVerifyViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var fieldTitleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - Button Action
     
    @IBAction func backButtonAction(_ sender: Any) {
        self.backToPrevious()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        navigateToBasicInfoInput()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
      
    private func navigateToBasicInfoInput() {
        let basicInfoInput = Storyboard.registration.instantiateViewController(withIdentifier: "BasicInfoInputViewController") as! BasicInfoInputViewController
        self.push(basicInfoInput)
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
