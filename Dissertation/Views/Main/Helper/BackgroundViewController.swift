//
//  HeaderViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 17/03/2024.
//

import UIKit

class BackgroundViewController: UIViewController {

    @IBOutlet var headerImage: UIImageView!
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setAccent()
        setTimeDate()
        setTheme()
        update()
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)

    }
    
    func setTheme() {
        if UserDefaults.standard.object(forKey: "currentTheme") == nil {
            UserDefaults.standard.setValue("cloud", forKey: "currentTheme")
            headerImage.image = UIImage(named: "LightHeaderImage")
            backgroundImage.image = UIImage(named: "LightBGImage")
        }
        if UserDefaults.standard.object(forKey: "currentTheme") as! String == "cloud" {
            headerImage.image = UIImage(named: "LightHeaderImage")
            backgroundImage.image = UIImage(named: "LightBGImage")
        }
        if UserDefaults.standard.object(forKey: "currentTheme") as! String == "flower" {
            headerImage.image = UIImage(named: "DarkHeaderImage")
            backgroundImage.image = UIImage(named: "DarkBGImage")
        }
    }
    
    func setAccent(){
        if UserDefaults.standard.object(forKey: "currentAccent") != nil {
            let savedAccentColour = UserDefaults.standard.object(forKey: "currentAccent") as! [CGFloat]
            let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!
            let requiredAccentColour = CGColor(colorSpace: sRGB, components: [savedAccentColour[0] , savedAccentColour[1] , savedAccentColour[2] , savedAccentColour[3]])!
            let convertedAccentColour = UIColor(cgColor: requiredAccentColour)
            dateLabel.textColor = convertedAccentColour
            timeLabel.textColor = convertedAccentColour
            GlobalVariables.globalAccentColour = convertedAccentColour
        } else {
            UserDefaults.standard.setValue([0.227, 0.529, 0.996, 1.0]/*Default = shade of blue*/, forKey: "currentAccent")
            let savedAccentColour = UserDefaults.standard.object(forKey: "currentAccent") as! [CGFloat]
            let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!
            GlobalVariables.globalAccentColour = UIColor(cgColor: CGColor(colorSpace: sRGB, components: [savedAccentColour[0] , savedAccentColour[1] , savedAccentColour[2] , savedAccentColour[3]])!)
        }
    }
    
    
    func setTimeDate() {
        let dateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mma"
        let result = formatter.string(from: dateTime)
        let date = result.prefix(10)
        let time = result.suffix(7)
        
        let attrDate = NSAttributedString(
            string: String(date),
            attributes: [
                NSAttributedString.Key.strokeColor : UIColor.black,
                NSAttributedString.Key.foregroundColor : GlobalVariables.globalAccentColour!,
                NSAttributedString.Key.strokeWidth : -1.5
            ]
        )
        let attrTime = NSAttributedString(
            string: String(time),
            attributes: [
                NSAttributedString.Key.strokeColor : UIColor.black,
                NSAttributedString.Key.foregroundColor : GlobalVariables.globalAccentColour!,
                NSAttributedString.Key.strokeWidth : -1.5
            ]
        )
        dateLabel.attributedText = attrDate
        timeLabel.attributedText = attrTime
    }
            
    
    @objc func update() {
        setTimeDate()
        setTheme()
        setAccent()
    }

}
