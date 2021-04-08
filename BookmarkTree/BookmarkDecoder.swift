//
//  BookmarkDecoder.swift
//  Bookmarks Extension
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import Foundation
import SwiftSoup

public class BookmarkDecoder {
    public init() {}

    public func decode(url: URL) throws -> [BookmarkTreeNode] {
        let html = try String(contentsOf: url)
        return try decode(html: html)
    }

    public func decode(html: String) throws -> [BookmarkTreeNode] {
        let doc = try SwiftSoup.parse(html)

        var root = BookmarkTreeNode(type: .folder, title: "", url: "", children: [])

        let title = try doc.select("h1").first()

        // Find the first DT or DL tag
        var element: Element? = title
        loop: while element != nil {
            switch element!.tagNameNormal() {
            case "dt":
                // Safari starts with a DT tag
                parseDL(parent: &root, dl: title!.parent()!)
                break loop
            case "dl":
                // Chrome starts with a DL tag
                parseDL(parent: &root, dl: element!)
                break loop
            default:
                break
            }
            element = try? element!.nextElementSibling()
        }
        return root.children ?? []
    }

    /// Parse child nodes of DL tag in order.
    private func parseDL(parent: inout BookmarkTreeNode, dl: Element) {
        for index in 0..<dl.children().count {
            let dt = dl.child(index)
            if dt.tagNameNormal() != "dt" {
                // Ignore if it is not a DT tag
                continue
            }

            if let element = dt.children().first() {
                switch element.tagNameNormal() {
                case "h3":
                    // H3 tag is folder
                    var folder = BookmarkTreeNode(type: .folder, title: element.ownText(), url: "", children: [])

                    var nextElement = try? element.nextElementSibling()
                    loop: while nextElement != nil {
                        switch nextElement!.tagNameNormal() {
                        case "dt":
                            break loop
                        case "dl":
                            parseDL(parent: &folder, dl: nextElement!)
                            parent.add(child: folder)
                            break loop
                        default:
                            break
                        }

                        nextElement = try? nextElement!.nextElementSibling()
                    }
                case "a":
                    // A tag is bookmark
                    let bookmark = BookmarkTreeNode(type: .bookmark, title: element.ownText(), url: (try? element.attr("href")) ?? "", children: nil)
                    parent.add(child: bookmark)
                default:
                    break
                }
            }
        }
    }
}
