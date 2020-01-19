//
//  ParkinglotDetailGuideView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/19.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailGuideItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    public func setContent(_ item:String) {
        titleLabel.text = item
    }
}

class ParkinglotDetailGuideView: UIStackView {
    @IBOutlet weak var titleHeaderView: ParkinglotDetailGuideItemView!
    @IBOutlet weak var contentsView: UIStackView!
    @IBOutlet weak var footerView: UIView!
    
    private var stringItems:BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Initialize
    
    private func initialize() {
        setupBinding()
        setupContentsBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        localizer.localized("ttl_detail_guideline")
                .asDriver()
                .drive(self.titleHeaderView.titleLabel.rx.text)
                .disposed(by: disposeBag)
    }
    
    private func setupContentsBinding() {
        stringItems.asObservable()
                .subscribe(onNext: { items in
                    let isHidden = items.count > 0 ? false : true
                    self.titleHeaderView.isHidden = isHidden
                    self.footerView.isHidden = isHidden
                    
                    for (_, item) in items.enumerated() {
                        let itemView = (ParkinglotDetailGuideItemView.loadFromXib()) as ParkinglotDetailGuideItemView
                        itemView.setContent(item)
                        
                       // self.contentsView.addArrangedSubview(itemView)
                    }
                })
                .disposed(by: disposeBag)
        /*
        _ = Observable.from(stringItems.value)
                .asObservable()
                .subscribe(onNext: { [unowned self] (stringItem) in
                    let itemView = (ParkinglotDetailGuideItemView.loadFromXib()) as ParkinglotDetailGuideItemView
                    itemView.setContent(stringItem)
                    self.contentsView.addArrangedSubview(itemView)
                })
                .disposed(by: disposeBag)
 */
    }
    
    // MARK: - Public Methods
    
    public func setContents(_ items:[String]) {
        stringItems.accept(items)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
