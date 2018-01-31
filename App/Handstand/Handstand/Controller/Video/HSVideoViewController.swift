//
//  HSVideoViewController.swift
//  Handstand
//
//  Created by Fareeth John on 4/7/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import MessageUI

class HSVideoViewController: HSBaseController, MFMessageComposeViewControllerDelegate {

    @IBOutlet var audioView: UIView!
    @IBOutlet var videoView: UIView!
    @IBOutlet var audioPlayBorderView: HSBorderView!
    @IBOutlet var audioProgressView: UIProgressView!
    @IBOutlet var audioPlaybackView: UIView!
    @IBOutlet var audioPlayView: UIView!
    @IBOutlet var audioPlayImage: UIImageView!
    @IBOutlet var audioSpinImageView: UIImageView!
    @IBOutlet var stepsTextview: UITextView!
    @IBOutlet var videoTitleLabel: UILabel!
//    @IBOutlet var completeThubImgVw: UIImageView!
//    @IBOutlet var weeklyInfoLabel: UILabel!
//    @IBOutlet var weeklyTitleLabel: UILabel!
//    @IBOutlet var weeklyVideoThmbImageView: UIImageView!
//    @IBOutlet var weeksVideoTextileView: UIView!
    @IBOutlet var videoPlayerView: HSVideoVideo!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var videoTitleView: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var thumnailView: UIView!
    var currentVideo : HSVideo! = nil
//    var nextVideo : HSVideo! = nil
    var audioPlayer: BMPlayer! = BMPlayer()
    var bufferStartDate:Date?
    var screenTime:Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        HSAnalytics.setEventForTypes(withLog: HSA.videoDayImageScreen)
        
        currentVideo = HSAppManager.shared.videoSession?.dailyVideo
//        nextVideo = HSController.defaultController.videoSession?.weeklyVideo
        HSUtility.setSeenVideoID(currentVideo.id!)
        showVideoLoading()
        showThumbnail()
        updateUI()
        setupAudioPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HSAnalytics.setEventForTypes(withLog: HSA.videoDayVideoBuffering)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
//    override func screenNameEventLog() -> String {
//        return kGAVideoPlayerScreen
//    }
    
    func updateUI()  {
        videoTitleLabel.text = currentVideo.title
        if let thePoints = currentVideo.bulletPoints {
            stepsTextview.text = thePoints.joined(separator: "\n")
        }
    }
    
