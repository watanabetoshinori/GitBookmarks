//
//  GitBinary.swift
//  Bookmarks
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import Foundation

struct GitBinary: Identifiable {
    var id = UUID().uuidString

    var path: String

    var version: String

    var binary: String {
        [path, "(\(version))"].joined(separator: " ")
    }
}
