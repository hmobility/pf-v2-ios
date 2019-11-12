//
//  AgreementContentViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/11/05.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

extension TermsViewController : AnalyticsType {
    var screenName: String {
        return "Registering Car Screen"
    }
}

class TermsViewController: UIViewController {
    @IBOutlet weak var navigationBar: UIBarButtonItem!
    
    private var viewModel: TermsViewModelType
    private let disposeBag = DisposeBag()

    private var termsType:TermsType = .none
    
    // MARK: - Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Public Methods
    
    public func setTermsType(_ type:TermsType) {
        self.termsType = type
    }
    
    // MARK: - Binding
       
    private func setupBindings() {
        viewModel.termsTitle
            .bind(to: self.navigationBar.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.update(terms: self.termsType)
    }
     
    // MARK: - Initialize
    
    init(terms: TermsType, viewModel: TermsViewModelType = TermsViewModel(type: .none)) {
        self.termsType = terms
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = TermsViewModel(type: .none)
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBindings()
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
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
