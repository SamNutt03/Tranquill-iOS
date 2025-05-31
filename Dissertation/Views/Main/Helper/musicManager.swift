//
//  musicManager.swift
//  Dissertation
//
//  Created by Sam Nuttall on 15/04/2024.
//

import Foundation
import AVFoundation

class PlayerManager {
    static let shared = PlayerManager() // Singleton instance
    
    var queuePlayer = AVQueuePlayer()
    var playerLooper: AVPlayerLooper?
    
    private init() {} // Private initializer for singleton
    
    func setupPlayer(with url: URL) {
        let playerItem = AVPlayerItem(asset: AVAsset(url: url))
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
    }
    
    func play() {
        if GlobalVariables.appMusicMuted != 1 {
            queuePlayer.play()
        }
        
    }
    
    func pause() {
        queuePlayer.pause()
    }
}
