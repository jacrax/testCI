//
//  FileManager.swift
//  UpcomingEvents
//
//  Created by Carlos Perez on 11/5/19.
//  Copyright © 2019 Carlos Perez. All rights reserved.
//

import Foundation

/// Class used for retrieving the data from a json file provided by the application
class FileManager {
    enum FileManagerError: Error {
        case badBundleName
        case badCasting
        case fileNotExists
        case dataNil
    }
    
    struct Constants {
        static let jsonFileName = "mock"
    }
    
    enum FileType: String {
        case json = "json"
    }
    
    func getData(from fileName: String) throws -> Data? {
        guard let bundleNamePath = getPath(fileNAme: fileName) else { throw FileManagerError.badBundleName }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: bundleNamePath),
                                options: .mappedIfSafe)
            return data
        } catch {
            throw FileManagerError.fileNotExists
        }
    }
    
    private func getPath(fileNAme: String) -> String? {
        return Bundle.main.path(forResource: fileNAme, ofType: FileType.json.rawValue)
    }
}
