//
//  UpcomingEventsTests.swift
//  UpcomingEventsTests
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import XCTest
@testable import UpcomingEvents

class UpcomingEventsTests: XCTestCase {
    
    var presenter: EventsPresenterProtocol!
    var getupcomingMock: GetUpcomingEvents!
    let mockEvents = [
        RawEvent(title: "Evening Cookout with Friends", start: "November 6, 2018 5:00 PM", end: "November 6, 2018 10:00 PM"),
        RawEvent(title: "Roller Derby", start: "November 7, 2018 12:00 PM", end: "November 7, 2018 2:30 PM")
    ]
    
    let mockConflictEvents = [
        RawEvent(title: "Evening Cookout with Friends", start: "November 7, 2018 10:00 PM", end: "November 7, 2018 11:10 PM"),
        RawEvent(title: "Roller Derby", start: "November 7, 2018 11:00 PM", end: "November 7, 2018 11:30 PM")
    ]

    func testEventPresenter() {
        let repoSuccess = GetEventRepositoryMock(isSuccessful: true, mockEvents: mockEvents)
        getupcomingMock = GetUpcomingEventsImpl(repository: repoSuccess)
        presenter = EventPresenter(getEvents: getupcomingMock)
        let expectation = self.expectation(description: "Wait for completion")
        presenter.getGroupedAndOrderedModels { (response) in
            switch response {
            case .success(let groupedEvents):
                XCTAssertFalse(groupedEvents.isEmpty, "Should not be empty")
                let hasConflict = groupedEvents.contains(where: { $0.events.contains(where: { $0.hasConflict }) })
                XCTAssertFalse(hasConflict, "None of the mock elements has conflict")
            case .failure:
                XCTFail("On Success Response should not be any error")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testEventPresenterWithConflicts() {
        let repoSuccess = GetEventRepositoryMock(isSuccessful: true, mockEvents: mockConflictEvents)
        getupcomingMock = GetUpcomingEventsImpl(repository: repoSuccess)
        presenter = EventPresenter(getEvents: getupcomingMock)
        let expectation = self.expectation(description: "Wait for completion")
        presenter.getGroupedAndOrderedModels { (response) in
            switch response {
            case .success(let groupedEvents):
                XCTAssertFalse(groupedEvents.isEmpty, "Should not be empty")
                let hasConflict = groupedEvents.contains(where: { $0.events.contains(where: { $0.hasConflict }) })
                XCTAssertTrue(hasConflict, "At least one event has conflict")
            case .failure:
                XCTFail("On Success Response should not be any error")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testEventPresenterEmpty() {
        let repoSuccess = GetEventRepositoryMock(isSuccessful: true, mockEvents: [])
        getupcomingMock = GetUpcomingEventsImpl(repository: repoSuccess)
        presenter = EventPresenter(getEvents: getupcomingMock)
        let expectation = self.expectation(description: "Wait for completion")
        presenter.getGroupedAndOrderedModels { (response) in
            switch response {
            case .success(let groupedEvents):
                XCTAssertTrue(groupedEvents.isEmpty, "Should not be empty")
                let hasConflict = groupedEvents.contains(where: { $0.events.contains(where: { $0.hasConflict }) })
                XCTAssertFalse(hasConflict, "None of the mock elements has conflict")
            case .failure:
                XCTFail("On Success Response should not be any error")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }

    func testEventPresenterFailure() {
        let repoSuccess = GetEventRepositoryMock(isSuccessful: false, mockEvents: mockEvents)
        getupcomingMock = GetUpcomingEventsImpl(repository: repoSuccess)
        presenter = EventPresenter(getEvents: getupcomingMock)
        
        let expectation = self.expectation(description: "Wait for completion")
        presenter.getGroupedAndOrderedModels { (response) in
            switch response {
            case .success:
                XCTFail("Service should return false")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, GetEventRepositoryMock.MockError.genericError.localizedDescription, "On Success Response should not be any error")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }

}
