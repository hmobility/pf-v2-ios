//
//  ParkingCCTVPlayerViewController.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/16.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

extension ParkingCCTVPlayerViewController : AnalyticsType {
    var screenName: String {
        return "[SCREEN] CCTV Parkinglot Player"
    }
}

class ParkingCCTVPlayerViewController: UIViewController {
    @IBOutlet weak var cctvNavigationView: UIStackView!
    @IBOutlet weak var playerView: ParkingCCTVMediaPlayerView!
    
    private var viewModel: ParkingStatusViewModelType?
    private var videoUrls:[String]?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Binding
    
    private func setupPlayer() {
     //   if let urls = viedeoUrls
    }
    
    // MARK: - Public Methods
    
    public func setViewModel(_ viewModel:ParkingStatusViewModelType) {
        self.viewModel = viewModel as! ParkingStatusViewModel
    }
    
    public func setVideoUrls(with urls:[String]) {
        videoUrls = urls
    }
 
    // MARK: - Initialize
    
    private func initialize() {
    
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
