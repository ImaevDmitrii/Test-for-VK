//
//  Localization.swift
//  test-for-VK
//
//  Created by Dmitrii Imaev on 18.07.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

struct Localization {
    static var sunny: String { "sunny".localized }
    static var rainy: String { "Rainy".localized }
    static var cloudy: String { "cloudy".localized }
    static var stormy: String { "stormy".localized }
    static var snowy: String { "snowy".localized }
}
