//
//  EventServiceCache.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

/// Class used for getting the Events from a cache file
class EventServiceCache: EventService {
    
    private let fileManager: FileManager
    private let parser: EventJSONParser
    
    init(fileManager: FileManager = .init(), parser: EventJSONParser = .init()) {
        self.fileManager = fileManager
        self.parser = parser
    }
    
    func getEvents(completion: @escaping GetEventsCompletion) {
        do {
            guard let eventsFromFile = try fileManager.getData(from: FileManager.Constants.jsonFileName) else {
                throw FileManager.FileManagerError.dataNil
            }
            
            guard let dataArray = try JSONSerialization.jsonObject(with: eventsFromFile, options: .allowFragments) as? [Any] else {
                throw FileManager.FileManagerError.dataNil
            }
            
            guard let events = parser.parseMultiple(json: dataArray) else {
                completion(.failure(error: FileManager.FileManagerError.badCasting))
                return
            }
            
            completion(.success(events: events))
        } catch let error {
            completion(.failure(error: error))
        }
    }
}
