//
//  FixedMarkView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/03.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

enum MarkerType: Equatable {
    case normal(selected:Bool)
    case disabled(selected:Bool)
    case partner(selected:Bool)
    
    mutating func selected(_ flag:Bool) -> MarkerType {
        switch self {
        case .normal(selected: _):
            self = .normal(selected: flag)
            return self
        case .disabled(selected: _):
            self = .disabled(selected: flag)
            return self
        case .partner(selected: _):
            self = .partner(selected: flag)
            return self
        }
    }
    
    static func ==(lhs: MarkerType, rhs: MarkerType) -> Bool {
        switch (lhs, rhs) {
        case (let .normal(a1), let .normal(a2)):
            return a1 == a2
        case (let .disabled(a1), let .disabled(a2)):
            return a1 == a2
        case (let .partner(a1), let .partner(a2)):
            return a1 == a2
        default:
            return false
        }
    }
}

class MarkerView: UIView {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    public var selected: Bool = false
    
    private var markerValue: MarkerType?
    
    // MARK - Public Methods
    
    public func info(price: Int, type: MarkerType, selected:Bool = false) {
        priceLabel.text = price.withComma
        self.selected = selected
        setMarkerType(type)
    }
    
    public func setSelected(_ flag:Bool) {
        if var value = markerValue {
            setMarkerType(value.selected(flag))
//            debugPrint("[MARKER][SEL]", value, ", [M] ", flag, " , CONVERTED :", value.selected(flag))
        }
    }
    
    // MARK: - Local Methods
    
    private func setMarkerType(_ type:MarkerType) {
        if let value = self.markerValue, value == type {
//            return        // Test by Rao
        }
        
        self.markerValue = type
        
        debugPrint("[MARKER] >>> ", type)
        
        switch type {
        case .normal(let selected):
            self.backgroundImageView.image = selected ? UIImage(named:"imgMarkerGreen")! : UIImage(named:"imgMarkerNormal")!
        case .disabled(let selected):
            self.backgroundImageView.image = selected ? UIImage(named:"imgMarkerGreySelected")! : UIImage(named:"imgMarkerDisabled")!
        case .partner(let selected):
            self.backgroundImageView.image = selected ? UIImage(named:"imgMarkerGreySelected")! : UIImage(named:"imgMarkerPartner")!
        }

        backgroundImageView.setNeedsDisplay()
        
        /*
        self.setNeedsLayout()   // Test by Rao
        self.layer.setNeedsLayout()
        self.layer.displayIfNeeded()
 */
        
 
    }
    
    // MARK: - Life Cycle
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Test by Rao
        print("Draw MarkerView ~ #####################")
        
        
        
        switch self.markerValue {
        case .normal(let selected):
            self.backgroundImageView.image = selected ? UIImage(named:"imgMarkerGreen")! : UIImage(named:"imgMarkerNormal")!
        case .disabled(let selected):
            self.backgroundImageView.image = selected ? UIImage(named:"imgMarkerGreySelected")! : UIImage(named:"imgMarkerDisabled")!
        case .partner(let selected):
            self.backgroundImageView.image = selected ? UIImage(named:"imgMarkerGreySelected")! : UIImage(named:"imgMarkerPartner")!
        case .none:
            self.backgroundImageView.image = selected ? UIImage(named:"imgMarkerGreySelected")! : UIImage(named:"imgMarkerPartner")!
        }
    }
}
