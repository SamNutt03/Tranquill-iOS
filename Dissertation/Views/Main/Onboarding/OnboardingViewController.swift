//
//  OnboardingViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 24/12/2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet var backgroundImg: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    
    func checkNotiPermissions() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchJournalNotification()
                        self.dispatchMindfulNotification()
                        if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 66 {
                            self.dispatchJournalMindfulNotification()
                        }
                    }
                }
            case .denied:
                return
            case .authorized:
                self.dispatchJournalNotification()
                self.dispatchMindfulNotification()
                if UserDefaults.standard.object(forKey: "mindfulTime") as! Int == 66 {
                    self.dispatchJournalMindfulNotification()
                }
            default:
                return
            }
        }
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "journallingTime") == nil {
            UserDefaults.standard.setValue("09:00", forKey: "journallingTime")
        }
        
        guard let url = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") else { return }
        PlayerManager.shared.setupPlayer(with: url)
        if UserDefaults.standard.object(forKey: "appMuted") == nil {
            GlobalVariables.appMusicMuted = 1
        }else if (UserDefaults.standard.object(forKey: "appMuted") as? Bool) == true {
            GlobalVariables.appMusicMuted = 1
        }else if (UserDefaults.standard.object(forKey: "appMuted") as? Bool) == false {
            GlobalVariables.appMusicMuted = 0
            PlayerManager.shared.play()
        }
                
        if UserDefaults.standard.object(forKey: "mindfulTime") == nil {
            UserDefaults.standard.setValue(3600, forKey: "mindfulTime")
        }
        
        checkNotiPermissions()
        
        
        if UserDefaults.standard.object(forKey: "onboarding") as? String == "OnboardingOFF" {
            let mainAppViewController = storyboard?.instantiateViewController(withIdentifier: "HomeTBC") as! UITabBarController
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window{
                
                window.rootViewController = mainAppViewController
                
                UIView.transition(with: window,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
            }
        }else{
            UserDefaults.standard.setValue("OnboardingON", forKey: "onboarding")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults.standard.object(forKey: "currentTheme") == nil {
            UserDefaults.standard.setValue("cloud", forKey: "currentTheme")
            backgroundImg.image = UIImage(named: "LightBGImage")
        }
        if UserDefaults.standard.object(forKey: "currentTheme") as! String == "cloud" {
            backgroundImg.image = UIImage(named: "LightBGImage")
        }
        if UserDefaults.standard.object(forKey: "currentTheme") as! String == "flower" {
            backgroundImg.image = UIImage(named: "DarkBGImage")
        }
        
        
        slides = [
            OnboardingSlide(title: "Welcome To Tranquill!", description: "Your place for reflection, guided insight and mindfulness.", image: UIImage(named: "Onboarding1")!),
            OnboardingSlide(title: "Take Control.", description: "Take control of your thoughts by journaling or explore mental health resources.", image: UIImage(named: "Onboarding2")!),
            OnboardingSlide(title: "Improvement. One Step At A Time.", description: "Let us know how this app helps you by leaving feedback <3", image: UIImage(named: "Onboarding3")!)]
        
        
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            showMainVC()
        } else {
            currentPage = currentPage + 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func showMainVC(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "HomeTBC") as! UITabBarController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }

}


extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }

}
