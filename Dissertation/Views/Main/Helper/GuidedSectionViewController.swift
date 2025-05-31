//
//  GuidedSectionViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 14/04/2024.
//

import UIKit

class GuidedSectionViewController: UIViewController {
    var currentSection : GuidedSection?

    @IBOutlet var sectionTitleLbl: UILabel!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var resourcesBtnOut: UIButton!

    @IBOutlet var image: UIImageView!
    @IBOutlet var mainText: UILabel!
    @IBOutlet var subText: UILabel!
    @IBOutlet var seperatorLbl: UILabel!
    @IBOutlet var seperatorLbl2: UILabel!
    
    var backgroundImage: UIImageView!
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func resourcesBtn(_ sender: UIButton) {
        guard let url = URL(string: currentSection!.url) else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        seperatorLbl.textColor = GlobalVariables.globalAccentColour
        seperatorLbl2.textColor = GlobalVariables.globalAccentColour
        
        if UserDefaults.standard.object(forKey: "currentTheme") as! String == "cloud" {
            backgroundImage = UIImageView(image: UIImage(named: "LightBGImage"))
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.frame = self.view.bounds
            self.view.insertSubview(backgroundImage, at: 0)
        }
        if UserDefaults.standard.object(forKey: "currentTheme") as! String == "flower" {
            backgroundImage = UIImageView(image: UIImage(named: "DarkBGImage"))
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.frame = self.view.bounds
            self.view.insertSubview(backgroundImage, at: 0)
        }
        sectionTitleLbl.text = currentSection?.title
        
        resourcesBtnOut.tintColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.8)
        
        let maskLayer = CAGradientLayer()
        maskLayer.frame = image.bounds
        maskLayer.shadowRadius = 5
        maskLayer.shadowPath = CGPath(roundedRect: image.bounds.insetBy(dx: 5, dy: 5), cornerWidth: 10, cornerHeight: 10, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.white.cgColor
        image.layer.mask = maskLayer;
        
        image.image = currentSection?.image
        mainText.text = currentSection?.mainText
        subText.text = currentSection?.subtext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
