//
//  moodCell.swift
//  Dissertation
//
//  Created by Sam Nuttall on 27/03/2024.
//

import UIKit

class moodCell: UITableViewCell {

    @IBOutlet var moodEntryLabel: UILabel!
    
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
        self.layer.borderColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.66).cgColor
        moodEntryLabel.textColor = GlobalVariables.globalAccentColour
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)
    }


}
