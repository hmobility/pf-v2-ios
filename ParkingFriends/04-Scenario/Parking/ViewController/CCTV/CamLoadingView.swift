//
//  CamLoadingView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/29.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol CamLoadingViewType {
    func setLoadingStatus(_ type:LiveCamStatusType)
}

enum LiveCamStatusType:Int {
    case prepare, loading, finished
}

class CamLoadingView: UIView, CamLoadingViewType {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingTextLabel: UILabel!
    
    private var localizer:LocalizerType = Localizer.shared
    
    private var preparingText: String?
    private var loadingText: String?
    
    // MARK: - Public Methods
    
    public func setLoadingStatus(_ type:LiveCamStatusType) {
        DispatchQueue.main.async {
            self.setLoadingView(with: type)
        }
    }
    
    // MARK: - Local Methods
    
    func setLoadingView(with type:LiveCamStatusType) {
        switch type {
        case .prepare:
            loadingTextLabel.text = preparingText!
            self.isHidden = false
        case .loading:
            loadingTextLabel.text = loadingText!
        case .finished:
            self.isHidden = true
        }
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        preparingText = localizer.localized("txt_live_video_preparing")
        loadingText = localizer.localized("txt_live_video_loading")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    }
}
