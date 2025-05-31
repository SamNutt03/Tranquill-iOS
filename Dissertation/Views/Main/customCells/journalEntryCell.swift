//
//  journalEntryCell.swift
//  Dissertation
//
//  Created by Sam Nuttall on 24/03/2024.
//

import UIKit

class journalEntryCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var img: UIImageView!
    
    
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            let inset: CGFloat = 15
            var frame = newFrame
            frame.origin.x += inset
            frame.size.width -= 2*inset
            super.frame = frame
        }
    }
    
    @objc func update(){
        //self.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
        self.layer.borderWidth = 1
        self.layer.borderColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.66).cgColor
        nameLabel.textColor = GlobalVariables.globalAccentColour
        moodLabel.textColor = GlobalVariables.globalAccentColour
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        img.layer.cornerRadius = 15
        
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)
    }


}
