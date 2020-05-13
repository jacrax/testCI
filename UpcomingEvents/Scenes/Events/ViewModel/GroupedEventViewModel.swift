//
//  GroupedEventViewModel.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/6/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

/// This class represent the ViewModel presenting the main TableView in EventsViewController
/// It contains the dateString to be used as a header and the array of events for each day.
class GroupedEventViewModel {
   
    var dateString: String
    var events: [EventViewModel]
    
    private lazy var dateFormatter: DateFormatter =  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/yy"
        return dateFormatter
    }()
    
    var date: Date? {
        return dateFormatter.date(from: dateString)
    }
    
    init(dateString: String, events: [EventViewModel]) {
        self.dateString = dateString
        self.events = events
        orderEvents()
    }
    
    /// Order function to set the events order by date
    private func orderEvents() {
        var orderedEvents = [EventViewModel]()
        orderedEvents = events.sorted(by: { (event1, event2) -> Bool in
            guard let startDate1 = event1.startDate, let startDate2 = event2.startDate else { return false }
            return startDate1.compare(startDate2) == .orderedAscending
        })
        updateConflictEvents(orderedEvents: orderedEvents)
    }
    
    /// This function goes through the array of events finding all the elements that have conflicts between them. A conflict exist when the date range for each event overlaps with another one.
    /// Please note that a event ending at the same time that another one begins is not considered to be overlaped
    private func updateConflictEvents(orderedEvents: [EventViewModel]) {
        // First get the events in ascending order so it will be more easy to go through the array
        // Make a copy of the array of events as the parameter passed to the function is immutable.
        let events = orderedEvents
        
        // First thing is to go through the array starting from the begining. What we want to do is to compare each element of the array to
        // every other element in the array, but we just want to do it one time such as comparing element[0] and element[1] will be the same as comparing element[1] and element[0]
        // Ex.
        // let arr = [1, 2, 4, 5, 9, 10, 11, 12]
        // The number of comparisions will be
        // 1 against 2     2 against 4    4 against 5    5 against 9    9 against 10   10 against 11   11 against 12
        // 1 against 4     2 against 5    4 against 9    5 against 10   9 against 11   10 against 12
        // 1 against 5     2 against 9    4 against 10   5 against 11   9 against 12
        // 1 against 9     2 against 10   4 against 11   5 against 12
        // 1 against 10    2 against 11   4 against 12
        // 1 against 11    2 against 12
        // 1 against 12
        //
        // This approach reduces the time of execution from a potential O(n^2) (Nested for loop for all elements of array) to a roughly
        // O(n * log n). This because of the running time consist of N loops that are logarithmic thus the algorithm is a combination of linear and logarithmic. Even though we are sorting first, this will still be O(n * log n)
        // 
        
        for i in 0..<events.count {
            for k in stride(from: i+1, to: events.count, by: 1) {
                guard let startDate = events[i].startDate,
                    let endDate = events[i].endDate,
                    let comparableStartDate = events[k].startDate,
                    let comparableEndDate = events[k].endDate else { return }
                // Compare the event range to find if events are overlapping. If this two events overlaps (Meaning happening at the same time) mark the hasConflict property as true
                if startDate < comparableEndDate && endDate > comparableStartDate {
                    events[k].hasConflict = true
                    events[i].hasConflict = true
                }
                
            }
        }
        
        self.events = events
    }
}
