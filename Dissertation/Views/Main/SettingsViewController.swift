//
//  SettingsViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 26/12/2023.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath) as! themeCell
            let buttonImage = UserDefaults.standard.object(forKey: "currentTheme") as! String + "Cell"
            cell.customSwitchImg.setBackgroundImage(UIImage(named: buttonImage), for: .normal)
            cell.cellLabel.text = "App Theme:"
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accentCell", for: indexPath) as! accentCell
            cell.cellLabel.text = "Accent Colour:"
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as! musicCell
            cell.cellLabel.text = "App Music:"
            return cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "journalTimeCell", for: indexPath) as! journalTimeCell
            cell.cellLabel.text = "Daily Journaling:"
            return cell
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mindfulnessTimeCell", for: indexPath) as! mindfulnessTimeCell
            cell.cellLabel.text = "Mindfulness:"
            return cell
        }
        
        else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resetCell", for: indexPath) as! resetCell
            return cell
        }
        
        else if indexPath.section == 6{
            let socialCellLabels = ["Follow developer Instagram!", "See developer LinkedIn!", "View developer Website!"]
            let socialCellImages = [UIImage(named: "IGLogo"), UIImage(named: "LinkedinLogo"), UIImage(named: "WWWLogo")]
            let cell = tableView.dequeueReusableCell(withIdentifier: "socialCell", for: indexPath) as! socialCell
            cell.socialLabel.text = socialCellLabels[indexPath.row]
            cell.socialImage.image = socialCellImages[indexPath.row]
            return cell
        }
        
        else{
            return UITableViewCell.init()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 6 {
            if indexPath.row == 0 {
                guard let url = URL(string: "https://www.instagram.com/samnutt.03") else { return }
                UIApplication.shared.open(url)
            }else if indexPath.row == 1 {
                guard let url = URL(string: "https://www.linkedin.com/in/sam-nuttall-b452aa225") else { return }
                UIApplication.shared.open(url)
            }else if indexPath.row == 2{
                guard let url = URL(string: "https://www.samnuttall.com") else { return }
                UIApplication.shared.open(url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 6 {
            return 3
            
        }else{
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 6 {
            return " "
        }
        return nil
    }
    

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "currentTheme") == nil {
            UserDefaults.standard.setValue("cloudCell", forKey: "currentTheme")
        }
        
        view.backgroundColor = .systemGray
        tableView.dataSource = self
        tableView.separatorColor = self.tableView.backgroundColor
        tableView.sectionHeaderHeight = 3
        tableView.sectionHeaderTopPadding = 5
    }
    
}
