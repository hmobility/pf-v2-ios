//
//  MyInfoViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/03.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension MyInfoViewController: AnalyticsType {
    var screenName: String {
        return "[SCREEN] My Info"
    }
}

class MyInfoViewController: UIViewController {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var phoneNumberField: CustomInputSection!
    @IBOutlet weak var emailField: CustomInputSection!
    @IBOutlet weak var nicknameField: CustomInputSection!
     
    
    private lazy var viewModel: MyInfoViewModel = MyInfoViewModel()
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Initialize
     
     init() {
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
     }
     
     private func initialize() {

     }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
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
