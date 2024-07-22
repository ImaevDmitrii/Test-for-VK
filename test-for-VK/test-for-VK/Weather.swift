//
//  Weather.swift
//  test-for-VK
//
//  Created by Dmitrii Imaev on 18.07.2024.
//

import Foundation

enum Weather: String, CaseIterable {
    case sunny, rainy, cloudy, stormy, snowy
    
    var localizedName: String {
        switch self {
        case .sunny: return Localization.sunny
        case .rainy: return Localization.rainy
        case .cloudy: return Localization.cloudy
        case .stormy: return Localization.stormy
        case .snowy: return Localization.snowy
        }
    }
}
