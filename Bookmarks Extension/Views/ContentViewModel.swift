//
//  ContentViewModel.swift
//  Bookmarks Extension
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import BookmarkTree
import SwiftUI

class ContentViewModel: NSObject, ObservableObject {
    @AppStorage("bookmarks", store: UserDefaults(suiteName: "group.dev.yourcompany.Bookmarks")!)
    var bookmarkData: Data?

    @Published
    var isLoading: Bool = false

    @Published
    var bookmarks = [BookmarkTreeNode]()

    func fetchBookmarks() {
        self.isLoading = true

        DispatchQueue.main.async {
            if let data = self.bookmarkData,
               let bookmarks = try? JSONDecoder().decode([BookmarkTreeNode].self, from: data) {
                self.bookmarks = bookmarks
            }

            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}
