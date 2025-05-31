//
//  MindVideoViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 31/03/2024.
//

import UIKit
import AVKit

class MindVideoViewController: UIViewController {
    
    
    @IBOutlet var timingView: UIView!
    @IBOutlet var timeSlider: UISlider!
    @IBOutlet var startTimeLbl: UILabel!
    @IBOutlet var endTimeLbl: UILabel!
    
    @IBOutlet var videoOut: UIView!
    let videoPlayerVC = AVPlayerViewController()
    var video : String = ""
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        videoPlayerVC.player?.pause()
        let alert = UIAlertController(title: "Stop Mindfulness Session?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "No, Carry on!", style: .cancel, handler: { _ in
            self.videoPlayerVC.player?.play()
        }))
        alert.addAction(UIAlertAction(title: "Yes, Stop.", style: .destructive, handler: { _ in
            self.dismiss(animated: true)
            PlayerManager.shared.play()
        }))
        
        present(alert, animated: true)
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        print("Mindfulness Session Completed!")
        if UserDefaults.standard.object(forKey: "mindfulnessDates") == nil {
            let dateArray : [Date] = [Date()]
            UserDefaults.standard.setValue(dateArray, forKey: "mindfulnessDates")
        }else{
            var dateArray = (UserDefaults.standard.object(forKey: "mindfulnessDates") as? [Date])!
            dateArray.append(Date())
            UserDefaults.standard.setValue(dateArray, forKey: "mindfulnessDates")
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        self.dismiss(animated: true)
        PlayerManager.shared.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("opened")
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        let url = Bundle.main.url(forResource: video, withExtension: "mp4")
        let avPlayer = AVPlayer(url: url!)
        videoPlayerVC.player = avPlayer
        videoPlayerVC.videoGravity = .resizeAspectFill
        
        videoPlayerVC.showsPlaybackControls = false
        videoPlayerVC.showsTimecodes = false
        
        videoOut.addSubview(videoPlayerVC.view)
        videoPlayerVC.view.frame=videoOut.bounds
        videoPlayerVC.player?.play()
        
        timingView.layer.cornerRadius = 40
        timingView.backgroundColor = .white.withAlphaComponent(0.5)
        
        timeSlider.setThumbImage(UIImage(named: "timeBar"), for: .normal)
        timeSlider.minimumTrackTintColor = GlobalVariables.globalAccentColour
        
        if video == "Coral" {
            endTimeLbl.text = "00:52"
            timeSlider.maximumValue = 52
        }else if video == "yellowFlower" {
            endTimeLbl.text = "01:01"
            timeSlider.maximumValue = 61
        }else if video == "Ocean" {
            endTimeLbl.text = "03:00"
            timeSlider.maximumValue = 180
        }else if video == "Temp" {
            endTimeLbl.text = "00:00"
            timeSlider.maximumValue = 900
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        let startTime = Date()
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.startTimeLbl.text = formatter.string(from: startTime, to: Date())
            self.timeSlider.value = self.timeSlider.value + 0.5
            
        }
        
    }

}
