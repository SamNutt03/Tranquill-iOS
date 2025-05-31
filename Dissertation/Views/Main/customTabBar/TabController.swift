//
//  TabController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 26/12/2023.
//

import UIKit

class TabController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 2
        setupMiddleButton()
    }
    
    
     func setupMiddleButton() {
         let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 30, y: 3, width: 60, height: 60))
         middleButton.setBackgroundImage(UIImage(named: "ProfileIcon"), for: .normal)
         middleButton.layer.shadowRadius = 3
         middleButton.layer.shadowColor = UIColor.systemBlue.cgColor
         middleButton.layer.shadowOpacity = 1
        
         self.tabBar.addSubview(middleButton)
         middleButton.addTarget(self, action: #selector(profileButtonAction), for: .touchUpInside)
        
         self.view.layoutIfNeeded()
    }
    
    @objc func profileButtonAction(sender: UIButton) {
        self.selectedIndex = 2
    }
    
    
}
