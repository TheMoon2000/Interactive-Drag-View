//
//  WindowController.swift
//  Drag View
//
//  Created by Jia Rui Shan on 2019/5/4.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.backgroundColor = .white
        window?.delegate = self
    }
    
    func windowDidResize(_ notification: Notification) {
        let vc = self.contentViewController as! ViewController
        vc.interactiveView.windowHasResized()
        vc.respondToWindowResize()
    }

}
