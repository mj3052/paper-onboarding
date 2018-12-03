//
//  OnboardingContentViewItem.swift
//  AnimatedPageView
//
//  Created by Alex K. on 21/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

import AVKit
import AVFoundation

open class VideoView: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    public var loop: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    public func configure(videoURL: URL) {
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = AVLayerVideoGravity.resize
        if let playerLayer = self.playerLayer {
            layer.addSublayer(playerLayer)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    
    override open func layoutSubviews() {
        if let playerLayer = self.playerLayer {
            playerLayer.frame = self.bounds
        }
    }
    
    public func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    public func pause() {
        player?.pause()
    }
    
    public func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if loop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}

open class InfOnboardingContentViewItem: OnboardingContentViewItem {
    
    public let videoView = VideoView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView!.addSubview(videoView)
        videoView.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
        videoView.trailingAnchor.constraint(equalTo: imageView!.trailingAnchor).isActive = true
        videoView.topAnchor.constraint(equalTo: imageView!.topAnchor).isActive = true
        videoView.bottomAnchor.constraint(equalTo: imageView!.bottomAnchor).isActive = true
        
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override class func itemOnView(_ view: UIView) -> OnboardingContentViewItem {
        let item = Init(InfOnboardingContentViewItem(frame: CGRect.zero)) {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(item)
        
        // add constraints
        item >>>- {
            $0.attribute = .height
            $0.constant = 10000
            $0.relation = .lessThanOrEqual
            return
        }
        
        for attribute in [NSLayoutConstraint.Attribute.leading, NSLayoutConstraint.Attribute.trailing] {
            (view, item) >>>- {
                $0.attribute = attribute
                return
            }
        }
        
        for attribute in [NSLayoutConstraint.Attribute.centerX, NSLayoutConstraint.Attribute.centerY] {
            (view, item) >>>- {
                $0.attribute = attribute
                return
            }
        }
        
        return item
    }
    
}
