//
//  StatusBarController.swift
//
//  Created by Anagh Sharma on 12/11/19.
//  Copyright © 2019 Anagh Sharma. All rights reserved.
//

import AppKit


class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var eventMonitor: EventMonitor?
    private var statusBarButton: NSStatusBarButton?
    
    @objc
    func quit() {
        NSApplication.shared.terminate(self)
    }
    
    init(_ popover: NSPopover)
    {
        self.popover = popover
        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 28.0)
        statusBarButton = statusItem.button
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = #imageLiteral(resourceName: "StatusBarIcon")
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
            
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }
    }
    
    @objc func togglePopover(sender: AnyObject?) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }
    
    func openPopover() {
        if(statusBarButton != nil) {
            popover.show(relativeTo: statusBarButton!.bounds, of: statusBarButton!, preferredEdge: NSRectEdge.minY)
            let popoverWindowX = popover.contentViewController?.view.window?.frame.origin.x ?? 0
            let popoverWindowY = popover.contentViewController?.view.window?.frame.origin.y ?? 0
            let width = popover.contentViewController?.view.window?.frame.width ?? 0
            let appDelegate = NSApp.delegate as! AppDelegate
            let rightEdge = popoverWindowX+width
            let screenWidth = appDelegate.window_width
            var offset = 0 as CGFloat
            
            if(rightEdge > CGFloat(screenWidth)) {
                offset = CGFloat(screenWidth) - rightEdge
                
            }
            
            popover.contentViewController?.view.window?.setFrameOrigin(
                NSPoint(x: popoverWindowX + CGFloat(offset), y: popoverWindowY)
            )
            
            popover.contentViewController?.view.window?.makeKey()
            
            eventMonitor?.start()
        }
    }
    
    func showPopover(_ sender: AnyObject?) {
        if (statusBarButton != nil) {
            openPopover()
        }
    }
    
    func hidePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if(popover.isShown) {
            hidePopover(event!)
        }
    }
}
