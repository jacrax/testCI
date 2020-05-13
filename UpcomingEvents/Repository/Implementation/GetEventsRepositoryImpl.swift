//
//  GetEventsRepositoryImpl.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

class GetEventsRepositoryImpl: GetEventsRepository {
    
    let service: EventService
    
    init(service: EventService = EventServiceCache()) {
        self.service = service
    }
    
    func getUpcomingEvents(completion: @escaping GetEventsCompletion) {
        service.getEvents(completion: completion)
    }
}
