//
//  musicCell.swift
//  Dissertation
//
//  Created by Sam Nuttall on 18/03/2024.
//

import UIKit
import AVFoundation

class musicCell: UITableViewCell {

    @IBOutlet var cellLabel: UILabel!
    
    @IBAction func muteBtn(_ sender: UIButton) {
        if GlobalVariables.appMusicMuted == 0 {
            UserDefaults.standard.setValue(true, forKey: "appMuted")
            GlobalVariables.appMusicMuted = 1
            muteBtnOut.setImage(UIImage(named: "Mute"), for: .normal)
            PlayerManager.shared.pause()
        }else if GlobalVariables.appMusicMuted == 1 {
            UserDefaults.standard.setValue(false, forKey: "appMuted")
            GlobalVariables.appMusicMuted = 0
            muteBtnOut.setImage(UIImage(named: "noMute"), for: .normal)
            PlayerManager.shared.play()
        }
    }
    
    @IBOutlet var muteBtnOut: UIButton!
    @objc func update(){
        self.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if GlobalVariables.appMusicMuted == 1 {
            muteBtnOut.setImage(UIImage(named: "Mute"), for: .normal)
        }else{
            muteBtnOut.setImage(UIImage(named: "noMute"), for: .normal)
        }
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)
    }

}
