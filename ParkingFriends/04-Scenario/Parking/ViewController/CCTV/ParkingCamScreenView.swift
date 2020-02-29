//
//  ParkingNavigationScreenView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/26.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit

protocol ParkingCamScreenViewType {
    func setCameraList(_ items:[CamElement])
    func destroyPlayer() 
}

class ParkingCamScreenView: UIStackView, ParkingCamScreenViewType {
    @IBOutlet weak var navigationView: CameraNavigationView!
    @IBOutlet weak var playerView: CameraPlayerView!
    
    var cameraList:[CamElement]?
    var currentIndex:Int = 0
    
    var navigationHidden:BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    let disposeBag = DisposeBag()
    
    // MARK: - Public Methods
    
    public func setCameraList(_ items:[CamElement]) {
        cameraList = items
        
        if let list = cameraList, let element = list.first  {
            currentIndex = 0
            let showNavigation = list.count > 1
            initPlayer(with: element.liveUri, title: element.camName,  navigation: showNavigation)
        }
    }
    
    public func destroyPlayer() {
        playerView.destroy()
    }
    
    // MARK: - Local Methods
    
    func setNavigationHidden(_ flag:Bool) {
        navigationHidden.accept(flag)
    }
    
    func initPlayer(with url:String, title:String, navigation:Bool) {
        setNavigationHidden(navigation ? false : true)
        setupPlayer(with: url, title: title)
    }
    
    func setupPlayer(with url:String, title:String) {
        navigationView.setTitle(title)
        playerView.setLiveUrl(url, autoPlay:true)
    }
    
    func updateScreen(videoIndex:Int) {
        if let list = cameraList, videoIndex < list.count {
            let element = list[videoIndex]
            setupPlayer(with: element.liveUri, title: element.camName)
            navigationView.previousButton.isEnabled = (videoIndex == 0) ? false : true
            navigationView.nextButton.isEnabled = (videoIndex == (list.count - 1)) ? false : true
        }
    }
    
    // MARK: Change Video
    
    func previousVideo() {
        if currentIndex > 0 {
            let nextIndex = currentIndex - 1
            currentIndex = nextIndex
            updateScreen(videoIndex: nextIndex)
        }
    }
    
    func nextVideo() {
        if let list = cameraList, currentIndex < list.count {
            let nextIndex = currentIndex + 1
            currentIndex = nextIndex
            updateScreen(videoIndex: nextIndex)
        }
    }
    
    // MARK: - Binding
    
    func setupNavigationBinding() {
        navigationHidden.asDriver()
            .drive(navigationView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func setupButtonBinding() {
        navigationView.previousButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.previousVideo()
            })
            .disposed(by: disposeBag)
        
        navigationView.nextButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self]  _ in
                self.nextVideo()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    func initialize() {
        setupNavigationBinding()
        setupButtonBinding()
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
