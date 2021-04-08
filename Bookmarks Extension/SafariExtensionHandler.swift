//
//  SafariExtensionHandler.swift
//  Bookmarks Extension
//
//  Created by Watanabe Toshinori on 2021/04/08.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {}

    override func toolbarItemClicked(in window: SFSafariWindow) {}
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        SafariExtensionViewController.shared
    }
}
