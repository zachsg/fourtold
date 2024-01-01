//
//  HealthKitController.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/2/23.
//

import Foundation
import HealthKit
import SwiftUI

@Observable
class HealthKitController {
    var healthStore = HKHealthStore()
    
    // Steps
    var stepCountToday = 0
    var stepCountWeek = 0
    var stepCountWeekByDay: [Date: Int] = [:]
    var latestSteps: Date = .now
    
    // Zone 2
    var zone2Today = 0
    var zone2Week = 0
    var zone2WeekByDay: [Date: Int] = [:]
    var latestZone2: Date = .now
    
    // Walk/run distance
    var walkRunDistanceToday = 0.0
    var latestWalkRunDistance: Date = .now
    
    // VO2 max
    var cardioFitnessMostRecent = 0.0
    var latestCardioFitness: Date = .now
    
    // Time in Daylight
    var timeInDaylightToday = 0
    var timeInDaylightWeek = 0
    var timeInDaylightWeekByDay: [Date: Int] = [:]
    var latestTimeInDaylight: Date = .now
    
    // Mindful Minutes
    var mindfulMinutesToday = 0
    var latestMindfulMinutes: Date = .now
    var mindfulMinutesWeek = 0
    var mindfulMinutesWeekByDay: [Date: Int] = [:]
    
    init() {
        requestAuthorization()
    }
    
    // MARK: - Authorization
    func requestAuthorization() {
        let toRead = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .vo2Max)!,
            HKObjectType.quantityType(forIdentifier: .timeInDaylight)!,
            HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        ])
        let toShare = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        ])
            
        guard HKHealthStore.isHealthDataAvailable() else {
            print("health data not available!")
            return
        }
        
        healthStore.requestAuthorization(toShare: toShare, read: toRead) { success, error in
            if !success {
                print("\(String(describing: error))")
            }
        }
    }
    
    // MARK: - Steps
    func getStepCountToday(refresh: Bool = false) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        let startDate = Calendar.current.startOfDay(for: .now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: .now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            self.stepCountToday = steps
            self.latestSteps = result.endDate
        }
        
        if refresh {
            stepCountToday = 0
        }
        
        healthStore.execute(query)
    }
    
    func getStepCountWeek(refresh: Bool = false) {
        let calendar = Calendar.current
        
        // Set the anchor for 3 a.m. 6 days ago.
        let todayNumber = calendar.component(.weekday, from: .now)
        let sixDaysAgo = todayNumber == 7 ? 1 : todayNumber + 1
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            hour: 3,
            minute: 0,
            second: 0,
            weekday: sixDaysAgo
        )
        
        guard let anchorDate = calendar.nextDate(
            after: .now,
            matching: components,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .backward
        ) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: anchorDate,
            end: .now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            self.stepCountWeek = steps
        }
        
        if refresh {
            stepCountWeek = 0
        }
        
        healthStore.execute(query)
    }
    
    func getStepCountWeekByDay(refresh: Bool = false) {
        let calendar = Calendar.current
        
        // Create a 1-week interval.
        let interval = DateComponents(day: 1)
        
        // Set the anchor for 3 a.m. 6 days ago.
        let todayNumber = calendar.component(.weekday, from: .now)
        let sixDaysAgo = todayNumber == 7 ? 1 : todayNumber + 1
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            hour: 3,
            minute: 0,
            second: 0,
            weekday: sixDaysAgo
        )
        
        guard let anchorDate = calendar.nextDate(
            after: Date(),
            matching: components,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .backward
        ) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("*** Unable to create a step count type ***")
        }
                
        // Create the query.
        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: interval
        )
        
        // Set the results handler.
        query.initialResultsHandler = { query, results, error in
            // Handle errors here.
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    // HealthKit couldn't access the database because the device is locked.
                    return
                default:
                    // Handle other HealthKit errors here.
                    return
                }
            }
            
            guard let statsCollection = results else {
                // You should only hit this case if you have an unhandled error. Check for bugs
                // in your code that creates the query, or explicitly handle the error.
                assertionFailure("")
                return
            }
            
            let endDate = Date()
            let oneWeekAgo = DateComponents(day: -6)
            
            guard let startDate = calendar.date(byAdding: oneWeekAgo, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            // Enumerate over all the statistics objects between the start and end dates.
            statsCollection.enumerateStatistics(from: startDate, to: endDate)
            { (statistics, stop) in
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValue(for: .count())
                    
                    self.stepCountWeekByDay[date] = Int(value)
                }
            }
            
            // Dispatch to the main queue to update the UI.
            DispatchQueue.main.async {
                // Update UI
            }
        }
        
