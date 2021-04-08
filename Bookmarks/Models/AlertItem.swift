//
//  AlertItem.swift
//  Bookmarks
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import Foundation

struct AlertItem: Identifiable {
    let id = UUID().uuidString

    let error: Error
}
