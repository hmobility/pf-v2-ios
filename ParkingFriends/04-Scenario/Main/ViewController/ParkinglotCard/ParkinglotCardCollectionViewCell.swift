//
//  ParkinglotCardCollectionViewCell.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit
import TagListView

class ParkinglotCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var reservationButton: UIButton!
    @IBOutlet weak var tagListView: TagListView!
    
    private lazy var localizer:LocalizerType = Localizer.shared
    
    var disposeBag = DisposeBag()
    
    public var detailTap: Observable<IndexPath?> {
        return self.detailButton.rx.tap.map { _ in
            return self.indexPath
        }
    }
    
    public var rserveTap: Observable<IndexPath?> {
        return self.reservationButton.rx.tap.map { _ in
            return self.indexPath
        }
    }
    
    // MARK: - Initialize
    
    override func prepareForReuse() {
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        setupBinding()
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        self.localizer.localized("btn_reservation_disabled")
                .asDriver()
                .drive(self.reservationButton.rx.title(for: .disabled))
                .disposed(by: disposeBag)
        
        self.localizer.localized("btn_to_reserve")
                .asDriver()
                .drive(self.reservationButton.rx.title(for: .normal))
                .disposed(by: disposeBag)
        
        self.localizer.localized("btn_detail")
                .asDriver()
                .drive(self.detailButton.rx.title(for: .normal))
                .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
 
    public func setTagList(_ tags:[String]) {
        tagListView.removeAllTags()
        tagListView.textFont = Font.gothicNeoRegular14
        tagListView.addTags(tags)
    }
    
    public func setTitle(_ title:String, distance:Int) {
        let distanceUnit = localizer.localized("txt_distance_unit") as String
        titleLabel.text = title
        distanceLabel.text = "\(distance.withComma)\(distanceUnit)"
    }
    
    public func setPrice(_ price:Int) {
        let moneyUnit = localizer.localized("txt_money_unit") as String
        let hourTxt = localizer.localized("txt_hours") as String
        priceLabel.text = price.withComma
        unitLabel.text = "\(moneyUnit)/\(hourTxt)"
    }
    
    public func setReserveEnabled(_ flag:Bool) {
        reservationButton.isEnabled = flag
    }
}
