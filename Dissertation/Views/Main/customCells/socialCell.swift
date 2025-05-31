//
//  socialCell.swift
//  Dissertation
//
//  Created by Sam Nuttall on 17/03/2024.
//

import UIKit

class socialCell: UITableViewCell {

    @IBOutlet var socialLabel: UILabel!
    @IBOutlet var socialImage: UIImageView!
    
    @objc func update(){
        self.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
        self.layer.borderColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.75).cgColor
        self.selectedBackgroundView?.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
        self.isSelected = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(gray: 0.9, alpha: 0.75)
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)
    }

}
