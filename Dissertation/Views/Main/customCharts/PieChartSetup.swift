//
//  BarChartSetup.swift
//  Dissertation
//
//  Created by Sam Nuttall on 10/04/2024.
//

import UIKit
import SwiftUI
import Charts


struct PieModel: Identifiable {
    let id = UUID()
    let mood: String
    let count: Int
}

struct PieChartSetup: View {
    
    let list = [
        PieModel(mood: "Great :D", count: GlobalVariables.greatMoodCount!),
        PieModel(mood: "Good :)", count: GlobalVariables.goodMoodCount!),
        PieModel(mood: "Meh :|", count: GlobalVariables.mehMoodCount!),
        PieModel(mood: "Bad :(", count: GlobalVariables.badMoodCount!)
    ]
    
    let chartColors = [
        Color(UIColor.systemGreen),
        Color(UIColor.green),
        Color(UIColor.systemOrange),
        Color(UIColor.systemRed)
    ]
    
    var body: some View{
        if (GlobalVariables.greatMoodCount! == 0) && (GlobalVariables.goodMoodCount! == 0) && (GlobalVariables.mehMoodCount! == 0) && (GlobalVariables.badMoodCount! == 0) {
            Text("No Moods Tracked Yet!\n\nUse the 'Journal' tab to make some entries.").frame(width: 300, height: 300).position(x: 175, y: 175).foregroundStyle(Color(GlobalVariables.globalAccentColour!)).multilineTextAlignment(.center)
        }else{
            Chart() {
                ForEach(list, id: \.mood) { mood in
                    SectorMark(
                        angle: .value("Mood", mood.count),
                        angularInset: 3
                    ).cornerRadius(6)
                        .foregroundStyle(by: .value("Mood", mood.mood))
                        .shadow(color: Color(GlobalVariables.globalAccentColour!), radius: 2)
                        .annotation(position: .overlay) {
                            Text(mood.count == 0 ? "" : "\(mood.count)")
                                .font(.caption)
                                .fontWeight(.heavy)
                                .padding(5)
                                .foregroundStyle(Color.black)
                        }
                }
            }
            .chartLegend(position: .bottom, alignment: .center)
            .chartForegroundStyleScale(
                domain: list.map {$0.mood},
                range: chartColors
            )
            .frame(width: 300, height: 300)
            .position(x: 175, y: 175)
            .backgroundStyle(Color.clear)
            .foregroundStyle(Color(GlobalVariables.globalAccentColour!))
        }
    }
}
