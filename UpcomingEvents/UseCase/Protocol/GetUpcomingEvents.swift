//
//  GetUpcomingEvents.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

enum GroupedEventsResponse {
    case success(groupedEvents: [GroupedEventViewModel])
    case failure(error: Error)
}

typealias GroupedEventsCompletion = (GroupedEventsResponse) -> Void

protocol GetUpcomingEvents {
    func getUpcomingEvents(completion: @escaping GetEventsCompletion)
    func getGroupedEventsByDate(completion: @escaping GroupedEventsCompletion)
    func groupedEventsByDate(events: [Event]) -> [GroupedEventViewModel]
}
