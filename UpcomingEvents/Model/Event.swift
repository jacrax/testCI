//
//  Event.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

protocol Event {
    var title: String { get set }
    var start: String { get set }
    var end: String { get set }
}

struct RawEvent: Event {
    var title: String
    var start: String
    var end: String
}

protocol GroupedEvent {
    var date: Date { get set }
    var dateString: String { get set }
    var events: [Event] { get set }
}

struct RawGroupedEvent: GroupedEvent {
    var date: Date
    var dateString: String
    var events: [Event]
}
