//
//  guidedCell.swift
//  Dissertation
//
//  Created by Sam Nuttall on 11/04/2024.
//

import UIKit

class guidedCell: UICollectionViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellTitle: UILabel!
    
    @objc func update(){
        self.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.2)
        self.layer.borderWidth = 1
        self.layer.borderColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.66).cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)
    }
}
