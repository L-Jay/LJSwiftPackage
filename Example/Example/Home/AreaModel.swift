//
//  WeatherModel.swift
//  Example
//
//  Created by 崔志伟 on 2023/5/4.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherModel = try? JSONDecoder().decode(WeatherModel.self, from: jsonData)

import Foundation

// MARK: - WeatherModel
struct AreaModel: Codable {
    let reason: String?
    let result: [AreaResult]?
    let errorCode: Int?

    enum CodingKeys: String, CodingKey {
        case reason = "reason"
        case result = "result"
        case errorCode = "error_code"
    }
}

// MARK: - Result
struct AreaResult: Codable {
    let id: String?
    let name: String?
    let fid: String?
    let levelid: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case fid = "fid"
        case levelid = "level_id"
    }
}
