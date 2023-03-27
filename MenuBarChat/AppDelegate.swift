//
//  AppDelegate.swift
//

import Cocoa
import SwiftUI
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let openMenuBarChat = Self("openMenuBarChat", default: .init(.c, modifiers: [ .command, .option, .control ]))
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover.init()
    var statusBar: StatusBarController?
    var width: Int = min(1000, Int(NSScreen.main?.visibleFrame.size.width ?? 1000) - 100)
    var height: Int = min(1000, Int(NSScreen.main?.visibleFrame.size.height ?? 1000) - 150)
    var window_width = Int(NSScreen.main?.visibleFrame.size.width ?? 1000)
    var window_height = Int(NSScreen.main?.visibleFrame.size.height ?? 1000)
    
    func updateSizes() {
        width = min(1000, Int(NSScreen.main?.visibleFrame.size.width ?? 1000) - 100)
        height = min(1000, Int(NSScreen.main?.visibleFrame.size.height ?? 1000) - 150)
        window_width = Int(NSScreen.main?.visibleFrame.size.width ?? 1000)
        window_height = Int(NSScreen.main?.visibleFrame.size.height ?? 1000)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView()

        popover.contentViewController = MainViewController()
        popover.contentSize = NSSize(width: width, height: height)
        let contents = NSHostingView(rootView: contentView)
        popover.contentViewController?.view = contents
        popover.behavior = .transient
        statusBar = StatusBarController.init(popover)
        
        
        KeyboardShortcuts.onKeyDown(for: .openMenuBarChat) {
            self.statusBar?.togglePopover(sender: nil)
        }
        
        NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification, object: NSApplication.shared, queue: OperationQueue.main) {_ in
            self.updateSizes()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    
}

