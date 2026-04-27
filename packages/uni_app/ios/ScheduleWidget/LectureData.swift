//
//  LectureData.swift
//  Runner
//

import Foundation

struct LectureData: Codable, Hashable {
    let subject: String
    let acronym: String
    let room: String
    let typeClass: String
    let startTime: String
    let endTime: String
}

