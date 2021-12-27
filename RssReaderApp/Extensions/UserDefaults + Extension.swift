//
//  UserDefaults + Extension.swift
//  RssReaderApp
//
//  Created by Borna Ungar on 27.12.2021..
//

import Foundation
import XMLCoder
extension UserDefaults {
    func save(_ stories: [Item], category: String) {
        let data = stories.map { try? XMLEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: category)
    }
    
    func load(category: String) -> [Item] {
        guard let encodedData = UserDefaults.standard.array(forKey: category) as? [Data]
        else {
            return []
        }
        return encodedData.map {
            try! XMLDecoder().decode(Item.self, from: $0)
        }
        
    }
}
