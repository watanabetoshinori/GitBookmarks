//
//  FaviconDataProvider.swift
//  Bookmarks Extension
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import BookmarkTree
import FavIcon
import Kingfisher

struct FaviconDataProvider: ImageDataProvider {
    public var cacheKey: String

    init(node: BookmarkTreeNode) {
        cacheKey = node.url
    }

    func data(handler: @escaping (Result<Data, Error>) -> Void) {
        do {
            try FavIcon.downloadPreferred(cacheKey, width: 16, height: 16, completion: { result in
                switch result {
                case let .success(image):
                    if let data = image.tiffRepresentation {
                        handler(.success(data))
                    } else {
                        handler(.failure(NSError(domain: "app",
                                                 code: 0,
                                                 userInfo: [NSLocalizedDescriptionKey: "No image"])))
                    }
                case let .failure(error):
                    print(error)
                    handler(.failure(error))
                }
            })
        } catch {
            print(error)
            handler(.failure(error))
        }
    }
}
