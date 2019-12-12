//
//  Word.swift
//  vocbuddy
//
//  Created by Max Streitberger on 26.11.19.
//  Copyright © 2019 Max Streitberger. All rights reserved.
//

import Foundation


struct Word: Codable {
    var original: String
    var translated: String
    var level: String
    var phase: String
    var lastQuery: String
    var learned: Bool
}


struct FailableDecodable<Base : Decodable> : Decodable {

    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
