//
//  SyncError.swift
//  Bookmarks
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import Foundation

enum SyncError: Error, LocalizedError {
    case cleanupFailed(String)

    case gitCloneFailed(String)

    case fileNotFound(String)

    case decodingFailed(String)

    var errorDescription: String? {
        switch self {
        case let .cleanupFailed(path):
            return "Cleanup work directory failed: \(path)"
        case let .gitCloneFailed(reason):
            return "Git clone failed: \(reason)"
        case let .fileNotFound(path):
            return "File not found: \(path)"
        case let .decodingFailed(reason):
            return "Decoding bookmark html failed: \(reason)"
        }
    }
}
