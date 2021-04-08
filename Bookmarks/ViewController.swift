//
//  ViewController.swift
//  Bookmarks
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import Cocoa
import SafariServices.SFSafariApplication
import SafariServices.SFSafariExtensionManager
import SwiftUI

class ViewController: NSViewController {
    let extensionBundleIdentifier = "dev.yourcompany.Bookmarks.Extension"

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingView = NSHostingView(rootView: ContentView(model: .init()))
        view.addSubview(hostingView)

        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: view.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        preferredContentSize = NSSize(width: 400, height: 280)
    }
}
