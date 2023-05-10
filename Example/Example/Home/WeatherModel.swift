//
//  WeatherModel.swift
//  Example
//
//  Created by 崔志伟 on 2023/5/6.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherModel = try? JSONDecoder().decode(WeatherModel.self, from: jsonData)

import Foundation

// MARK: - WeatherModel

struct WeatherModel: Codable {
    let reason: String?
    let result: [WeatherResult]?
    let errorCode: Int?

    enum CodingKeys: String, CodingKey {
        case reason
        case result
        case errorCode = "error_code"
    }
}

// MARK: - WeatherResult

struct WeatherResult: Codable {
    let id: String?
    let name: String?
    let fid: String?
    let levelid: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fid
        case levelid = "level_id"
    }
}
