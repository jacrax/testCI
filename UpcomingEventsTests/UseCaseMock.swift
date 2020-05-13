//
//  UseCaseMock.swift
//  UpcomingEventsTests
//
//  Created by CarlosPerez on 5/12/20.
//  Copyright © 2020 Carlos Perez. All rights reserved.
//

import Foundation
@testable import UpcomingEvents

class GetEventRepositoryMock: GetEventsRepository {
    
    enum MockError: Error {
        case genericError
    }
    
    let isRequestSuccesfull: Bool
    private let mockEvents: [Event]
    
    init(isSuccessful: Bool = true, mockEvents: [Event]) {
        self.isRequestSuccesfull = isSuccessful
        self.mockEvents = mockEvents
    }
    
    func getUpcomingEvents(completion: @escaping GetEventsCompletion) {
        
        if isRequestSuccesfull {
            completion(requestSuccessFull())
        } else {
            completion(requestFailure())
        }
        
    }
    
    private func requestSuccessFull() -> GetEventsResponse {
        let response = GetEventsResponse.success(events: mockEvents)
        return response
    }
    
    private func requestFailure() -> GetEventsResponse {
        return GetEventsResponse.failure(error: MockError.genericError)
    }
    
}
