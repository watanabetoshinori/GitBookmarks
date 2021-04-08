//
//  ContentView.swift
//  Bookmarks Extension
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import Kingfisher
import SwiftUI

struct ContentView: View {
    @ObservedObject
    var model: ContentViewModel

    var dismissPopover: () -> Void

    init(model: ContentViewModel, dismissPopover: @escaping () -> Void) {
        self.model = model
        self.dismissPopover = dismissPopover

        self.model.fetchBookmarks()
    }

    var loadingView: some View {
        VStack {
            Spacer()
            Text("Loading...")
            Spacer()
        }
        .frame(minWidth: 260)
    }

    var bookmarksView: some View {
        List(model.bookmarks, children: \.children) { node in
            HStack(spacing: 4) {
                if node.type == .folder {
                    Image(systemName: node.type.rawValue)
                        .foregroundColor(.accentColor)
                        .scaledToFill()
                        .frame(width: 16, height: 16)
                        .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))

                } else {
                    KFImage
                        .dataProvider(FaviconDataProvider(node: node))
                        .placeholder {
                            Image(systemName: node.type.rawValue)
                                .foregroundColor(.accentColor)
                        }
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.accentColor)
                        .frame(width: 16, height: 16)
                        .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                }

                Text(node.title)
                    .fixedSize(horizontal: true, vertical: false)

                Spacer()
            }
            .onTapGesture {
                guard node.type == .bookmark,
                      let url = URL(string: node.url) else {
                    return
                }
                NSWorkspace.shared.open(url)
                dismissPopover()
            }
        }
        .frame(minWidth: 260)
    }

    var body: some View {
        if model.isLoading {
            loadingView
        } else {
            bookmarksView
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: .init(), dismissPopover: {})
            .frame(width: 260, height: 320, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
