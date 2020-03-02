//
//  PaymentPointsInputSectionView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/25.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol PaymentPointsInputSectionViewType {
    func setUserPoints(with points:Int)
    func setInputPoints(with points:Int)
    func getInputPointsToUse() -> Int
}

class PaymentPointsInputSectionView: UIView, PaymentPointsInputSectionViewType {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pointsInputField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var userPointsTitleLabel: UILabel!
    @IBOutlet weak var userPointsLabel: UILabel!
    @IBOutlet weak var useAllPointsButton: UIButton!
    
    var pointsToUse:BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
   // var pointsToUse:Int = 0
    var maxPoints:Int = 0
    
    let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setUserPoints(with points:Int) {
        maxPoints = points
        userPointsLabel.text = "\(points.withComma)P"
    }
    
    public func setInputPoints(with points:Int) {
       // let pointsString = points.withComma
        pointsInputField.text = "(points)"
    }
    
    public func getInputPointsToUse() -> Int {
        let points = pointsInputField.text
        return points?.intValue ?? 0
    }
    
    // MARK: - Local Methods
    
    func setupBinding() {
        pointsInputField.rx.text
            .orEmpty
            .map { $0.intValue }
            .bind(to: pointsToUse)
            .disposed(by: disposeBag)
        
        pointsToUse.asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [unowned self] points in
                self.messageLabel.isHidden = points > self.maxPoints ? false : true
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Binding
    
    // MARK: - Initialize
    
    func initialize () {
        setupBinding()
    }
    
    // MARK: - Life Cyle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }

}
