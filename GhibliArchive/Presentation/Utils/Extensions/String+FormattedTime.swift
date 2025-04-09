//
//  String+FormattedTime.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

extension String {
    var formattedTime: String {
        guard let totalMinutes = Int(self) else { return self }

        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        var components: [String] = []

        if hours > 0 {
            components.append("\(hours)h")
        }
        if minutes > 0 {
            components.append("\(minutes)min")
        }

        return components.isEmpty ? "0min" : components.joined()
    }
}
