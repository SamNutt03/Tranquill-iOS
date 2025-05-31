//
//  JournalViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 26/12/2023.
//

import UIKit

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var journalItems = [JournalItem]()
    var filteredItems = [JournalItem]()
    var editEntry : JournalItem?
    
    @IBOutlet var journalTable: UITableView!
    
    @IBOutlet var newEntryBtnOut: UIButton!
    
    @IBAction func newEntryBtn(_ sender: UIButton) {}
    
    @IBOutlet var segmentCtrlOut: UISegmentedControl!
    @IBAction func segmentCtrl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            segmentCtrlOut.selectedSegmentTintColor = .white
            filteredItems = journalItems
            journalTable.reloadData()
        }else if sender.selectedSegmentIndex == 1{
            segmentCtrlOut.selectedSegmentTintColor = .systemGreen.withAlphaComponent(0.5)
            filteredItems = []
            for item in journalItems {
                if item.mood == "Great" {
                    filteredItems.append(item)
                }
            }
            journalTable.reloadData()
        }else if sender.selectedSegmentIndex == 2{
            segmentCtrlOut.selectedSegmentTintColor = .green.withAlphaComponent(0.5)
            filteredItems = []
            for item in journalItems {
                if item.mood == "Good" {
                    filteredItems.append(item)
                }
            }
            journalTable.reloadData()
        }else if sender.selectedSegmentIndex == 3{
            segmentCtrlOut.selectedSegmentTintColor = .systemOrange.withAlphaComponent(0.5)
            filteredItems = []
            for item in journalItems {
                if item.mood == "Meh" {
                    filteredItems.append(item)
                }
            }
            journalTable.reloadData()
        }else if sender.selectedSegmentIndex == 4{
            segmentCtrlOut.selectedSegmentTintColor = .systemRed.withAlphaComponent(0.5)
            filteredItems = []
            for item in journalItems {
                if item.mood == "Bad" {
                    filteredItems.append(item)
                }
            }
            journalTable.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEntry" {
            let entryToEdit = editEntry
            let vc = segue.destination as! JournalEntryViewController
            vc.openedEntry = entryToEdit
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getAllItems()
        filteredItems = journalItems
        
        segmentCtrlOut.selectedSegmentIndex = 0
        segmentCtrlOut.selectedSegmentTintColor = .white
        
        newEntryBtnOut.tintColor = GlobalVariables.globalAccentColour
        segmentCtrlOut.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.2)
        journalTable.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.1)
        journalTable.layer.borderColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.5).cgColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalTable.layer.cornerRadius = 25
        journalTable.layer.borderWidth = 3
        journalTable.contentInset = UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
    }
    
    //TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowEntry = filteredItems.reversed()[indexPath.section]
        
        if rowEntry.entry == "Start your entry here..." {
            return 30
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowEntry = filteredItems.reversed()[indexPath.section]
        var moodText : NSAttributedString = NSAttributedString(string: "    Add Mood!")
        
        if rowEntry.entry == "Start your entry here..." {
            let cell = journalTable.dequeueReusableCell(withIdentifier: "moodCell", for: indexPath) as! moodCell
            
            if rowEntry.mood == "Great" {
                cell.backgroundColor = .systemGreen.withAlphaComponent(0.5)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "smiley4")
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: 25, height: 15)
                
                let attrText = NSMutableAttributedString()
                attrText.append(NSAttributedString(attachment: imageAttachment))
                attrText.append(NSAttributedString(string:"Mood Logged - GREAT! :D"))
                moodText = attrText
                
            }
            if rowEntry.mood == "Good" {
                cell.backgroundColor = .green.withAlphaComponent(0.33)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "smiley1")
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: 25, height: 15)
                
                let attrText = NSMutableAttributedString()
                attrText.append(NSAttributedString(attachment: imageAttachment))
                attrText.append(NSAttributedString(string:"Mood Logged - Good :)"))
                
                moodText = attrText
            }
            if rowEntry.mood == "Meh" {
                cell.backgroundColor = .systemOrange.withAlphaComponent(0.33)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "smiley2")
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: 25, height: 15)
                
                let attrText = NSMutableAttributedString()
                attrText.append(NSAttributedString(attachment: imageAttachment))
                attrText.append(NSAttributedString(string:"Mood Logged - Mehhh... :|"))
                
                moodText = attrText
            }
            if rowEntry.mood == "Bad" {
                cell.backgroundColor = .systemRed.withAlphaComponent(0.33)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "smiley3")
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: 25, height: 15)
                
                let attrText = NSMutableAttributedString()
                attrText.append(NSAttributedString(attachment: imageAttachment))
                attrText.append(NSAttributedString(string:"Mood Logged - Not so good :("))
                
                moodText = attrText
            }
            cell.moodEntryLabel.attributedText = moodText
            return cell
        }
        
        else {
            let cell = journalTable.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as! journalEntryCell
            
            cell.nameLabel.text = " • \(rowEntry.name ?? "Entry")"
            cell.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33)
            if rowEntry.mood == "Great" {
                cell.backgroundColor = .systemGreen.withAlphaComponent(0.5)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "smiley4")
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: 25, height: 15)
                
                let attrText = NSMutableAttributedString()
                attrText.append(NSAttributedString(attachment: imageAttachment))
                attrText.append(NSAttributedString(string:"Yay, you were feeling GREAT! :D"))
                moodText = attrText
                
            }
            if rowEntry.mood == "Good" {
                cell.backgroundColor = .green.withAlphaComponent(0.33)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "smiley1")
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: 25, height: 15)
                
                let attrText = NSMutableAttributedString()
                attrText.append(NSAttributedString(attachment: imageAttachment))
                attrText.append(NSAttributedString(string:"You felt GOOD writing this one :)"))
                
                moodText = attrText
            }
            if rowEntry.mood == "Meh" {
                cell.backgroundColor = .systemOrange.withAlphaComponent(0.33)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "smiley2")
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: 25, height: 15)
                
                let attrText = NSMutableAttributedString()
                attrText.append(NSAttributedString(attachment: imageAttachment))
                attrText.append(NSAttributedString(string:"Feeling a bit Mehhh... :|"))
                
                moodText = attrText
            }
            if rowEntry.mood == "Bad" {
                cell.backgroundColor = .systemRed.withAlphaComponent(0.33)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "smiley3")
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: 25, height: 15)
                
                let attrText = NSMutableAttributedString()
                attrText.append(NSAttributedString(attachment: imageAttachment))
                attrText.append(NSAttributedString(string:"This day was a hard one :("))
                
                moodText = attrText
            }
            cell.moodLabel.attributedText = moodText
            
            cell.img.image = UIImage(data: rowEntry.image!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editEntry = filteredItems.reversed()[indexPath.section]
        
        let alert = UIAlertController(title: editEntry?.name, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Edit Entry", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "editEntry", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Delete Entry", style: .destructive, handler: { _ in
            let alert2 = UIAlertController(title: "Are you sure?", message: "This will delete this entry permanently?", preferredStyle: .alert)

            alert2.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alert2: UIAlertAction!) in
                self.deleteItem(item: self.editEntry!)
            }))
            alert2.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert2, animated: true)
            
        }))
        
        present(alert, animated: true)
         
    }
    
    
    //CORE DATA SECTION
    
    
    func getAllItems(){
        do{
            journalItems = try context.fetch(JournalItem.fetchRequest())
            filteredItems = journalItems
            
            DispatchQueue.main.async {
                self.journalTable.reloadData()
            }
        }
        catch {
            //error
        }
    }
    
    func deleteItem(item: JournalItem){
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        }
        catch {
            //error
        }
    }
}
