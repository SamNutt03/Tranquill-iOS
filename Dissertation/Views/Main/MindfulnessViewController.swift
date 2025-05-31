//
//  MindfulnessViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 26/12/2023.
//

import UIKit

class MindfulnessViewController: UIViewController {
    
    @IBOutlet var mainImage: UIImageView!
    var selectedVid : String = "Coral"

    @IBOutlet var selectedTitle: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBAction func backButton(_ sender: UIButton) {
        if selectedVid == "Coral" {
            selectedVid = "Temp"
            changeCurrent()
        }else if selectedVid == "yellowFlower" {
            selectedVid = "Coral"
            changeCurrent()
        }else if selectedVid == "Ocean" {
            selectedVid = "yellowFlower"
            changeCurrent()
        }else if selectedVid == "Temp" {
            selectedVid = "Ocean"
            changeCurrent()
        }
    }
    @IBAction func fwdButton(_ sender: UIButton) {
        if selectedVid == "Coral" {
            selectedVid = "yellowFlower"
            changeCurrent()
        }else if selectedVid == "yellowFlower" {
            selectedVid = "Ocean"
            changeCurrent()
        }else if selectedVid == "Ocean" {
            selectedVid = "Temp"
            changeCurrent()
        }else if selectedVid == "Temp" {
            selectedVid = "Coral"
            changeCurrent()
        }
    }
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var fwdBtn: UIButton!
    
    @IBOutlet var M1BtnOut: UIButton!
    @IBAction func M1Btn(_ sender: UIButton) {
        selectedVid = "Coral"
        changeCurrent()
    }
    
    @IBOutlet var M2BtnOut: UIButton!
    @IBAction func M2Btn(_ sender: UIButton) {
        selectedVid = "yellowFlower"
        changeCurrent()
    }
    
    @IBOutlet var M3BtnOut: UIButton!
    @IBAction func M3Btn(_ sender: UIButton) {
        selectedVid = "Ocean"
        changeCurrent()
        
    }
    
    @IBOutlet var M4BtnOut: UIButton!
    @IBAction func M4Btn(_ sender: UIButton) {
        selectedVid = "Temp"
        changeCurrent()
    }
    
    
    @IBOutlet var goBtnOut: UIButton!
    @IBAction func buttonTemp(_ sender: UIButton) {
        if selectedVid != "Temp" {
            self.performSegue(withIdentifier: "toMindfulness", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMindfulness" {
            let vc = segue.destination as! MindVideoViewController
            vc.video = selectedVid
            PlayerManager.shared.pause()
        }
    }
    
    func resetBtns(){
        M1BtnOut.layer.borderWidth = 0
        M2BtnOut.layer.borderWidth = 0
        M3BtnOut.layer.borderWidth = 0
        M4BtnOut.layer.borderWidth = 0
    }
    
    func curvedShapeFor(view: UIImageView) ->UIBezierPath
    {
        let path = UIBezierPath()
        path.move(to: CGPoint(x:0, y:0))
        path.addLine(to: CGPoint(x:view.bounds.size.width, y:0))
        path.addQuadCurve(to: CGPoint(x:view.bounds.size.width*0.9, y:view.bounds.size.height), controlPoint: CGPoint(x: view.bounds.size.width-5, y: view.bounds.size.height+8))
        path.addQuadCurve(to: CGPoint(x: view.bounds.size.width*0.1, y: view.bounds.size.height), controlPoint: CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height-100))
        path.addQuadCurve(to: CGPoint(x:0, y:0), controlPoint: CGPoint(x: 5, y: view.bounds.size.height+8))
        path.close()

        return path
    }
    
    func changeCurrent(){
        if selectedVid == "Coral" {
            resetBtns()
            goBtnOut.tintColor = .systemBlue
            mainImage.image = UIImage(named: "mindfulSS1")
            M1BtnOut.layer.borderWidth = 4
            selectedTitle.text = "Coral - (52s)"
            descriptionLabel.text = "This session is aimed towards finding calm through noise and movement. Let the subtle bubbles and randomness of the coral's movement will guide your mind."
            selectedTitle.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
            descriptionLabel.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
        }else if selectedVid == "yellowFlower" {
            resetBtns()
            goBtnOut.tintColor = .systemBlue
            M2BtnOut.layer.borderWidth = 4
            selectedTitle.text = "Floral - (1m)"
            descriptionLabel.text = "This floral themed exercise follows the flower as it sways in the gentle wind. Allow your mind to relax and follow the breeze."
            selectedTitle.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.5)
            descriptionLabel.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.5)
            mainImage.image = UIImage(named: "mindfulSS2")
        }else if selectedVid == "Ocean" {
            resetBtns()
            goBtnOut.tintColor = .systemBlue
            mainImage.image = UIImage(named: "mindfulSS3")
            M3BtnOut.layer.borderWidth = 4
            selectedTitle.text = "Ocean - (3m)"
            descriptionLabel.text = "This session is a more extended period. 3 minutes of wonder of the unknown, or known. Soothing whale calls guide your thoughts to what has been or what could be."
            selectedTitle.backgroundColor = UIColor.systemBlue.withAlphaComponent(1)
            descriptionLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(1)
        }else if selectedVid == "Temp" {
            resetBtns()
            goBtnOut.tintColor = .systemGray
            M4BtnOut.layer.borderWidth = 4
            mainImage.image = UIImage(named: "mindfulTempMain")
            selectedTitle.text = "Coming Soon..."
            descriptionLabel.text = "Time to get excited! This new mindfulness session will be available soon :)"
            descriptionLabel.backgroundColor = UIColor.systemBrown.withAlphaComponent(1)
            selectedTitle.backgroundColor = UIColor.systemBrown.withAlphaComponent(1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        goBtnOut.configuration?.baseForegroundColor = GlobalVariables.globalAccentColour
        goBtnOut.tintColor = GlobalVariables.globalAccentColour
        fwdBtn.tintColor = GlobalVariables.globalAccentColour
        backBtn.tintColor = GlobalVariables.globalAccentColour
        selectedTitle.text = "Coral - 52s"
        selectedTitle.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
        M1BtnOut.layer.borderWidth = 4
        M1BtnOut.layer.borderColor = GlobalVariables.globalAccentColour?.cgColor
        M2BtnOut.layer.borderColor = GlobalVariables.globalAccentColour?.cgColor
        M3BtnOut.layer.borderColor = GlobalVariables.globalAccentColour?.cgColor
        M4BtnOut.layer.borderColor = GlobalVariables.globalAccentColour?.cgColor
        changeCurrent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shapeLayer = CAShapeLayer(layer: mainImage.layer)
        shapeLayer.path = self.curvedShapeFor(view: mainImage).cgPath
        shapeLayer.frame = mainImage.bounds
        shapeLayer.masksToBounds = true
        mainImage.layer.mask = shapeLayer
    }
}
