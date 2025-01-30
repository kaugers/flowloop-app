//
//  StatisticsView.swift
//  flowloop
//
//  Created by Viesturs Kaugers  on 29/04/2021.
//  Copyright © 2021 Viesturs Kaugers. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
    @ObservedObject var statistics = Statistics.shared
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Flows")
                .font(.largeTitle)
                .frame(width: 300)
                .padding()
            Text("Today: \(statistics.dailyFlows)\nWeek: \(statistics.weeklyFlows)\nMonth: \(statistics.monthlyFlows)")
                .font(.title)
                .frame(width: 300)
                .padding()
            Text("Loops")
                .font(.largeTitle)
                .frame(width: 300)
                .padding()
            Text("Today: \(statistics.dailyLoops)\nWeek: \(statistics.weeklyLoops)\nMonth: \(statistics.monthlyLoops)")
                .font(.title)
                .frame(width: 300)
                .padding()
            
            Button("Reset") {
                print("reset statistics")
                Statistics.shared.reset()
            }.padding(.bottom, 30)
            
//            Button("test") {
//                print("test statistics")
//                Statistics.shared.reset()
//                Statistics.shared.test()
//            }.padding(.bottom, 30)
        }
        .padding(5)
    }
}
