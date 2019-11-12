//
//  CarBrandViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension CarBrandViewController : AnalyticsType {
    var screenName: String {
        return "Car Brand Screen"
    }
}

class CarBrandViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
            
    private var viewModel: CarBrandViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Button Action
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        // navigateToBasicInfoInput()
    }
    
    // MARK: - Initialize
    
    init(viewModel: CarBrandViewModelType = CarBrandViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = CarBrandViewModel()
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
      
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
