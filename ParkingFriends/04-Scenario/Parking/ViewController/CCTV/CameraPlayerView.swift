//
//  MediaPlayerView.swift
//  ParkingFriends
//
//  Created by PlankFish on 2020/02/17.
//  Copyright © 2020 Hancom Mobility. All rights reserved.
//

import UIKit
import CloudCCTVSDK
//import Alamofire
//import SwiftyJSON

protocol CameraPlayerViewType {
    func setLiveUrl(_ playUrl:String?, autoPlay:Bool)
    func changeLiveUrl(_ playUrl:String?, autoPlay:Bool)
    
    func prepareMediaPlayer()
    
    func play()
    func pause()
    func stop()
    func destroy()
}

class MediaPlayer: Ti2RPlayer {
    static let shared: MediaPlayer = {
        let player = MediaPlayer()
        return player
    }()
    
    var handlerPointer: UnsafeMutableRawPointer?
}

class CameraPlayerView: UIView, CameraPlayerViewType {
    
    var screenLayer: CALayer?
    var cameraList:[CamElement]?
    
    // MARK: - Public Methods
    
    func setLiveUrl(_ playUrl:String?, autoPlay:Bool = false) {
        if let url = playUrl {
            MediaPlayer.shared.player_setDataSource(MediaPlayer.shared.handlerPointer, url: url)
            MediaPlayer.shared.player_prepareAsync(MediaPlayer.shared.handlerPointer)
        }
        
        if autoPlay {
            self.play()
        }
    }
    
    func changeLiveUrl(_ playUrl:String?, autoPlay:Bool = false) {
        if let url = playUrl {
            MediaPlayer.shared.player_setDataSource(MediaPlayer.shared.handlerPointer, url: url)
        }
           
        if autoPlay {
            self.play()
        }
    }
    
    // MARK: - Stream Control
    
    func play() {
        if MediaPlayer.shared.handlerPointer == nil {
            debugPrint("[CCTV][PREPARE] - Reinitialized")
            prepareMediaPlayer()
            play()
        }
        else {
            /* Refer to Ti2RPlayer state */
            let state = MediaPlayer.shared.player_getState(MediaPlayer.shared.handlerPointer)
            
            if state == MEDIA_PLAYER_STOPPED {
                /* in case of STOPPED, plays media from start-position(0) after prepare() */
                MediaPlayer.shared.player_prepare(MediaPlayer.shared.handlerPointer)
                MediaPlayer.shared.player_start(MediaPlayer.shared.handlerPointer)
                
                debugPrint("[CCTV][PREPARE] - MEDIA_PLAYER_STOPPED")
            } else if state == MEDIA_PLAYER_PAUSED {
                /* in case of PAUSED , plays media from already paused-positon */
                MediaPlayer.shared.player_start(MediaPlayer.shared.handlerPointer)
                
                debugPrint("[CCTV][PREPARE] - MEDIA_PLAYER_PAUSED")
            }
        }
    }
    
    func pause() {
        MediaPlayer.shared.player_pause(MediaPlayer.shared.handlerPointer)
    }
    
    func stop() {
        MediaPlayer.shared.player_stop(MediaPlayer.shared.handlerPointer)
    }
    
    func destroy() {
        if MediaPlayer.shared.handlerPointer != nil {
            MediaPlayer.shared.player_release(MediaPlayer.shared.handlerPointer);
        }
    }
       
    // MARK: - Lcoal Methods
    
    func prepareMediaPlayer() {
        MediaPlayer.shared.handlerPointer = MediaPlayer.shared.player_create()
        MediaPlayer.shared.player_setListener(MediaPlayer.shared.handlerPointer, listener: bridge(obj: self), user: bridge(obj: self))
        screenLayer = MediaPlayer.shared.player_getDisplayLayer(with: MediaPlayer.shared.handlerPointer)
        
        if let layer = screenLayer {
            layer.frame = self.bounds
            self.layer.addSublayer(layer)
            
            debugPrint("[CCTV][PREPARE] - Finished, Size : ", layer.frame)
        }
    }
    
    func destroyPlayer() {
        if MediaPlayer.shared.handlerPointer != nil {
            MediaPlayer.shared.player_release(MediaPlayer.shared.handlerPointer);
        }
    }
    
    // MARK: - Pointer Bridge
    
    func bridge<T : AnyObject>(obj : T) -> UnsafeMutableRawPointer {
        return UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
    }
    
    func bridge<T : AnyObject>(ptr : UnsafeMutableRawPointer) -> T {
        return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
    }
    
    func bridgeRetained<T : AnyObject>(obj : T) -> UnsafeMutableRawPointer {
        return UnsafeMutableRawPointer(Unmanaged.passRetained(obj).toOpaque())
    }
    
    func bridgeTransfer<T : AnyObject>(ptr : UnsafeMutableRawPointer) -> T {
        return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
    }
    
    // MARK: - Initializers
    
    private func initialize() {
        
    }
      
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        prepareMediaPlayer()
    }
    
    override func draw(_ rect: CGRect) {
    
    }
}

//MARK: - MyPlayerDelegate
extension CameraPlayerView: PlayerListener {
    func onPrepared(_: UnsafeMutableRawPointer, user: UnsafeMutableRawPointer) {
        print("OnPrepared------------------")
        let ret = MediaPlayer.shared.player_start(MediaPlayer.shared.handlerPointer)
        print("ret: \(ret)")
    }
    
    func onCompletion(_: UnsafeMutableRawPointer, user: UnsafeMutableRawPointer) {
        print("OnCompletion------------------")
    }
    
    func onSeekComplete(_: UnsafeMutableRawPointer, user: UnsafeMutableRawPointer) {
        print("OnSeekComplete------------------")
    }
    
    func onBufferingUpdate(_: UnsafeMutableRawPointer, user: UnsafeMutableRawPointer ,percent: Int32) {
        print("OnBufferingUpdate----------------percent: \(percent)")
    }
    
    func onVideoSizeChanged(_: UnsafeMutableRawPointer, user: UnsafeMutableRawPointer , width: Int32, height: Int32) {
        print("OnVideoSizeChanged---------------width: \(width), height: \(height)");
    }
    
    func onError(_: UnsafeMutableRawPointer, user: UnsafeMutableRawPointer, arg1: Int32, arg2: Int32) -> Int32 {
        print("OnError[\(arg1), \(arg2)]---------------");
        /*
        showAlert(title: "Error", message: "영상을 불러올 수 없습니다. code: " + String(arg2)) { () -> Void in
            self.mediaDestroy()
            DispatchQueue.main.async {
//                self.navigationController?.popToRootViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        */
        return 0
    }
}