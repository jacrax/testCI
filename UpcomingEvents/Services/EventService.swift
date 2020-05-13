//
//  EventService.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

enum GetEventsResponse {
    case success(events: [Event])
    case failure(error: Error)
}

/// A protocol that defines the Event Service that gets call in order to get the data from a source. A service can be either a web service or cache
protocol EventService {
    func getEvents(completion: @escaping GetEventsCompletion)
}
