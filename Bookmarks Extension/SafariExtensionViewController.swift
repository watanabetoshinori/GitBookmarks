//
//  SafariExtensionViewController.swift
//  Bookmarks Extension
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import Combine
import Kingfisher
import SafariServices
import SwiftUI

class SafariExtensionViewController: SFSafariExtensionViewController {

    // MARK: - Initializing a Singleton

    static let shared = SafariExtensionViewController()

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentView = ContentView(model: .init()) {
            self.dismissPopover()
        }

        let hostingView = NSHostingView(rootView: contentView)
        view.addSubview(hostingView)

        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: view.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        preferredContentSize = NSSize(width: 260, height: 320)
    }
}
