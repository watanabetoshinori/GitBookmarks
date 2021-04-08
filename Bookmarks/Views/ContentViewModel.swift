//
//  ContentViewModel.swift
//  Bookmarks
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import Combine
import SwiftUI
import BookmarkTree

class ContentViewModel: NSObject, ObservableObject {
    @AppStorage("bookmarks", store: UserDefaults(suiteName: "group.dev.yourcompany.Bookmarks")!)
    var bookmarks: Data?

    @AppStorage("repositoryURL")
    var repositoryURL = ""

    @AppStorage("branch")
    var branch = "master"

    @AppStorage("bookmarkFile")
    var bookmarkFile = "bookmarks.html"

    @AppStorage("lastSyncedAt")
    var lastSyncedAt = "-"

    @Published
    var isInitialized = false

    @Published
    var isSyncing = false

    @Published
    var gitBinaries = [GitBinary]()

    @Published
    var alertItem: AlertItem?

    private var cancellables = [AnyCancellable]()

    private var outputDirectory: String {
        NSTemporaryDirectory() + "dev.yourcompany.bookmarks"
    }

    // MARK: - Methods

    func onAppear() {
        loadGitBinaries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    print("finished")
                case let .failure(error):
                    print(error)
                    self?.alertItem = AlertItem(error: error)
                }
                self?.isInitialized = true
            }, receiveValue: { [weak self] binaries in
                self?.gitBinaries = binaries
            })
            .store(in: &cancellables)
    }

    func sync() {
        guard !isSyncing else { return }
        isSyncing = true

        cleanupOutputDirectory()
            .flatMap { _ in self.fetchRepository() }
            .flatMap { _ in self.loadBookmarkData() }
            .encode(encoder: JSONEncoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    // Update last synced
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .medium
                    self?.lastSyncedAt = formatter.string(from: Date())
                    print("finished")
                case let .failure(error):
                    print(error)
                    self?.alertItem = AlertItem(error: error)
                }

                self?.isSyncing = false
            }, receiveValue: { [weak self] data in
                self?.bookmarks = data
            })
            .store(in: &cancellables)
    }

}

// MARK: - Private methods

extension ContentViewModel {
    private func loadGitBinaries() -> Future<[GitBinary], Error> {
        Future { promise in
            let systemGit = "/usr/bin/git"
            Process.execute(systemGit, ["--version"]) { result in
                switch result {
                case let .success(result):
                    let version = result.output.replacingOccurrences(of: "git version ", with: "")
                    let binaries = [GitBinary(path: systemGit, version: version)]
                    promise(.success(binaries))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
    }

    private func cleanupOutputDirectory() -> Future<Void, Error> {
        Future { promise in
            do {
                let fileManager = FileManager()
                if fileManager.fileExists(atPath: self.outputDirectory) {
                    try fileManager.removeItem(atPath: self.outputDirectory)
                }
                promise(.success(()))
            } catch {
                promise(.failure(SyncError.cleanupFailed(self.outputDirectory)))
            }
        }
    }

    private func fetchRepository() -> Future<Void, Error> {
        Future { promise in
            let arguments = ["clone",
                             "-b",
                             self.branch,
                             self.repositoryURL,
                             self.outputDirectory]
            Process.execute(self.gitBinaries[0].path, arguments) { result in
                switch result {
                case let .success(result):
                    if let range = result.error.range(of: "ERROR") {
                        let index = result.error.index(before: range.lowerBound)
                        let error = String(result.error[index...])
                        promise(.failure(SyncError.gitCloneFailed(error)))
                        return
                    }
                    promise(.success(()))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
    }

    private func loadBookmarkData() -> Future<[BookmarkTreeNode], Error> {
        Future { promise in
            let path = self.outputDirectory + "/" + self.bookmarkFile

            guard FileManager().fileExists(atPath: path),
                  let htmlString = try? String(contentsOfFile: path) else {
                promise(.failure(SyncError.fileNotFound(self.bookmarkFile)))
                return
            }

            do {
                let bookmarks = try BookmarkDecoder().decode(html: htmlString)
                promise(.success(bookmarks))
            } catch {
                promise(.failure(SyncError.decodingFailed(error.localizedDescription)))
            }
        }
    }
}
