//
//  SearchQueryModel.swift
//  Jelajah
//
//  Created by Indra Permana on 03/07/22.
//

import Foundation

struct SearchQueryModel: Codable {
    let term: String
    let latitude: Double
    let longitude: Double
}
