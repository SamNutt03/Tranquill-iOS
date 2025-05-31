//
//  themeCell.swift
//  Dissertation
//
//  Created by Sam Nuttall on 17/03/2024.
//

import UIKit

class themeCell: UITableViewCell {

    @IBOutlet var customSwitchImg: UIButton!
    @IBOutlet var cellLabel: UILabel!

    @objc func update(){
        self.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
        if UserDefaults.standard.object(forKey: "currentTheme") as! String == "cloud" {
            customSwitchImg.setBackgroundImage(UIImage(named: "cloudCell"), for: .normal)
        }
        if UserDefaults.standard.object(forKey: "currentTheme") as! String == "flower" {
            customSwitchImg.setBackgroundImage(UIImage(named: "flowerCell"), for: .normal)
        }
    }
    
    @IBAction func customSwitch(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "currentTheme") as! String == "cloud" {
            UserDefaults.standard.setValue("flower", forKey: "currentTheme")
            customSwitchImg.setBackgroundImage(UIImage(named: "flowerCell"), for: .normal)
            UserDefaults.standard.setValue([0.38, 0.094, 0.486, 1.0]/*Default = shade of blue*/, forKey: "currentAccent")
        }
        else if UserDefaults.standard.object(forKey: "currentTheme") as! String == "flower" {
            UserDefaults.standard.setValue("cloud", forKey: "currentTheme")
            customSwitchImg.setBackgroundImage(UIImage(named: "cloudCell"), for: .normal)
            UserDefaults.standard.setValue([0.227, 0.529, 0.996, 1.0]/*Default = shade of blue*/, forKey: "currentAccent")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 21.5
        self.clipsToBounds = true
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)
    }
}
