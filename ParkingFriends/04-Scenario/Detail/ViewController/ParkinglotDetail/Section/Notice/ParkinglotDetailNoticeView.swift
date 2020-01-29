//
//  ParkinglotDetailGuideView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/01/19.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class ParkinglotDetailNoticeItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    public func setContent(_ item:String) {
        _ = Observable.of(item)
                .map ({ text in
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineSpacing = 3
                    paragraph.headIndent = 12
            
                    return  NSMutableAttributedString(string: text,
                                attributes:[NSAttributedString.Key.foregroundColor: Color.slateGrey,
                                            NSAttributedString.Key.font: Font.gothicNeoRegular15,
                                                NSAttributedString.Key.paragraphStyle:paragraph])
                })
                .bind(to: titleLabel.rx.attributedText)
                .disposed(by: disposeBag)
    }
}

class ParkinglotDetailNoticeView: UIStackView {
    @IBOutlet weak var titleHeaderView: ParkinglotDetailNoticeItemView!
    @IBOutlet weak var contentsView: UIStackView!
    @IBOutlet weak var footerView: UIView!
    
    private var stringItems:BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    private lazy var viewModel: ParkinglotDetailNoticeViewModelType = ParkinglotDetailNoticeViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var localizer:LocalizerType = Localizer.shared
    
    // MARK: - Initialize
    
    private func initialize() {
        setupTitleBinding()
    }
    
    // MARK: - Binding
    
    private func setupTitleBinding() {
        viewModel.viewTitleText
            .asDriver()
            .drive(self.titleHeaderView.titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupItemBinding() {
        viewModel.getNoticeList()
            .map { (hidden, items) -> [String] in
                self.setHidden(hidden)
                return items
            }
            .flatMap({
                Observable.from($0)
            })
            .subscribe(onNext: { item in
                let itemView = ParkinglotDetailNoticeItemView.loadFromXib() as ParkinglotDetailNoticeItemView
                itemView.setContent(item)
                self.contentsView.addArrangedSubview(itemView)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Local Methods
    
    func setHidden(_ flag:Bool) {
        self.titleHeaderView.isHidden = flag
        self.footerView.isHidden = flag
    }
    
    // MARK: - Public Methods
    
    public func getViewModel() -> ParkinglotDetailNoticeViewModel? {
        return (viewModel as! ParkinglotDetailNoticeViewModel)
    }
    
    public func setContents(_ items:[String]) {
        stringItems.accept(items)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
 
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        setupItemBinding()
    }
  

}
