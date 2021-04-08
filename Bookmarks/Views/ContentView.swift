//
//  ContentView.swift
//  Bookmarks
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import BookmarkTree
import Combine
import SwiftUI

struct ContentView: View {
    @AppStorage("repositoryURL")
    var repositoryURL = ""

    @AppStorage("branch")
    var branch = "master"

    @AppStorage("bookmarkFile")
    var bookmarkFile = "bookmark.html"

    @ObservedObject
    var model: ContentViewModel

    var binaryGroup: some View {
        Group {
            Picker(selection: .constant(0), label: Text("Git binary:").frame(width: 100, alignment: .trailing)) {
                if !model.isInitialized {
                    Text("Loading...").tag("0")
                } else {
                    ForEach(model.gitBinaries.indices) { index in
                        Text(model.gitBinaries[index].binary).tag("\(index)")
                    }
                }
            }
            Divider()
                .padding(.vertical, 8)
        }
    }

    var repositoryGroup: some View {
        Group {
            HStack {
                Text("Repository URL:")
                    .frame(width: 100, alignment: .trailing)
                TextField("", text: $repositoryURL)
            }
            HStack {
                Text("Branch:")
                    .frame(width: 100, alignment: .trailing)
                TextField("", text: $branch)
            }
            HStack {
                Text("Bookmark file:")
                    .frame(width: 100, alignment: .trailing)
                TextField("", text: $bookmarkFile)
            }
            Divider()
                .padding(.vertical, 8)
        }
    }

    var syncGroup: some View {
        Group {
            Button(action: {
                model.sync()
            }, label: {
                Text("Sync")
                    .frame(width: 120)
            })
            .disabled(model.isSyncing)

            if model.isSyncing {
                Text("Last synced: Syncing...")
            } else {
                Text("Last synced: \(model.lastSyncedAt)")
            }
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            binaryGroup
            repositoryGroup
            syncGroup
            Spacer()
        }
        .padding()
        .onAppear { model.onAppear() }
        .alert(item: $model.alertItem) { Alert(title: Text($0.error.localizedDescription)) }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(model: .init())
                .frame(width: 400, height: 280, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}
