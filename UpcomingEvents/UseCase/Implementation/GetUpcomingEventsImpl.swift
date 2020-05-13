//
//  GetUpcomingEventsImpl.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

/// Implementation of the GetUpcomingEvents protocol. This defines the rules by which the presentation of the data is managed
class GetUpcomingEventsImpl: GetUpcomingEvents {

    let repository: GetEventsRepository
    
    private lazy var dateFormatter: DateFormatter =  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        return dateFormatter
    }()
    
    private lazy var dateReadableFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    
    init(repository: GetEventsRepository = GetEventsRepositoryImpl()) {
        self.repository = repository
    }
    
    func getUpcomingEvents(completion: @escaping GetEventsCompletion) {
        repository.getUpcomingEvents(completion: completion)
    }
    
    /// Main function to obtain the events grouped by date.
    func getGroupedEventsByDate(completion: @escaping GroupedEventsCompletion) {
        repository.getUpcomingEvents { [weak self] (response) in
            guard let self = self else {
                completion(.failure(error: UpcomingEventError.deallocatingObject))
                return
            }
            
            switch response {
            case .success(let events):
                completion(.success(groupedEvents: self.groupedEventsByDate(events: events)))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    /// This function gets the events from the services and transform them into an array of GroupedEventViewModel
    func groupedEventsByDate(events: [Event]) -> [GroupedEventViewModel]{
        var groupedEvents = [GroupedEventViewModel]()
        var dictionary = [String: [Event]]()
        
        // Go through the array events and use the start date of the event as the key for the dictionary, grouping events by day
        for event in events {
            guard let date = dateFormatter.date(from: event.start) else { break }
            let dateString = dateReadableFormatter.string(from: date)
            
            if let _ = dictionary[dateString] {
                dictionary[dateString]?.append(event)
            } else {
                dictionary[dateString] = [event]
            }
        }
        
        // Go through the dictionary to create a GroupedEventViewModel element
        for (key, value) in dictionary {
            let viewModels = value.map( { EventViewModel(title: $0.title,
                                                         start: $0.start,
                                                         end: $0.end,
                                                         hasConflict: false) })
            let grouped = GroupedEventViewModel(dateString: key, events: viewModels)
            groupedEvents.append(grouped)
        }
        
        // Return the GroupedEventViewModel array sorted by date
        return groupedEvents.sorted { (ev1, ev2) -> Bool in
            guard let date1 = ev1.date, let date2 = ev2.date else { return false }
            return date1.compare(date2) == .orderedAscending
        }
    }
    
}
