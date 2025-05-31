//
//  resetCell.swift
//  Dissertation
//
//  Created by Sam Nuttall on 18/03/2024.
//

import UIKit

class resetCell: UITableViewCell {

    let attrTitle1 = NSAttributedString(string: "Reset to Defaults", attributes: [NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 12.0)!])
    let attrTitle2 = NSAttributedString(string: "Are You Sure?", attributes: [NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 12.0)!])
    
    var buttonState : Int = 1
    @IBOutlet var resetButton: UIButton!
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if buttonState == 1 {
            buttonState = 2
            resetButton.setAttributedTitle(attrTitle2, for: UIControl.State.normal)
        }else if buttonState == 2{
            buttonState = 1
            resetButton.setAttributedTitle(attrTitle1, for: UIControl.State.normal)
            UserDefaults.standard.setValue("cloud", forKey: "currentTheme")
            UserDefaults.standard.setValue([0.227, 0.529, 0.996, 1.0]/*Default = shade of blue*/, forKey: "currentAccent")
            UserDefaults.standard.setValue("09:00", forKey: "journallingTime")
            dispatchJournalNotification()
            UserDefaults.standard.setValue(3600, forKey: "mindfulTime")
            dispatchMindfulNotification()
        }
    }
    
    @IBOutlet var switchOut: UISwitch!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.isOn == true{
            UserDefaults.standard.setValue("OnboardingON", forKey: "onboarding")
        }else if sender.isOn == false{
            UserDefaults.standard.setValue("OnboardingOFF", forKey: "onboarding")
        }
    }
    
    @IBOutlet var cellLabel: UILabel!
    
    
    func dispatchJournalNotification() {
        let identifier = "daily-journal-notification"
        let title = "📝 Time to Journal!"
        let body = "Just reminding you to make sure you journalled or tracked your mood for today :)"
        let fetchedDate = UserDefaults.standard.object(forKey: "journallingTime") as! String
        let hourStr = fetchedDate.prefix(2)
        let minuteStr = fetchedDate.suffix(2)
        let hourInt = Int(hourStr)
        let minuteInt = Int(minuteStr)
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hourInt
        dateComponents.minute = minuteInt
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
    func dispatchMindfulNotification() {
        let identifier = "mindfulness-notification"
        let title = "💭 Time to focus on your thoughts!"
        let body = "Just a reminder about your scheduled mindfulness session :)"
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let interval = UserDefaults.standard.object(forKey: "mindfulTime") as! Double
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier, "mindful-journal-notification"])
        notificationCenter.add(request)
    }
    
    
    
    @objc func update(){
        resetButton.tintColor = GlobalVariables.globalAccentColour
        resetButton.layer.borderColor = GlobalVariables.globalAccentColour?.cgColor
        cellLabel.textColor = GlobalVariables.globalAccentColour
        switchOut.onTintColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.25)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UserDefaults.standard.object(forKey: "onboarding")  as Any as! String == "OnboardingOFF" {
            switchOut.setOn(false, animated: false)
        }else if UserDefaults.standard.object(forKey: "onboarding")  as Any as! String == "OnboardingON" {
            switchOut.setOn(true, animated: false)
        }
        
        buttonState = 1
        resetButton.setAttributedTitle(attrTitle1, for: UIControl.State.normal)
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)
        
        
    }

}
