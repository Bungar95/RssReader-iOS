//
//  Enclosure.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 25.12.2021..
//

import Foundation
struct Enclosure: Codable{
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}


