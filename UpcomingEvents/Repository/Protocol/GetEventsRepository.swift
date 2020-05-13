//
//  GetEventsRepository.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

typealias GetEventsCompletion = (GetEventsResponse) -> Void

protocol GetEventsRepository {
    func getUpcomingEvents(completion: @escaping GetEventsCompletion)
}
