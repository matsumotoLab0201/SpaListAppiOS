//
//  Model.swift
//  JsonListApp
//
//  Created by ko_matsumoto on 2022/12/14.
//

import Foundation


// JSONのitem内のデータ構造
struct ItemJson: Codable {
    let name: String?
    let station: String?
    let cost1: Int?
    let cost2: Int?
    let walk: Int?
    let imageUrl: URL?
    let url : URL?
}

// JSONのデータ構造
struct ResultJson: Codable {
    // 複数要素
    let item:[ItemJson]?
}
