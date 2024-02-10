//
//  ClimaError.swift
//  Clima2
//
//  Created by Adit Salim on 29/01/24.
//

import Foundation

enum ClimaError: String, Error {
    case invalidData = "Invalid Data"
    case jsonParsingFailure = "Failed to parse JSON"
    case requestFailed = "Request failed"
    case invalidStatusCode = "Invalid status code"
    case unknownError = "An unknown error occured"
}

