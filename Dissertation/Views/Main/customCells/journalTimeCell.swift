//
//  journalTimeCell.swift
//  Dissertation
//
//  Created by Sam Nuttall on 18/03/2024.
//

import UIKit

class journalTimeCell: UITableViewCell {

    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var cellLabel: UILabel!
    
    @objc func update(){
        self.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
        timePicker.subviews[0].backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
        
        let fetchedDate = UserDefaults.standard.object(forKey: "journallingTime") as! String
        let hourStr = fetchedDate.prefix(2)
        let minuteStr = fetchedDate.suffix(2)
        let hourInt = Int(hourStr)
        let minuteInt = Int(minuteStr)
        let defaultDate = Calendar.current.date(bySettingHour: hourInt!, minute: minuteInt!, second: 0, of: Date())!
        
        timePicker.date = defaultDate
    }
    
    @objc func timePickerChanged(picker: UIDatePicker) {
        let date = timePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        UserDefaults.standard.setValue(dateString, forKey: "journallingTime")
        
        dispatchJournalNotification()
        
        if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 66 {
            dispatchJournalMindfulNotification()
        }
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
    
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        
        timePicker.subviews[0].layer.cornerRadius = 10
        timePicker.addTarget(self, action: #selector(timePickerChanged(picker:)) , for: .valueChanged)
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self,
        selector: #selector(update), userInfo: nil, repeats: true)
    }

}
