//
//  Process+Execute.swift
//  Bookmarks
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import Foundation

struct ProcessExecuteResult {
    var output: String

    var error: String
}

extension Process {
    static func execute(_ launchPath: String, _ arguments: [String] = [], completion: @escaping (Result<ProcessExecuteResult, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pipe = Pipe()
            let errorPipe = Pipe()

            let task = Process()
            task.launchPath = launchPath
            task.arguments = arguments
            task.standardOutput = pipe
            task.standardError = errorPipe

            do {
                try task.run()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? ""
                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                let error = String(data: errorData, encoding: .utf8) ?? ""
                completion(.success(ProcessExecuteResult(output: output, error: error)))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
