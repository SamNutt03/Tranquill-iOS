//
//  GuidedViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 26/12/2023.
//

import UIKit

class GuidedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var journalItems = [JournalItem]()
    private var first10Items = [JournalItem]()
    @IBOutlet var moodLbl: UILabel!
    
    var sections : [GuidedSection] = []
    var selected : GuidedSection?
    
    var greatMoodCount = 0
    var goodMoodCount = 0
    var mehMoodCount = 0
    var badMoodCount = 0
    var highestMood = 4
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let selectedSection = sections[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "guidedCell", for: indexPath) as! guidedCell
        cell.cellImage.image = selectedSection.image
        cell.cellTitle.text = selectedSection.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if sections[indexPath.item].mainText == "Unavailable" {
            //Do Nothing
        }else {
            selected = sections[indexPath.item]
            self.performSegue(withIdentifier: "toGuided", sender: nil)
        }
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        greatMoodCount = 0
        goodMoodCount = 0
        mehMoodCount = 0
        badMoodCount = 0
        collectionView.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.1)
        collectionView.layer.borderColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.5).cgColor
        
        setupSections()
        getAllItems()
        if journalItems.count != 0 {
            if journalItems.count > 10 {
                first10Items = Array(journalItems.reversed()[...9])
            }else{
                first10Items = Array(journalItems)
            }
        }
        countMoodInstances()
        
        if highestMood == 4 {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "smiley4")
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 33, height: 20)
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString(string:"GREAT"))
            attrText.append(NSAttributedString(attachment: imageAttachment))
            moodLbl.attributedText = attrText
            moodLbl.textColor = .systemGreen
        }else if highestMood == 3 {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "smiley1")
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 33, height: 20)
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString(string:"Good"))
            attrText.append(NSAttributedString(attachment: imageAttachment))
            moodLbl.attributedText = attrText
            moodLbl.textColor = .init(red: 0, green: 0.9, blue: 0, alpha: 1)
        }else if highestMood == 2 {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "smiley2")
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 33, height: 20)
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString(string:"Mehhh..."))
            attrText.append(NSAttributedString(attachment: imageAttachment))
            moodLbl.attributedText = attrText
            moodLbl.textColor = .systemOrange
        }else if highestMood == 1 {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "smiley3")
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 33, height: 20)
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString(string:"Not Too Well"))
            attrText.append(NSAttributedString(attachment: imageAttachment))
            moodLbl.attributedText = attrText
            moodLbl.textColor = .systemRed
        }
        
        if journalItems.count == 0 {
            moodLbl.text = "No Mood Data"
            moodLbl.textColor = .black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.layer.cornerRadius = 25
        collectionView.layer.borderWidth = 3
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGuided" {
            let selectedSection = selected
            let vc = segue.destination as! GuidedSectionViewController
            vc.currentSection = selectedSection
        }
    }
    
    
    func getAllItems(){
        do{
            journalItems = try context.fetch(JournalItem.fetchRequest())
        }
        catch {
            //error, do nothing
        }
    }
    
    func countMoodInstances(){
        for journalItem in first10Items {
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
        
        var highestCount = greatMoodCount
        
        if goodMoodCount > highestCount {
            highestCount = goodMoodCount
            highestMood = 3
        }
        if mehMoodCount > highestCount {
            highestCount = mehMoodCount
            highestMood = 2
        }
        if badMoodCount > highestCount {
            highestCount = badMoodCount
            highestMood = 1
        }
        
    }
    
    func setupSections() {
        sections = [
            GuidedSection(title: "Stress / Anxiety", image: UIImage(named: "StressAnxiety")!, mainText: "'Anxiety' is an unpleasant feeling that everyone experiences sometimes. You might describe it as feeling very nervous or “wound up”. This can be felt heavily in response to 'Stress', which is the bodies response to pressure.", subtext: "\nSome ways to manage anxiety disorders include learning about anxiety, mindfulness, relaxation techniques, correct breathing techniques, dietary adjustments, exercise, learning to be assertive, building self-esteem, cognitive therapy, exposure therapy, structured problem solving, medication and support groups.", url: "https://www.nhsinform.scot/illnesses-and-conditions/mental-health/mental-health-self-help-guides/anxiety-self-help-guide/"),
            GuidedSection(title: "Education", image: UIImage(named: "Education")!, mainText: "University can be a stressful experience, as well as being fun and exciting. You may feel stressed about starting university, exams, coursework deadlines, living with people you do not know, how will you afford to live or you may just be worried thinking about the future.", subtext: "\nAs a student it is vital that you are living the healthiest lifestyle possible, all while enjoying and making the most out of your time. One tip to calm student stress is to master your time management skills. This means study as well as loving your social life and enjoying your down time. Talk to a friend or tutor if you are struggling!", url: "https://www.nhs.uk/mental-health/children-and-young-adults/help-for-teenagers-young-adults-and-students/student-stress-self-help-tips/"),
            GuidedSection(title: "Relationships", image: UIImage(named: "Relationships")!, mainText: "Whether you are in a relationship, or if you are struggling to find love, relationships can weigh heavily on our mental health. Even the happiness of a healthy relationship could be overshadowed by an individuals thoughts or feelings in their own head.", subtext: "Open communication is key in any form of relationship issue but it can be particularly important when it comes to depression. The kind of pressure that mental health issues can place on a relationship can be eased by talking openly and honestly about what each person is finding difficult. Exploring new ways of meeting other individuals and being honest and open about what you want can be effective in finding the partner you may seek.", url: "https://www.relate.org.uk/get-help/depression-relationships"),
            GuidedSection(title: "Body Image", image: UIImage(named: "BodyImage")!, mainText: "Body image is how we feel about ourselves physically, and how we believe others see us. There are lots of ways we can think about our body and the way we look. At times you can like your body, or parts of your body, and other times you can struggle with how you look.", subtext: "Key tips to help with body image issues include: Realise that everyone has their flaws, accept compliments and focus on the parts of yourself that you love. There is always healthy options to help boost how you feel about yourself, maybe take up running or sports, or try out the gym to work towards your own personal goals.\n\n\"Comparison is the thief of joy\"", url: "https://www.youngminds.org.uk/young-person/coping-with-life/body-image/#Whattodoifyoureworriedabouthowyoulook"),
            GuidedSection(title: "Confidence", image: UIImage(named: "Confidence")!, mainText: "We all have times when we lack confidence and do not feel good about ourselves. But when low self-esteem becomes a long-term problem, it can have a harmful effect on our mental health and our day-to-day lives.", subtext: "If you have low self-esteem or confidence, you may hide yourself away from social situations, stop trying new things, and avoid things you find challenging. To boost your self-esteem, you need to identify the negative beliefs you have about yourself, then challenge them.\n\nWrite down other positive things about yourself, such as \"I'm thoughtful\" or \"I'm a great friend\" or \"I'm someone that people can trust\". Tranquill's journalling features are a great place to start!", url: "https://www.mind.org.uk/information-support/types-of-mental-health-problems/self-esteem/tips-to-improve-your-self-esteem/"),
            GuidedSection(title: "Depression", image: UIImage(named: "UnavailableGuided1")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Addiction", image: UIImage(named: "UnavailableGuided2")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Trauma", image: UIImage(named: "UnavailableGuided3")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Productivity", image: UIImage(named: "UnavailableGuided1")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Gratitude", image: UIImage(named: "UnavailableGuided2")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Boundaries", image: UIImage(named: "UnavailableGuided2")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Acceptance", image: UIImage(named: "UnavailableGuided3")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Family / Parental", image: UIImage(named: "UnavailableGuided2")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Religion and You", image: UIImage(named: "UnavailableGuided1")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Creativity", image: UIImage(named: "UnavailableGuided2")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Focus", image: UIImage(named: "UnavailableGuided3")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Grief", image: UIImage(named: "UnavailableGuided1")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "Manifestation", image: UIImage(named: "UnavailableGuided3")!, mainText: "Unavailable", subtext: "", url: ""),
            GuidedSection(title: "", image: UIImage(named: "ComingSoonGuidance")!, mainText: "Unavailable", subtext: "", url: ""),
        ]
        
    }

}
