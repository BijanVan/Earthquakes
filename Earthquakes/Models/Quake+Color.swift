//
//  Quake+Color.swift
//  Earthquakes
//
//  Created by Bijan Nazem on 2023-01-21.
//

import UIKit

extension Quake {
    /// The color which corresponds with the quake's magnitude.
    var color: UIColor {
        switch magnitude {
        case 0..<1:
            return .green
        case 1..<2:
            return .yellow
        case 2..<3:
            return .orange
        case 3..<5:
            return .red
        case 5..<Double.greatestFiniteMagnitude:
            return .init(red: 0.8, green: 0.2, blue: 0.7, alpha: 1.0)
        default:
            return .gray
        }
    }
}
