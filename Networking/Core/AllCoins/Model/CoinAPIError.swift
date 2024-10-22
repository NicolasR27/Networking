//
//  CoinAPIError.swift
//  Networking
//
//  Created by Nicolas Rios on 10/20/24.
//

import Foundation

enum CoinAPIError: Error {
    case invalidData
    case JSONParsingFailure
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)

    var customdescription: String {
        switch self {
            case .invalidData:
                return "Invalid data"
            case .JSONParsingFailure:
                return "JSON parsing failure"
            case .requestFailed(let description):
                return "Request failed: \(description)"
            case .invalidStatusCode(let statusCode):
                return "Invalid status code: \(statusCode)"
            case .unknownError(let error):
                return "Unknown error: \(error.localizedDescription)"
        }
    }
}