//        query.statisticsUpdateHandler = { query, statistics, collection, error in
//            guard let collection else {
//                print("no collection found")
//                return
//            }
//            
//            let endDate = Date()
//            let oneWeekAgo = DateComponents(day: -6)
//            guard let startDate = calendar.date(byAdding: oneWeekAgo, to: endDate) else {
//                fatalError("*** Unable to calculate the start date ***")
//            }
//            
//            collection.enumerateStatistics(from: startDate, to: Date()){ (statistics, stop) in
//                guard let quantity = statistics.sumQuantity() else {
//                    return
//                }
//                
//                let date = statistics.startDate
//                let value = quantity.doubleValue(for: .count())
//                
//                self.stepCountWeekByDay[date] = Int(value)
//                
//                DispatchQueue.main.async {
//                    // Update UI
//                }
//            }
//        }
        
        if refresh {
            stepCountWeekByDay = [:]
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Zone 2
    func getZone2Today(refresh: Bool = false) {
        @AppStorage(zone2ThresholdKey) var zone2Threshold: Int = zone2ThresholdDefault
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            fatalError("*** Unable to create a heart rate type ***")
        }
        
        let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        
        let startDate = Calendar.current.startOfDay(for: .now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: .now,
            options: .strictStartDate
        )
        
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
            guard error == nil else {
                print("error")
                return
            }
            
            var total = TimeInterval()
            var latest: Date = .distantPast
            var usedComponents: [DateComponents] = []
            for (_, sample) in results!.enumerated() {
                guard let currData:HKQuantitySample = sample as? HKQuantitySample else { return }
                
                let heartRate = currData.quantity.doubleValue(for: heartRateUnit)
                if heartRate >= Double(zone2Threshold) {
                    let components = sample.startDate.get(.minute, .hour)
                    if !usedComponents.contains(components) {
                        usedComponents.append(components)
                        total += 60
                    }

                    if sample.endDate > latest {
                        latest = sample.endDate
                    }
                }
            }
            
            self.zone2Today = Int((total / 60).rounded())
            self.latestZone2 = latest
        })
        
        if refresh {
            zone2Today = 0
        }
        
        healthStore.execute(query)
    }
    
    func getZone2Week(refresh: Bool = false) {
        @AppStorage(zone2ThresholdKey) var zone2Threshold: Int = zone2ThresholdDefault
        
        let calendar = Calendar.current
        
        // Set the anchor for 3 a.m. 6 days ago.
        let todayNumber = calendar.component(.weekday, from: .now)
        let sixDaysAgo = todayNumber == 7 ? 1 : todayNumber + 1
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            hour: 3,
            minute: 0,
            second: 0,
            weekday: sixDaysAgo
        )
        
        guard let anchorDate = calendar.nextDate(
            after: .now,
            matching: components,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .backward
        ) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: anchorDate,
            end: .now,
            options: .strictStartDate
        )
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            fatalError("*** Unable to create a heart rate type ***")
        }
        
        let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
            guard error == nil else {
                print("error")
                return
            }
            
            var total = TimeInterval()
            var latest: Date = .distantPast
            var usedComponents: [DateComponents] = []
            for (_, sample) in results!.enumerated() {
                guard let currData:HKQuantitySample = sample as? HKQuantitySample else { return }
                
                let heartRate = currData.quantity.doubleValue(for: heartRateUnit)
                if heartRate >= Double(zone2Threshold) {
                    let components = sample.startDate.get(.minute, .hour, .day)
                    if !usedComponents.contains(components) {
                        usedComponents.append(components)
                        total += 60
                    }
                    
                    if sample.endDate > latest {
                        latest = sample.endDate
                    }
                }
            }
            
            self.zone2Week = Int((total / 60).rounded())
            self.latestZone2 = latest
        })
        
        if refresh {
            zone2Week = 0
        }
        
        healthStore.execute(query)
    }
    
    func getZone2WeekByDay(refresh: Bool = false) {
        @AppStorage(zone2ThresholdKey) var zone2Threshold: Int = zone2ThresholdDefault
        
        let calendar = Calendar.current
        
        // Set the anchor for 3 a.m. 6 days ago.
        let todayNumber = calendar.component(.weekday, from: .now)
        let sixDaysAgo = todayNumber == 7 ? 1 : todayNumber + 1
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            hour: 3,
            minute: 0,
            second: 0,
            weekday: sixDaysAgo
        )
        
        guard let anchorDate = calendar.nextDate(
            after: .now,
            matching: components,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .backward
        ) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: anchorDate,
            end: .now,
            options: .strictStartDate
        )
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            fatalError("*** Unable to create a heart rate type ***")
        }
        
        let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
            guard error == nil else {
                print("error")
                return
            }
            
            var latest: Date = .distantPast
            var usedComponents: [DateComponents] = []
            
            for (_, sample) in results!.enumerated() {
                guard let currData:HKQuantitySample = sample as? HKQuantitySample else { return }
                
                let heartRate = currData.quantity.doubleValue(for: heartRateUnit)
                if heartRate >= Double(zone2Threshold) {
                    let components = sample.startDate.get(.minute, .hour, .day)
                    if !usedComponents.contains(components) {
                        usedComponents.append(components)
                        let date = calendar.startOfDay(for: sample.startDate)
                        let value = self.zone2WeekByDay[date] ?? 0
                        self.zone2WeekByDay[date] = value + 60
                    }
                    
                    if sample.endDate > latest {
                        latest = sample.endDate
                    }
                }
            }
            
            var checking: Date = calendar.startOfDay(for: .now)
            let dayInSeconds: TimeInterval = 86400
            for _ in 1...7 {
                if self.zone2WeekByDay[checking] != nil {
                    let value = self.zone2WeekByDay[checking] ?? 0
                    self.zone2WeekByDay[checking] = Int((Double(value) / 60).rounded())
                } else {
                    self.zone2WeekByDay[checking] = 0
                }
                checking = checking.addingTimeInterval(-dayInSeconds)
            }
            
            self.latestZone2 = latest
        })
        
        if refresh {
            zone2WeekByDay = [:]
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Distance
    func getWalkRunDistanceToday(refresh: Bool = false) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            fatalError("*** Unable to create a distance type ***")
        }
        
        let startDate = Calendar.current.startOfDay(for: .now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: .now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "")")
                return
            }
           
            let desiredLengthUnit = UnitLength(forLocale: .current)
            let lengthUnit = desiredLengthUnit == UnitLength.feet ? HKUnit.mile() : HKUnit.meter()
            
            // TODO: Fix to work with Km and not just Miles
            let distance = sum.doubleValue(for: lengthUnit)
            self.walkRunDistanceToday = distance
            self.latestWalkRunDistance = result.endDate
        }
        
        if refresh {
            walkRunDistanceToday = 0
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Cardio Fitness
    func getCardioFitnessRecent(refresh: Bool = false) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .vo2Max) else {
            fatalError("*** Unable to create a vo2max type ***")
        }
        
        let startDate = Calendar.current.startOfDay(for: .now.addingTimeInterval(-1029600))
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: .now,
            options: .strictStartDate
        )
        
        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: .none) { query, results, error in
            guard let samples = results as? [HKQuantitySample] else {
                return
            }
            
            var latest: Date = .distantPast
            var bestSample: HKQuantitySample?
            for sample in samples {
                if sample.endDate > latest {
                    latest = sample.endDate
                    bestSample = sample
                }
            }
            
            if let bestSample {
                let kgmin = HKUnit.gramUnit(with: .kilo).unitMultiplied(by: .minute())
                let mL = HKUnit.literUnit(with: .milli)
                let vo2Unit = mL.unitDivided(by: kgmin)
                self.cardioFitnessMostRecent = bestSample.quantity.doubleValue(for: vo2Unit)
                self.latestCardioFitness = bestSample.endDate
            }
            
            DispatchQueue.main.async {
                // Update the UI here.
            }
        }
        
        if refresh {
            cardioFitnessMostRecent = 0.0
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Time in Daylight
    func getTimeInDaylightToday(refresh: Bool = false) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .timeInDaylight) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        let startDate = Calendar.current.startOfDay(for: .now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: .now,
            options: .strictStartDate
        )
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            guard let samples else {
                if let error {
                    print(error.localizedDescription)
                }
                return
            }
            
            var total = 0
            var latest: Date = .distantPast
            for sample in samples {
                guard let hksample = sample as? HKQuantitySample else { return }
                let minutes = hksample.quantity.doubleValue(for: HKUnit.minute())
                
                total += Int(minutes)
                
                if sample.endDate > latest {
                    latest = sample.endDate
                }
            }
            
            self.timeInDaylightToday = total
            self.latestTimeInDaylight = latest
        }
        
        if refresh {
            timeInDaylightToday = 0
        }
        
        healthStore.execute(query)
    }
    
    func getTimeInDaylightWeek(refresh: Bool = false) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .timeInDaylight) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        let calendar = Calendar.current
        
        // Set the anchor for 3 a.m. 6 days ago.
        let todayNumber = calendar.component(.weekday, from: .now)
        let sixDaysAgo = todayNumber == 7 ? 1 : todayNumber + 1
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            hour: 3,
            minute: 0,
            second: 0,
            weekday: sixDaysAgo
        )
        
        guard let anchorDate = calendar.nextDate(
            after: .now,
            matching: components,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .backward
        ) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: anchorDate,
            end: .now,
            options: .strictStartDate
        )
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            guard let samples else {
                if let error {
                    print(error.localizedDescription)
                }
                return
            }
            
            var total = 0
            var latest: Date = .distantPast
            for sample in samples {
                guard let hksample = sample as? HKQuantitySample else { return }
                let minutes = hksample.quantity.doubleValue(for: HKUnit.minute())
                
                total += Int(minutes)
                
                if sample.endDate > latest {
                    latest = sample.endDate
                }
            }
            
            self.timeInDaylightWeek = total
            self.latestTimeInDaylight = latest
        }
        
        if refresh {
            timeInDaylightWeek = 0
        }
        
        healthStore.execute(query)
    }
    
    func getTimeInDaylightWeekByDay(refresh: Bool = false) {
        let calendar = Calendar.current
        
        // Create a 1-week interval.
        let interval = DateComponents(day: 1)
        
        // Set the anchor for 3 a.m. 6 days ago.
        let todayNumber = calendar.component(.weekday, from: .now)
        let sixDaysAgo = todayNumber == 7 ? 1 : todayNumber + 1
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            hour: 3,
            minute: 0,
            second: 0,
            weekday: sixDaysAgo
        )
        
        guard let anchorDate = calendar.nextDate(
            after: Date(),
            matching: components,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .backward
        ) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .timeInDaylight) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        // Create the query.
        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: interval
        )
        
        // Set the results handler.
        query.initialResultsHandler = { query, results, error in
            // Handle errors here.
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    // HealthKit couldn't access the database because the device is locked.
                    return
                default:
                    // Handle other HealthKit errors here.
                    return
                }
            }
            
            guard let statsCollection = results else {
                // You should only hit this case if you have an unhandled error. Check for bugs
                // in your code that creates the query, or explicitly handle the error.
                assertionFailure("")
                return
            }
            
            let endDate = Date()
            let oneWeekAgo = DateComponents(day: -6)
            
            guard let startDate = calendar.date(byAdding: oneWeekAgo, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            // Enumerate over all the statistics objects between the start and end dates.
            statsCollection.enumerateStatistics(from: startDate, to: endDate)
            { (statistics, stop) in
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValue(for: .minute())
                    
                    self.timeInDaylightWeekByDay[date] = Int(value)
                }
            }
            
            // Dispatch to the main queue to update the UI.
            DispatchQueue.main.async {
                // Update UI
            }
        }
        
        query.statisticsUpdateHandler = { query, statistics, collection, error in
            guard let collection else {
                print("no collection found")
                return
            }
            
            let endDate = Date()
            let oneWeekAgo = DateComponents(day: -6)
            guard let startDate = calendar.date(byAdding: oneWeekAgo, to: endDate) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            collection.enumerateStatistics(from: startDate, to: Date()){ (statistics, stop) in
                guard let quantity = statistics.sumQuantity() else {
                    return
                }
                
                let date = statistics.startDate
                let value = quantity.doubleValue(for: .count())
                
                self.timeInDaylightWeekByDay[date] = Int(value)
                
                DispatchQueue.main.async {
                    // Update UI
                }
            }
        }
        
        if refresh {
            timeInDaylightWeekByDay = [:]
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Mindful Minutes
    func getMindfulMinutesToday(refresh: Bool = false) {
        guard let sampleType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        let startDate = Calendar.current.startOfDay(for: .now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: .now,
            options: .strictStartDate
        )
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            guard let samples else {
                if let error {
                    print(error.localizedDescription)
                }
                return
            }
            
            var total = TimeInterval()
            var latest: Date = .distantPast
            for sample in samples {
                total += sample.endDate.timeIntervalSince(sample.startDate)
                
                if sample.endDate > latest {
                    latest = sample.endDate
                }
            }
            
            self.mindfulMinutesToday = Int((total / 60).rounded())
            self.latestMindfulMinutes = latest
        }
        
        if refresh {
            mindfulMinutesToday = 0
        }
        
        healthStore.execute(query)
    }
    
    func getMindfulMinutesWeek(refresh: Bool = false) {
        guard let sampleType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        let calendar = Calendar.current
        
        // Set the anchor for 3 a.m. 6 days ago.
        let todayNumber = calendar.component(.weekday, from: .now)
        let sixDaysAgo = todayNumber == 7 ? 1 : todayNumber + 1
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            hour: 3,
            minute: 0,
            second: 0,
            weekday: sixDaysAgo
        )
        
        guard let anchorDate = calendar.nextDate(
            after: .now,
            matching: components,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .backward
        ) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: anchorDate,
            end: .now,
            options: .strictStartDate
        )

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            guard let samples else {
                if let error {
                    print(error.localizedDescription)
                }
                return
            }
            
            var total = TimeInterval()
            var latest: Date = .distantPast
            for sample in samples {
                total += sample.endDate.timeIntervalSince(sample.startDate)
                
                if sample.endDate > latest {
                    latest = sample.endDate
                }
            }
            
            self.mindfulMinutesWeek = Int((total / 60).rounded())
            self.latestMindfulMinutes = latest
        }
        
        if refresh {
            mindfulMinutesWeek = 0
        }
        
        healthStore.execute(query)
    }
    
    func getMindfulMinutesWeekByDay(refresh: Bool = false) {
        guard let sampleType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        let calendar = Calendar.current
        
        // Set the anchor for 3 a.m. 6 days ago.
        let todayNumber = calendar.component(.weekday, from: .now)
        let sixDaysAgo = todayNumber == 7 ? 1 : todayNumber + 1
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            hour: 3,
            minute: 0,
            second: 0,
            weekday: sixDaysAgo
        )
        
        guard let anchorDate = calendar.nextDate(
            after: .now,
            matching: components,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .backward
        ) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: anchorDate,
            end: .now,
            options: .strictStartDate
        )
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            guard let samples else {
                if let error {
                    print(error.localizedDescription)
                }
                return
            }
            
            let today: Date = .now
            for i in 0...6 {
                let date = calendar.date(byAdding: .day, value: -i, to: today)
                if let date {
                    self.mindfulMinutesWeekByDay[date] = 0
                }
            }
            
            for (day, _) in self.mindfulMinutesWeekByDay {
                var total = TimeInterval()
                
                for sample in samples {
                    if calendar.isDate(sample.startDate, inSameDayAs: day) {
                        total += sample.endDate.timeIntervalSince(sample.startDate)
                    }
                }
                
                self.mindfulMinutesWeekByDay[day] = Int((total / 60).rounded())
            }
            
            DispatchQueue.main.async {
                // Update UI
            }
        }
        
        if refresh {
            mindfulMinutesWeekByDay = [:]
        }
        
        healthStore.execute(query)
    }
    
    func setMindfulMinutes(seconds: Int, startDate: Date) {
        if let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
            
            let endDate = Calendar.current.date(byAdding: .second, value: seconds, to: startDate) ?? .now
            let mindfulSample = HKCategorySample(type: mindfulType, value: HKCategoryValue.notApplicable.rawValue, start: startDate, end: endDate)
            
            healthStore.save(mindfulSample, withCompletion: { (success, error) -> Void in
                if success {
                   // Saved to Apple Health
                } else {
                    // Something wrong
                    if let error {
                        print(error.localizedDescription)
                    }
                }
                
            })
        }
    }
}
