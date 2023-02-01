//
//  CacheEntryObject.swift
//  Earthquakes
//
//  Created by Bijan Nazem on 2023-01-24.
//

import Foundation

enum CacheEntry {
    case inProgress(Task<QuakeLocation, Error>)
    case ready(QuakeLocation)
}

final class CacheEntryObject: Sendable {
    let entry: CacheEntry
    
    init(entry: CacheEntry) { self.entry = entry }
}
