//
//  Channel.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 24.12.2021..
//

import Foundation
struct Channel: Codable {
    let title: String
    let lastBuildDate: String?
    let item: [Item]
}
