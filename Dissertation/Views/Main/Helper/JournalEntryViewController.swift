//
//  JournalEntryViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 22/03/2024.
//

import UIKit
import CoreData

class JournalEntryViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var entryName : String = ""
    var entryText : String = ""
    var entryImg : Data = Data()
    var entryMood : String = ""
    var entryCreated : String = ""
    
    var selectedImg : UIImage = UIImage(named: "noImage")!
    @IBOutlet var selectImage: UIImageView!
    
    var cancelVerify : Int = 0
    
    var openedEntry : JournalItem?
    
    @IBOutlet var titleField: UITextField!
    
    
    
    //Select Image functionality with Image Picker Controller.
    @IBOutlet var imageBtnOut: UIButton!
    @IBAction func imgBtn(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func clearImg(_ sender: UIButton) {
        selectImage.image = UIImage(named: "noImage")!
        selectedImg = UIImage(named: "noImage")!
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            selectImage.image = image
            selectedImg = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    @IBOutlet var segmentOut: UISegmentedControl!
    @IBAction func moodControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sender.selectedSegmentTintColor = UIColor.systemGreen.withAlphaComponent(0.5)
            entryMood = "Great"
        }
        if sender.selectedSegmentIndex == 1 {
            sender.selectedSegmentTintColor = UIColor.systemMint.withAlphaComponent(0.5)
            entryMood = "Good"
        }
        if sender.selectedSegmentIndex == 2 {
            sender.selectedSegmentTintColor = UIColor.systemOrange.withAlphaComponent(0.5)
            entryMood = "Meh"
        }
        if sender.selectedSegmentIndex == 3 {
            sender.selectedSegmentTintColor = UIColor.systemRed.withAlphaComponent(0.5)
            entryMood = "Bad"
        }
        
    }
    
    func dateGetter() -> String {
        let dateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let result = formatter.string(from: dateTime)
        return result
    }
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var saveEntryBtnOut: UIButton!
    @IBAction func saveEntryBtn(_ sender: UIButton) {
        if ((textView.text as String) == "Start your entry here..." && segmentOut.selectedSegmentIndex == -1) {
            //DO NOTHING!
        }else if openedEntry == nil {
            entryText = textView.text
            entryImg = selectedImg.pngData()!
            entryCreated = dateGetter()
            
            if titleField.text == "" {
                entryName = "Entry  |  \(dateGetter())"
            }else {
                entryName = titleField.text!
            }
            
            createItem(name: entryName, entry: entryText, image: entryImg, mood: entryMood, createdDate: entryCreated)
        }else {
            entryText = textView.text
            entryImg = selectedImg.pngData()!
            entryCreated = (openedEntry?.createdDate)!
            if titleField.text == "" {
                entryName = "Entry  |  \(entryCreated)"
            }else {
                entryName = titleField.text!
            }
            
            updateItem(item: openedEntry!, newName: entryName, newEntry: entryText, newImage: entryImg, newMood: entryMood)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet var cancelBtnOut: UIButton!
    @IBAction func cancelBtn(_ sender: UIButton) {
        if cancelVerify == 0 {
            let attrTitle = NSAttributedString(string: "Are you sure?", attributes: [NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 14.0)!])
            cancelBtnOut.setAttributedTitle(attrTitle, for: UIControl.State.normal)
            cancelVerify = 1
        }else{
            cancelVerify = 0
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textView.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if openedEntry == nil {
            textView.text = "Start your entry here..."
            textView.textColor = .lightGray
        }else {
            
            textView.text = openedEntry?.entry
            titleField.text = openedEntry?.name
           
            if openedEntry?.mood == "Great" {
                entryMood = "Great"
                segmentOut.selectedSegmentIndex = 0
                segmentOut.selectedSegmentTintColor = UIColor.systemGreen.withAlphaComponent(0.5)
            }
            if openedEntry?.mood == "Good" {
                entryMood = "Good"
                segmentOut.selectedSegmentIndex = 1
                segmentOut.selectedSegmentTintColor = UIColor.systemMint.withAlphaComponent(0.5)
            }
            if openedEntry?.mood == "Meh" {
                entryMood = "Meh"
                segmentOut.selectedSegmentIndex = 2
                segmentOut.selectedSegmentTintColor = UIColor.systemOrange.withAlphaComponent(0.5)
            }
            if openedEntry?.mood == "Bad" {
                entryMood = "Bad"
                segmentOut.selectedSegmentIndex = 3
                segmentOut.selectedSegmentTintColor = UIColor.systemRed.withAlphaComponent(0.5)
            }
            
            
            selectedImg = UIImage(data: (openedEntry?.image)!)!
            selectImage.image = selectedImg
        }
    }
        
    
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createItem(name: String, entry: String, image: Data, mood: String, createdDate: String){
        let newJournalEntry = JournalItem(context: context)
        newJournalEntry.name = name
        newJournalEntry.createdDate = createdDate
        newJournalEntry.image = image
        newJournalEntry.entry = entry
        newJournalEntry.mood = mood
        
        do {
            try context.save()
        }
        catch{
            //error
        }
    }
        
    func updateItem(item: JournalItem, newName: String, newEntry: String, newImage: Data, newMood: String) {
        item.name = newName
        item.entry = newEntry
        item.image = newImage
        item.mood = newMood
            
        do {
            try context.save()
        }
        catch {
                //error
        }
    }
    
}
