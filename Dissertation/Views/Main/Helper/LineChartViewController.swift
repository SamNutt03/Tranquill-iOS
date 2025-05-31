//
//  MoodChartViewController.swift
//  Dissertation
//
//  Created by Sam Nuttall on 10/04/2024.
//

import SwiftUI
import UIKit

class LineChartViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        for view in view.subviews{
            view.removeFromSuperview()
        }
        setupView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupView() {
        let controller = UIHostingController(rootView: LineChartSetup())
        guard let chartView = controller.view else {
            return
        }
        chartView.contentMode = .center
        self.view.contentMode = .scaleToFill
        self.view.backgroundColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.15)
        self.view.layer.cornerRadius = 20
        self.view.layer.borderWidth = 3
        self.view.layer.borderColor = GlobalVariables.globalAccentColour?.withAlphaComponent(0.33).cgColor
        
        view.addSubview(chartView)
    }

}
