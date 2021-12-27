//
//  Item.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 24.12.2021..
//

import Foundation
struct Item: Codable {
    let title: String
    let link: String
    let description: String
    let enclosure: Enclosure
    let pubDate: String?
}
