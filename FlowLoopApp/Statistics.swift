//
//  Statistics.swift
//  flowloop
//
//  Created by Viesturs Kaugers  on 27/04/2021.
//  Copyright © 2021 flowloop.io. All rights reserved.
//

import Foundation

struct StatisticsData: Codable {
    var loops: Int
    var flows: Int
    
    init(loops: Int, flows: Int) {
        self.loops = loops
        self.flows = flows
    }
}

class Statistics: ObservableObject {
    static let shared = Statistics()
    private var statistics:[String:StatisticsData] = [:]
    
    @Published var dailyFlows: Int = 0;
    @Published var weeklyFlows: Int = 0;
    @Published var monthlyFlows: Int = 0;
    
    @Published var dailyLoops: Int = 0;
    @Published var weeklyLoops: Int = 0;
    @Published var monthlyLoops: Int = 0;
    
    private static var key = "statistics"
    
    private init() {
        self.load()
    }
    
    private func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
                
        return formatter.string(from: Date())
    }
    
    func incFlow() {
        if var stats = self.statistics[self.currentDate()] {
            stats.flows += 1
            self.statistics[self.currentDate()] = stats
        } else {
            self.statistics[self.currentDate()] = StatisticsData(loops: 0, flows: 1)
        }
        
        save()
    }
    
    func incLoop() {
        if var stats = self.statistics[self.currentDate()] {
            stats.loops += 1
            self.statistics[self.currentDate()] = stats
        } else {
            self.statistics[self.currentDate()] = StatisticsData(loops: 1, flows: 0)
        }
        
        save()
    }
    
    func update() -> Void {
        flowsDaily()
        flowsWeekly()
        flowsMonthly()
        
        loopsDaily()
        loopsWeekly()
        loopsMonthly()
    }
    
    func save() -> Void {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(statistics) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: Statistics.key)
        }
        
        update()
    }

    func load() -> Void {
        guard let data = UserDefaults.standard.data(forKey: Statistics.key) else {
            self.statistics.removeAll()
            return
        }
        
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode([String:StatisticsData].self, from: data)
        
        self.statistics = decoded
        
        update()
    }
    
    func reset() -> Void {
        self.statistics.removeAll()
        self.save()
    }
    
    func getStatistics() -> [String:StatisticsData] {
        self.load()
        return statistics
    }
    
    func getFlowsInRange(range: Int) -> Int {
        let stats = self.statistics
        let today = Date()
        let formatter = DateFormatter()
        var modifiedDate = Date()
        var flows = 0
        formatter.dateFormat = "dd.MM.yyyy"
        
        for i in 0...range {
            modifiedDate = Calendar.current.date(byAdding: .day, value: -i, to: today)!
            if let f = stats[formatter.string(from: modifiedDate)]?.flows {
                flows += f
            }
        }

        return flows
    }
    
    func getLoopsInRange(range: Int) -> Int {
        let stats = self.statistics
        let today = Date()
        let formatter = DateFormatter()
        var modifiedDate = Date()
        var loops = 0
        formatter.dateFormat = "dd.MM.yyyy"
        
        for i in 0...range {
            modifiedDate = Calendar.current.date(byAdding: .day, value: -i, to: today)!
            if let l = stats[formatter.string(from: modifiedDate)]?.loops {
                loops += l
            }
        }

        return loops
    }
    
    func addLoop(date: String) {
        if var stats = self.statistics[date] {
            stats.loops += 1
            self.statistics[date] = stats
        } else {
            self.statistics[date] = StatisticsData(loops: 1, flows: 0)
        }
        
        save()
    }
    
    func addFlow(date: String) {
        if var stats = self.statistics[date] {
            stats.flows += 1
            self.statistics[date] = stats
        } else {
            self.statistics[date] = StatisticsData(loops: 0, flows: 1)
        }
        
        save()
    }
    
    func flowsDaily() {
        self.dailyFlows = getFlowsInRange(range: 0)
    }
    
    func flowsWeekly() {
        self.weeklyFlows = getFlowsInRange(range: 6)
    }
    
    func flowsMonthly() {
        self.monthlyFlows = getFlowsInRange(range: 30)
    }
    
    func loopsDaily() {
        self.dailyLoops = getLoopsInRange(range: 0)
    }
    
    func loopsWeekly() {
        self.weeklyLoops = getLoopsInRange(range: 6)
    }
    
    func loopsMonthly() {
        self.monthlyLoops = getLoopsInRange(range: 3)
    }
        
    // dirty tests -----------------------
    
    func test() {
        reset()
        
        test3FlowsDay(date: "10.08.2021")
        test4LoopsDay(date: "10.08.2021")
        
        test3FlowsPerDayInOneWeek()
        test4LoopsPerDayInOneWeek()
        
        test3FlowsPerDayInOneMonth()
        test4LoopsPerDayInOneMonth()
    }
    
    func test3FlowsDay(date: String) {
        addFlow(date: date)
        addFlow(date: date)
        addFlow(date: date)
    }
    
    func test4LoopsDay(date: String) {
        addLoop(date: date)
        addLoop(date: date)
        addLoop(date: date)
        addLoop(date: date)
    }
    
    func test3FlowsPerDayInOneWeek() {
        test3FlowsDay(date: "26.08.2021")
        test3FlowsDay(date: "25.08.2021")
        test3FlowsDay(date: "24.08.2021")
        test3FlowsDay(date: "23.08.2021")
        test3FlowsDay(date: "22.08.2021")
        test3FlowsDay(date: "21.08.2021")
    }
    
    func test4LoopsPerDayInOneWeek() {
        test4LoopsDay(date: "26.08.2021")
        test4LoopsDay(date: "25.08.2021")
        test4LoopsDay(date: "24.08.2021")
        test4LoopsDay(date: "23.08.2021")
        test4LoopsDay(date: "22.08.2021")
        test4LoopsDay(date: "21.08.2021")
    }
    
    func test3FlowsPerDayInOneMonth() {
        test3FlowsDay(date: "20.08.2021")
        test3FlowsDay(date: "19.08.2021")
        test3FlowsDay(date: "18.08.2021")
        test3FlowsDay(date: "17.08.2021")
        test3FlowsDay(date: "16.08.2021")
        test3FlowsDay(date: "15.08.2021")
        test3FlowsDay(date: "14.08.2021")
        
        test3FlowsDay(date: "13.08.2021")
        test3FlowsDay(date: "12.08.2021")
        test3FlowsDay(date: "11.08.2021")
        test3FlowsDay(date: "10.08.2021")
        test3FlowsDay(date: "09.08.2021")
        test3FlowsDay(date: "08.08.2021")
        test3FlowsDay(date: "07.08.2021")
        
        test3FlowsDay(date: "06.08.2021")
        test3FlowsDay(date: "05.08.2021")
        test3FlowsDay(date: "04.08.2021")
        test3FlowsDay(date: "03.08.2021")
        test3FlowsDay(date: "02.08.2021")
        test3FlowsDay(date: "01.08.2021")
    }
    
    func test4LoopsPerDayInOneMonth() {
        test4LoopsDay(date: "20.08.2021")
        test4LoopsDay(date: "19.08.2021")
        test4LoopsDay(date: "18.08.2021")
        test4LoopsDay(date: "17.08.2021")
        test4LoopsDay(date: "16.08.2021")
        test4LoopsDay(date: "15.08.2021")
        test4LoopsDay(date: "14.08.2021")
        
        test4LoopsDay(date: "13.08.2021")
        test4LoopsDay(date: "12.08.2021")
        test4LoopsDay(date: "11.08.2021")
        test4LoopsDay(date: "10.08.2021")
        test4LoopsDay(date: "09.08.2021")
        test4LoopsDay(date: "08.08.2021")
        test4LoopsDay(date: "07.08.2021")
        
        test4LoopsDay(date: "06.08.2021")
        test4LoopsDay(date: "05.08.2021")
        test4LoopsDay(date: "04.08.2021")
        test4LoopsDay(date: "03.08.2021")
        test4LoopsDay(date: "02.08.2021")
        test4LoopsDay(date: "01.08.2021")
    }
}
