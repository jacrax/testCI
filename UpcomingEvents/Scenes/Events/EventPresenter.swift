//
//  Presenter.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

enum EventResponse {
    case success(events: [EventViewModel])
    case failure(error: Error)
}

typealias EventCompletion = (EventResponse) -> Void
typealias EventCompletionModel = (Bool) -> Void

protocol EventsPresenterProtocol {
    func getGroupedAndOrderedModels(completion: @escaping GroupedEventsCompletion)
}

/// Main Presenter for EventsViewController
class EventPresenter: EventsPresenterProtocol {
    
    // Use case in charge of the events. Declared as a protocol for better approach when testing
    private let getEvents: GetUpcomingEvents
    
    // The variable in charge of getting the data for presenting in the TableView
    var groupedEventViewModels = [GroupedEventViewModel]()
    
    // Inject the proper implementation for the getEvents UseCase
    init(getEvents: GetUpcomingEvents = GetUpcomingEventsImpl()) {
        self.getEvents = getEvents
    }
    
    // Function called for setting the data to the view controller
    func getGroupedAndOrderedModels(completion: @escaping GroupedEventsCompletion) {
        getEvents.getGroupedEventsByDate { (response) in
            switch response {
            case .success(let groupedEvents):
                self.groupedEventViewModels = groupedEvents
                completion(.success(groupedEvents: groupedEvents))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
}
