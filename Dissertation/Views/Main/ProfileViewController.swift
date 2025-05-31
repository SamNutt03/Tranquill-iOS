//
//  ProfileViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 26/12/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var mindfulNumbersView: UIView!
    @IBOutlet var mindfulNumberLabel: UILabel!
    @IBOutlet var mindfulStreakLbl: UILabel!
    
    @IBOutlet var journalNumbersView: UIView!
    @IBOutlet var journalNumbersLabel: UILabel!
    @IBOutlet var journalStreakLbl: UILabel!
    @IBOutlet var beforeStreaksLbl: UILabel!
    @IBOutlet var trendsLabel: UILabel!
    
    @IBOutlet var chartSegment: UISegmentedControl!
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            LineChartView.isHidden = true
            PieChartView.isHidden = false
        }else if sender.selectedSegmentIndex == 1{
            LineChartView.isHidden = false
            PieChartView.isHidden = true
        }
    }
    @IBOutlet var LineChartView: UIView!
    @IBOutlet var PieChartView: UIView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var journalItems = [JournalItem]()
    var greatMoodCount = 0
    var goodMoodCount = 0
    var mehMoodCount = 0
    var badMoodCount = 0
    
    var mindfulDates : [Date] = []
    var journalDates : [Date] = []
    var mindfulStreak = 0
    var journalStreak = 0
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "mindfulnessDates") != nil {
            mindfulDates = (UserDefaults.standard.object(forKey: "mindfulnessDates") as? [Date])!
            mindfulNumberLabel.text = String(mindfulDates.count)
        }
        
        greatMoodCount = 0
        goodMoodCount = 0
        mehMoodCount = 0
        badMoodCount = 0
        mindfulStreak = 0
        journalStreak = 0
        journalDates = []
        getAllItems()
        countMoodInstances()
        
        for item in journalItems {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let date = dateFormatter.date(from: item.createdDate!)!
            journalDates.append(date)
        }
        
        calculateDailyMindfulStreak()
        calculateDailyJournalStreak()
        
        journalStreakLbl.text = String(journalStreak)
        journalNumbersLabel.text = String(journalItems.count)
        mindfulStreakLbl.text = String(mindfulStreak)
        
        if ((mindfulDates.count != 0) && (journalDates.count != 0)) {
            beforeStreaksLbl.text = "Nice work on completing some mindfulness and journalling sessions! Here are your stats and streaks so far:"
        }else if ((mindfulDates.count == 0) && (journalDates.count != 0)) {
            beforeStreaksLbl.text = "Well Done on completing some journalling! Next try mindfulness. Here are your stats so far:"
        }else if ((mindfulDates.count != 0) && (journalDates.count == 0)) {
            beforeStreaksLbl.text = "Well Done on completing some mindfulness! Next try journalling. Here are your stats so far:"
        }else{
            beforeStreaksLbl.text = "You are yet to try Tranquill's Mindfulness and Journalling features!"
        }
        
        mindfulNumbersView.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.15)
        mindfulNumbersView.layer.borderColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33).cgColor
        journalNumbersView.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.15)
        journalNumbersView.layer.borderColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33).cgColor
        chartSegment.selectedSegmentTintColor = GlobalVariables.globalAccentColour
        chartSegment.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.3)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        chartSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        trendsLabel.textColor = GlobalVariables.globalAccentColour
        
        if chartSegment.selectedSegmentIndex == 0 {
            LineChartView.isHidden = true
            PieChartView.isHidden = false
        }else if chartSegment.selectedSegmentIndex == 1{
            LineChartView.isHidden = false
            PieChartView.isHidden = true
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mindfulNumbersView.layer.cornerRadius = 10
        mindfulNumbersView.layer.borderWidth = 1.5
        journalNumbersView.layer.cornerRadius = 10
        journalNumbersView.layer.borderWidth = 1.5
    }
    
    func calculateDailyMindfulStreak() {
        var currentDate = Date().convertToUTC()
        var redStreak = 0
        
        for date in mindfulDates.reversed() {
            let calendar = Calendar.current
            let yesterday = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            let dateInUTC = date.convertToUTC()
            let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: dateInUTC)
            let yesterdayComponents = calendar.dateComponents([.year, .month, .day], from: yesterday)
            
            if currentComponents == dateComponents {
                mindfulStreak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            }else if dateComponents == yesterdayComponents {
                mindfulStreak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: yesterday)!
                redStreak = 1
            }
        }
        
        if redStreak == 1 {
            mindfulStreakLbl.textColor = .red
        }else {
            mindfulStreakLbl.textColor = .black
        }
    }
    
    func calculateDailyJournalStreak() {
        var currentDate = Date().convertToUTC()
        var redStreak = 0
        
        for date in journalDates.reversed() {
            let calendar = Calendar.current
            let yesterday = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            let dateInUTC = date.convertToUTC()
            let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: dateInUTC)
            let yesterdayComponents = calendar.dateComponents([.year, .month, .day], from: yesterday)
            
            if currentComponents == dateComponents {
                journalStreak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            }else if dateComponents == yesterdayComponents {
                journalStreak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: yesterday)!
                redStreak = 1
            }
        }
        
        if redStreak == 1 {
            journalStreakLbl.textColor = .red
        }else {
            journalStreakLbl.textColor = .black
        }
    }
    
    func countMoodInstances(){
        for journalItem in journalItems {
            if journalItem.mood == "Great"{
                greatMoodCount += 1
            }else if journalItem.mood == "Good"{
                goodMoodCount += 1
            }else if journalItem.mood == "Meh"{
                mehMoodCount += 1
            }else if journalItem.mood == "Bad"{
                badMoodCount += 1
            }
        }
        GlobalVariables.greatMoodCount = greatMoodCount
        GlobalVariables.goodMoodCount = goodMoodCount
        GlobalVariables.mehMoodCount = mehMoodCount
        GlobalVariables.badMoodCount = badMoodCount
    }
    
    
    func getAllItems(){
        do{
            journalItems = try context.fetch(JournalItem.fetchRequest())
        }
        catch {
            //error, do nothing
        }
    }
}

extension Date {
    func convertToUTC() -> Date {
        let timeZoneOffset = TimeInterval(TimeZone.current.secondsFromGMT())
        return self.addingTimeInterval(-timeZoneOffset)
    }
}
