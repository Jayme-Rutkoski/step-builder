//
//  NetworkHelper.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/11/25.
//

import Foundation

enum DataLoadingError: Error {
    case fileNotFound
    case decodingError
}


class NetworkHelper {
    
    static public func load<T: Decodable>(_ filename: String) throws -> T {
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            throw DataLoadingError.fileNotFound
        }

        let data = try Data(contentsOf: file)
        let decoder = JSONDecoder()

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw DataLoadingError.decodingError
        }
    }
}
