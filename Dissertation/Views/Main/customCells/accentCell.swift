//
//  accentCell.swift
//  Dissertation
//
//  Created by Sam Nuttall on 17/03/2024.
//

import UIKit

class accentCell: UITableViewCell {
    
    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var colourWell: UIColorWell!
    
    @objc func update(){
        self.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
        colourWell.selectedColor = GlobalVariables.globalAccentColour
    }
    
    @objc func colourChanged(){
        let newSelectedColor = (colourWell.selectedColor!.cgColor.components)
        UserDefaults.standard.setValue(newSelectedColor, forKey: "currentAccent")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        colourWell.selectedColor = GlobalVariables.globalAccentColour
        colourWell.addTarget(self, action: #selector(colourChanged), for: .valueChanged)
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    
    
}
