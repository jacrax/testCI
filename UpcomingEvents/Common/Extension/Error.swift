//
//  Error.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/6/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

// Error enum defining the errors that can be thrown when getting the Upcoming Events
enum UpcomingEventError: Error {
    case deallocatingObject
    case unknown
}
