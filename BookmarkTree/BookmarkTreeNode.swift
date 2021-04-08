//
//  BookmarkTreeNode.swift
//  Bookmarks Extension
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import Foundation

public enum BookmarkTreeNodeType: String, Codable {
    case folder
    case bookmark
}

public struct BookmarkTreeNode: Hashable, Identifiable, Codable {
    public var id: UUID = UUID()

    public var type: BookmarkTreeNodeType

    public var title: String

    public var url: String

    public var children: [BookmarkTreeNode]?

    public init(type: BookmarkTreeNodeType, title: String, url: String, children: [BookmarkTreeNode]? = nil) {
        self.type = type
        self.title = title
        self.url = url
        self.children = children
    }

    mutating public func add(child: BookmarkTreeNode) {
        children?.append(child)
    }
}

public extension BookmarkTreeNode {
    func tree(_ prefix: String = "") -> String {
        switch type {
        case .bookmark:
            return "\(title)(\(url))"
        case .folder:
            let childTree = children?.enumerated().map {
                if $0.offset < children!.count - 1 {
                    return prefix + "├─ " + $0.element.tree(prefix + "│  ")
                } else {
                    return prefix + "└─ " + $0.element.tree(prefix + "   ")
                }
            }.joined(separator: "\n")

            return "\(title)" + (childTree?.isEmpty == false ? "\n\(childTree!)" : "")
        }
    }
}
