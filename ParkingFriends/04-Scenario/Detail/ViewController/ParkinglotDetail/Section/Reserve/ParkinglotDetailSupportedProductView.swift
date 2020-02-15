//
//  ParkinglotDetailSupportedProductView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/04.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import BetterSegmentedControl

typealias SupportedProductType = (type:ProductType, title:String)

protocol SupportedProductViewType {
    func setTitle(with items:[SupportedProductType])
    func setSelectedSegments(_ index:Int)
    func getSelectedSegments() -> Observable<ProductType?>
}

class ParkinglotDetailSupportedProductView: UIView, SupportedProductViewType {
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    
    private var labelSegments:[BetterSegmentedControlSegment]?
    private var productItems:[SupportedProductType]?
    
    // MARK: - Public Methods
    
    public func setHidden(_ flag: Bool) {
        self.isHidden = flag
    }
    
    public func setTitle(with items:[SupportedProductType]) {
        productItems = items
        let titles = items.map { return $0.title }
        
        labelSegments = LabelSegment.segments(withTitles: titles,
                                             normalFont: Font.gothicNeoRegular16,
                                             normalTextColor: Color.coolGrey,
                                             selectedFont: Font.gothicNeoRegular16,
                                             selectedTextColor: Color.shamrockGreen2)
   
        updateSegments()
    }
    
    public func setSelectedSegments(_ index:Int) {
        segmentedControl.setIndex(index)
    }
    
    public func getSelectedSegments() -> Observable<ProductType?> {
        return segmentedControl.rx.selected.map { [unowned self] index in
                if let items = self.productItems, index < items.count  {
                    return items[index].type
                }
    
               return nil
        }
    }
    
    // MARK: - Local Methods
    
    func setupSegmentControl() {
        segmentedControl.options = [.backgroundColor(UIColor.white),
                                    .backgroundBorderColor(Color.coolGrey),
                                    .backgroundBorderWidth(0.8),
                                    .indicatorViewBackgroundColor(UIColor.white),
                                    .indicatorViewBorderWidth(1.0),
                                    .indicatorViewBorderColor(Color.shamrockGreen),
                                    .indicatorViewInset(0.0),
                                    .cornerRadius(0.0),
                                    .animationSpringDamping(1.0),
                                    .animationDuration(0.0),
                                    .panningDisabled(true)]

    }
    
    func updateSegments() {
        if let segments = labelSegments {
            segmentedControl.segments = segments
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    private func initialize() {
        setupSegmentControl()
    }
    
    // MARK: - Life Cycle
     
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
    }
}
