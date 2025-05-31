//
//  mindfulnessTimeCell.swift
//  Dissertation
//
//  Created by Sam Nuttall on 18/03/2024.
//

import UIKit

class mindfulnessTimeCell: UITableViewCell {
    
    @IBAction func mindfulSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 66 {
                dispatchJournalNotification()
            }
            UserDefaults.standard.setValue(3600, forKey: "mindfulTime")
            dispatchMindfulNotification()
        }else if sender.selectedSegmentIndex == 1 {
            if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 66 {
                dispatchJournalNotification()
            }
            UserDefaults.standard.setValue(10800, forKey: "mindfulTime")
            dispatchMindfulNotification()
        }else if sender.selectedSegmentIndex == 2 {
            if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 66 {
                dispatchJournalNotification()
            }
            UserDefaults.standard.setValue(21600, forKey: "mindfulTime")
            dispatchMindfulNotification()
        }else if sender.selectedSegmentIndex == 3 {
            if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 66 {
                dispatchJournalNotification()
            }
            UserDefaults.standard.setValue(43200, forKey: "mindfulTime")
            dispatchMindfulNotification()
        }else if sender.selectedSegmentIndex == 4 {
            if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 66 {
                dispatchJournalNotification()
            }
            UserDefaults.standard.setValue(86400, forKey: "mindfulTime")
            dispatchMindfulNotification()
        }else if sender.selectedSegmentIndex == 5 {
            UserDefaults.standard.setValue(66, forKey: "mindfulTime")
            dispatchJournalMindfulNotification()
        }
    }
    @IBOutlet var mindfulSegmentOut: UISegmentedControl!
    @IBOutlet var cellLabel: UILabel!
    
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
    func dispatchJournalMindfulNotification() {
        let identifier = "mindful-journal-notification"
        let title = "📝💭 Journal and Mindfulness!"
        let body = "It's time for you to journal and do some mindfulness :)"
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
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier, "daily-journal-notification", "mindfulness-notification"])
        notificationCenter.add(request)
    }
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
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier, "mindful-journal-notification"])
        notificationCenter.add(request)
    }
    
    
    @objc func update(){
        self.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
        mindfulSegmentOut.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
        if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 3600 {
            mindfulSegmentOut.selectedSegmentIndex = 0
        }
    }
    
    func setSegment(){
        if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 66 {
            mindfulSegmentOut.selectedSegmentIndex = 5
        }else if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 3600 {
            mindfulSegmentOut.selectedSegmentIndex = 0
        }else if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 10800 {
            mindfulSegmentOut.selectedSegmentIndex = 1
        }else if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 21600 {
            mindfulSegmentOut.selectedSegmentIndex = 2
        }else if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 43200 {
            mindfulSegmentOut.selectedSegmentIndex = 3
        }else if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 86400 {
            mindfulSegmentOut.selectedSegmentIndex = 4
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        setSegment()
        
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)
    }

}
