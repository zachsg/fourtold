//
//  HealthKitController.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/2/23.
//

import Foundation
import HealthKit

@Observable
class HealthKitController {
    var healthStore = HKHealthStore()
    
    // Steps
    var stepCountToday = 0
    var stepCountWeek = 0
    var stepCountWeekByDay: [Date: Int] = [:]
    var latestSteps: Date = .now
    
    // Walk/run distance
    var walkRunDistanceToday = 0.0
    var latestWalkRunDistance: Date = .now
    
    // Cardio
    var cardioFitnessMostRecent = 0.0
    var latestCardioFitness: Date = .now
    
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
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .vo2Max)!,
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
    func getStepCountToday() {
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
        
        healthStore.execute(query)
    }
    
    func getStepCountWeek() {
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
        
        healthStore.execute(query)
    }
    
    func getStepCountWeekByDay() {
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
                print("dispatching to main queue")
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
                
                self.stepCountWeekByDay[date] = Int(value)
                
                DispatchQueue.main.async{
                    //
                }
            }
            
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Distance
    func getWalkRunDistanceToday() {
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
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
           
            let desiredLengthUnit = UnitLength(forLocale: .current)
            let lengthUnit = desiredLengthUnit == UnitLength.feet ? HKUnit.mile() : HKUnit.meter()
            
            // TODO: Fix to work with Km and not just Miles
            let distance = sum.doubleValue(for: lengthUnit)
            self.walkRunDistanceToday = distance
            self.latestWalkRunDistance = result.endDate
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Cardio Fitness
    func getCardioFitnessRecent() {
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
        
        healthStore.execute(query)
    }
    
    // MARK: - Mindful Minutes
    func getMindfulMinutesToday() {
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
        
        healthStore.execute(query)
    }
    
    func getMindfulMinutesRecent() {
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
            for sample in samples {
                total += sample.endDate.timeIntervalSince(sample.startDate)
            }
            
            self.mindfulMinutesWeek = Int((total / 60).rounded())
        }
        
        healthStore.execute(query)
    }
    
    func getMindfulMinutesWeekByDay() {
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
        }
        
        mindfulMinutesWeekByDay = [:]
        
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
