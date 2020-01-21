//
//  CustomNavigationItemView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2019/12/01.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import UIKit

class NavigationTitleView: UIControl {
    private var contentStackView = UIStackView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    //private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()

     @objc dynamic var titleColor: UIColor {
        get {
            return titleLabel.textColor
        }
        set {
            titleLabel.textColor = newValue
        }
    }
    
    @objc dynamic var subtitleColor: UIColor {
        get {
            return subtitleLabel.textColor
        }
        set {
            subtitleLabel.textColor = newValue
        }
    }
    
    @objc dynamic var titleFont: UIFont {
        get {
            return titleLabel.font
        }
        set {
            titleLabel.font = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    @objc dynamic var subtitleFont: UIFont {
        get {
            return subtitleLabel.font
        }
        set {
            subtitleLabel.font = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Life Cycle
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        fadeControls(alpha: 0.5)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        fadeControls(alpha: 1)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        fadeControls(alpha: 1)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return verticalStackView.systemLayoutSizeFitting(size)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return verticalStackView.systemLayoutSizeFitting(targetSize)
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingCompressedSize
    }
    
    private func fadeControls(alpha: CGFloat) {
        [titleLabel, subtitleLabel].forEach { $0.alpha = alpha }
    }
    
    // MARK: - Public Methods
    
    public func configure( title: String, subtitle: String? = nil, accessibilityLabel: String? = nil, accessibilityHint: String? = nil
          ) {
          titleLabel.text = title
          subtitleLabel.text = subtitle
          self.accessibilityLabel = accessibilityLabel ?? title
          self.accessibilityHint = accessibilityHint

          subtitleLabel.isHidden = !(subtitle?.isEmpty == false)

          invalidateIntrinsicContentSize()
      }
    
    // MARK: - Initialize

    public init() {
        super.init(frame: .zero)
        isAccessibilityElement = true
        accessibilityTraits.insert(.button)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingHead
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75
        titleLabel.textColor = UIColor.darkText
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        titleLabel.isAccessibilityElement = false

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textAlignment = .center
        subtitleLabel.lineBreakMode = .byTruncatingHead
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.75
        subtitleLabel.textColor = UIColor.darkGray
        subtitleLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        subtitleLabel.isAccessibilityElement = false

        verticalStackView.isUserInteractionEnabled = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.alignment = .center
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalCentering
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)
        
        addSubview(verticalStackView)

        verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        addConstraint(NSLayoutConstraint(item: verticalStackView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: verticalStackView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: self, attribute: .height, multiplier: 1, constant: 0))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
