//
//  NSCache+Subscript.swift
//  Earthquakes
//
//  Created by Bijan Nazem on 2023-01-24.
//

import Foundation

extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject  {
    subscript(_ url: URL) -> CacheEntry? {
        get {
            let key = url.absoluteString as NSString
            return object(forKey: key)?.entry
        }
        set {
            let key = url.absoluteString as NSString
            if let newValue {
                setObject(CacheEntryObject(entry: newValue), forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
