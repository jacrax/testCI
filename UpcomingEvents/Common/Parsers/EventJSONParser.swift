//
//  EventJSONParser.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

class EventJSONParser {
    struct Constants {
        static let titleKey = "title"
        static let startKey = "start"
        static let endKey = "end"
    }
    
    func parseMultiple(json: [Any]) -> [Event]? {
        guard let dictionaryRepresentation = json as? [[String: Any]] else { return nil }
        return dictionaryRepresentation.compactMap { parse(json: $0) }
    }
    
    private func parse(json: [String: Any]) -> Event? {
        guard let title = json[Constants.titleKey] as? String,
            let start = json[Constants.startKey] as? String,
            let end = json[Constants.endKey] as? String else { return nil }
        
        return RawEvent(title: title, start: start, end: end)
    }
}