    func setupAudioPlayer(){
        audioPlayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        audioView.addSubview(audioPlayer)
        audioPlayer.isHidden = true
        audioPlayer.delegate = self
        BMPlayerConf.allowLog = false
        BMPlayerConf.topBarShowInCase = .none
        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.tintColor = UIColor.white
        BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
        if let theAudioFile = currentVideo.audio_file {
            let asset = BMPlayerResource(url: URL(string: theAudioFile)!, name: "")
            audioPlayer.setVideo(resource: asset)
        }
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayThroughRemoteCentre) , name: NSNotification.Name(rawValue: kMCAudioDidPlay), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didPauseThroughRemoteCentre) , name: NSNotification.Name(rawValue: kMCAudioDidPause), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showThumbnail()  {
        self.thumnailView.alpha = 1.0
        if currentVideo.thumbnail != nil {
            thumbnailImageView.sd_setImage(with: URL(string: (currentVideo.thumbnail)!))
        }
        videoTitleView.text = currentVideo.title
        videoTitleView.adjustsFontSizeToFitWidth = true
        durationLabel.text = "(\(currentVideo.duration!) minutes)"
        self.perform(#selector(self.hideThumbnail), with: nil, afterDelay: 2)
    }
    
    func hideThumbnail()  {
        UIView.animate(withDuration: 2.0, animations: {
            self.thumnailView.alpha = 0
        })
    }

    func showVideoLoading()  {
        videoPlayerView.shouldAutoPlay = true
        videoPlayerView.disableTopBar = true
        videoPlayerView.setupVideoPlayer()
        videoPlayerView.playVideo(videoURL: (currentVideo.optimiziedVideo()))
    }
    
    func didPlayThroughRemoteCentre()  {
        audioPlayImage.isHighlighted = true
    }

    func didPauseThroughRemoteCentre()  {
        audioPlayImage.isHighlighted = false
    }

    // MARK: - Button Action

    @IBAction func onCloseAction(_ sender: UIButton) {
        videoPlayerView.deallocView()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onCloseVideoAction(_ sender: UIButton) {
        videoPlayerView.stop()
        var theFrame = videoPlayerView.superview?.frame
        theFrame?.origin.y = self.view.frame.size.height
        UIView.animate(withDuration: 0.5, animations: {
            self.videoPlayerView.superview?.frame = theFrame!
        })
    }
    
    @IBAction func onReplayAction(_ sender: UIButton) {
        var theFrame = videoPlayerView.superview?.frame
        theFrame?.origin.y = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.videoPlayerView.superview?.frame = theFrame!
        }, completion: {success in
            self.videoPlayerView.replayVideo()
        })
    }
        
    @IBAction func onAudioPlayPauseAction(_ sender: UIButton) {
        HSAnalytics.setEventForTypes(withLog: HSA.videoDayAudioPlay)
        audioPlayImage.isHighlighted = !audioPlayImage.isHighlighted
        if audioPlayImage.isHighlighted {
            audioPlayer.play()
        }
        else{
            audioPlayer.pause()
        }
    }
    
    @IBAction func onPlayAudioAction(_ sender: UIButton) {
        audioPlayBorderView.isHidden = true
        audioSpinImageView.isHidden = false
        audioSpinImageView.rotate()
        
        if  currentVideo.audio_file != nil{
            audioPlayer.playerLayer?.isBackgroundPlayback = true
            if let theTitle = currentVideo.title {
                audioPlayer.playerLayer?.audioTitle = theTitle
            }
            if let theThumbnail = self.thumbnailImageView.image {
                audioPlayer.playerLayer?.audioArtwork = theThumbnail
            }
            if let theDuration = currentVideo.duration {
                if theDuration.contains(":") {
                    let secs = theDuration.components(separatedBy: ":")
                    var totalSec = Double(secs[0])!*60.0
                    totalSec += Double(secs[1])!
                    audioPlayer.playerLayer?.audioDuration = TimeInterval(totalSec)
                }
                else{
                    audioPlayer.playerLayer?.audioDuration = TimeInterval(theDuration)!
                }
            }
            audioPlayer.play()
        }
    }
    
    @IBAction func onShowAudioView(_ sender: UIButton) {
//        HSAnalytics.setEventForTypes(types: [.googleAnalytics], withLog: kGAAudioPlayerScreen, withData:nil)
        //Analytics
//        HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutAudioTraining , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
        HSAnalytics.setEventForTypes(withLog: HSA.videoDayAudioFlipScreen)
        videoPlayerView.pause()
        UIView.transition(from: videoView, to: audioView, duration: 0.5, options: .transitionFlipFromRight, completion: {complete in
            
        })
    }
    
    @IBAction func onShowVideoAction(_ sender: UIButton) {
//        HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPWorkoutPlayVideo, withData:nil)
        //Analytics
//        HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutWatchVideoCircuit , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
//        HSAnalytics.setEventForTypes(types: [.googleAnalytics], withLog: kGAVideoPlayerScreen, withData:nil)
        audioPlayer.pause()
        UIView.transition(from: audioView, to: videoView, duration: 0.5, options: .transitionFlipFromLeft, completion: {complete in
            self.videoPlayerView.play()
        })
    }
    
    //MARK: Message Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        controller.dismiss(animated: true, completion: nil)
    }
    
}

// MARK:- BMPlayerDelegate example
extension HSVideoViewController: BMPlayerDelegate {
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        if state == .playedToTheEnd {
            player.replayButtonPressed()
            self.audioPlayImage.isHighlighted = false
            player.seek(0.0)
        }
        if state == .readyToPlay {
            self.audioPlaybackView.isHidden = false
            self.audioPlayView.isHidden = true
            self.audioPlayImage.isHighlighted = true
        }
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        let percentage = currentTime/totalTime
        audioProgressView.progress = Float(percentage)
//        audioPlayer.playerLayer?.setAudioTotalDuration(totalTime)
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
    }
}

