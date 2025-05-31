//
//  LineChartSetup.swift
//  Dissertation
//
//  Created by Sam Nuttall on 10/04/2024.
//

import UIKit
import SwiftUI
import Charts
import CoreData


struct PlotModel: Identifiable {
    let id = UUID()
    let mood: Int
    let date: Date
}

struct LineChartSetup: View {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func convertToLineModels(journalItems: [JournalItem]) -> [PlotModel] {
        var plotModels: [PlotModel] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        for item in journalItems {
            var mood = Int()
            if item.mood == "Great" {
                mood = 4
            }else if item.mood == "Good" {
                mood = 3
            }else if item.mood == "Meh" {
                mood = 2
            }else if item.mood == "Bad" {
                mood = 1
            }else if item.mood == "" {
                mood = 0
            }
            let date = dateFormatter.date(from: item.createdDate!)!
            let plotModel = PlotModel(mood: mood, date: date)
            plotModels.append(plotModel)
        }
        
        return plotModels
    }
    
    func getColorForMood(mood: Int) -> Color {
        var colour = Color(.black)
        if mood == 4 {
            colour = Color(.systemGreen)
        }else if mood == 3 {
            colour = Color(.green)
        }else if mood == 2 {
            colour = Color(.systemOrange)
        }else if mood == 1 {
            colour = Color(.systemRed)
        }
        return colour
    }
    
    var body: some View{
        let fetchRequest: NSFetchRequest<JournalItem> = JournalItem.fetchRequest()
        let journalItems = try! context.fetch(fetchRequest)
        let plotModels = convertToLineModels(journalItems: journalItems)
                    
        Chart {
            ForEach(plotModels, id: \.id) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Mood", item.mood)
                )
                    .symbolSize(50)
            }.foregroundStyle(
                .linearGradient(
                    colors: [Color(uiColor: .systemGreen), Color(uiColor: .green), Color(uiColor: .systemOrange), Color(uiColor: .systemRed), Color(uiColor: .white)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }.chartLegend(position: .bottom, alignment: .center)
            .navigationTitle("Mood over time")
            .frame(width: 300, height: 300)
            .position(x: 175, y: 175)
            .backgroundStyle(Color.clear)
            .foregroundStyle(Color(GlobalVariables.globalAccentColour!))
            .chartXAxisLabel("4 = Great :D 3 = Good :) 2 = Meh :| 1 = Bad :( 0 = No Log", position: .automatic)
            .chartYAxisLabel("Mood Plotted Against Date Allowing Mood Tracking     ", position: .top)
            .chartYAxis{AxisMarks(values: .automatic)}
            .chartXAxis{AxisMarks(values: .automatic(desiredCount: 6))}
    }
}

