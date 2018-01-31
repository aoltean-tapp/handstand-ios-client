//
//  HSVideoVideo.swift
//  Handstand
//
//  Created by Fareeth John on 3/30/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSVideoVideo: UIView {

    var player: BMPlayer! = BMPlayer()
    var repeatVideo : Bool = false
    var disableUIControl : Bool = false
    var disableTopBar : Bool = false
    var shouldAutoPlay : Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        player.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(player)
        player.autoresizingMask = self.autoresizingMask
        player.delegate = self
//        setupVideoPlayer()
    }
    

    func setupVideoPlayer()  {
        if disableUIControl {
            player.customControllView?.hidePlayerUIComponents()
            player.removeGestureRecognizer(player.tapGesture)
            player.panGesture.isEnabled = false
            BMPlayerConf.topBarShowInCase = .none
        }
        else if disableTopBar {
            BMPlayerConf.topBarShowInCase = .none
            player.customControllView?.hideTopBar(true)
        }
        
        BMPlayerConf.allowLog = false
        BMPlayerConf.shouldAutoPlay = self.shouldAutoPlay
        BMPlayerConf.tintColor = UIColor.white
        BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
        
    }
    
    func playVideo(videoURL : URL)  {
        let asset = BMPlayerResource(url: videoURL, name: "")
        player.setVideo(resource: asset)
    }
    
    func play()  {
        player.play()
    }
    
    func stop()  {
        player.pause()
    }
    
    func pause()  {
        player.pause()
    }

    
    func replayVideo()  {
        player.seek(0.0)
        player.play()
    }
    
    func deallocView(){
        player.prepareToDealloc()
        player.removeFromSuperview()
        player = nil
    }

}

// MARK:- BMPlayerDelegate example
extension HSVideoVideo: BMPlayerDelegate {
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        if state == .playedToTheEnd && self.repeatVideo == true {
            player.replayButtonPressed()
        }
        print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
    }
}

