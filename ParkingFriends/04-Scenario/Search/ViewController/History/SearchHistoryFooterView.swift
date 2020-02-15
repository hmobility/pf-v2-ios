//
//  SearchHistoryFooterView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/05.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

class SearchHistoryFooterView: UIView {
    @IBOutlet weak var removeButton: UIButton!
    
    private var titleString:String?
    
    var disposeBag = DisposeBag()
    
    var removeAllAction: ((_ flag:Bool) -> Void)?
    
    // MARK: - Public Methods
    
    public func setTitle(_ title:String) {
        titleString = title
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        removeButton.rx.tap
            .subscribe(onNext: { _ in
                if let action = self.removeAllAction {
                    action(true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        setupBinding()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // MARK: - Local Methods

    private func updateLayout() {
        if let title = titleString {
            let attributedString = NSMutableAttributedString(string: title,
                                    attributes:[NSAttributedString.Key.foregroundColor: Color.slateGrey,
                                                NSAttributedString.Key.font: Font.gothicNeoRegular15,
                                                NSAttributedString.Key.underlineStyle:1.0])
            removeButton.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }

    override func draw(_ rect: CGRect) {
        updateLayout()
    }
}
