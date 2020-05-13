//
//  EventViewModel.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

/// ViewModel used to represent each cell of the Event List
class EventViewModel {
    var eventTitle: String
    var eventStart: String
    var eventEnd: String
    var hasConflict: Bool
    
    private lazy var dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
       return dateFormatter
    }()
    
    private lazy var shortNameDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }()
    
    init(title: String, start: String, end: String, hasConflict: Bool) {
        self.eventTitle = title
        self.eventStart = start
        self.eventEnd = end
        self.hasConflict = hasConflict
    }
    
    init() {
        eventTitle = ""
        eventStart = ""
        eventEnd = ""
        hasConflict = false
    }
    
    var startDate: Date? {
        return dateFormatter.date(from: eventStart)
    }
    
    var endDate: Date? {
        return dateFormatter.date(from: eventEnd)
    }
    
    var startDateShortString: String {
        guard let start = startDate else { return "" }
        return shortNameDateFormatter.string(from: start)
    }
    
    var endDateShortString: String {
        guard let end = endDate else { return "" }
        return shortNameDateFormatter.string(from: end)
    }
}
