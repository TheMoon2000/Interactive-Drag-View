//
//  InteractiveView.swift
//  Drag View
//
//  Created by Jia Rui Shan on 2019/5/4.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import Cocoa

class InteractiveView: NSView {
    
    override func awakeFromNib() {
        let trackingOptions: NSTrackingArea.Options = [
            .activeAlways,
            .mouseEnteredAndExited,
            .mouseMoved
        ]
        let trackingArea = NSTrackingArea(rect: self.bounds,
                                          options: trackingOptions,
                                          owner: self,
                                          userInfo: nil)
        self.addTrackingArea(trackingArea)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let boundary = self.bounds
        let bgPath = NSBezierPath(rect: boundary)
        BGCOLOR.setFill()
        bgPath.fill()
        
        let squarePath = NSBezierPath(rect: mySquare)
        if (!mouseIsIn) {
            SQUARECOLOR.setFill()
        } else if (mouseIsIn && !mouseIsPressed) {
            HOVERCOLOR.setFill()
        } else {
            PRESSEDCOLOR.setFill()
        }
        squarePath.fill()
    }
    
    var mouseIsIn = false {
        didSet {
            self.needsDisplay = true
            mouseIsIn ? NSCursor.openHand.set() : NSCursor.arrow.set()
        }
    }
    
    var mouseIsPressed = false {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var pointOfMouseRelativeToSquare: NSPoint?
    var mySquare = NSRect(x: 0, y: 0, width: 50, height: 50) {
        didSet {
            self.needsDisplay = true // call draw(...) on interactive view
        }
    }
    
    
    
    
    // Mouse tracking
    
    override func mouseEntered(with event: NSEvent) {
        
    }
    
    override func mouseExited(with event: NSEvent) {
        print("mouse exited the view")
    }
    
    override func mouseDragged(with event: NSEvent) {
        let location = event.locationInWindow
        let locationInView = self.convert(location, from: window?.contentView)
        if (mouseIsPressed && pointOfMouseRelativeToSquare != nil) {
            let proposedX = locationInView.x - pointOfMouseRelativeToSquare!.x
            let proposedY = locationInView.y - pointOfMouseRelativeToSquare!.y
            let actualX = min(max(0, proposedX), frame.width - mySquare.width)
            let actualY = min(max(0, proposedY), frame.height - mySquare.height)
            let actualPoint = NSPoint(x: actualX, y: actualY)
            mySquare.origin = actualPoint
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        let location = event.locationInWindow
        let locationInView = self.convert(location, from: window?.contentView)
        mouseIsIn = mySquare.contains(locationInView)
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.locationInWindow
        let locationInView = self.convert(location, from: window?.contentView)
        mouseIsPressed = mySquare.contains(locationInView)
        if (mouseIsPressed) {
            let x = locationInView.x - mySquare.origin.x
            let y = locationInView.y - mySquare.origin.y
            pointOfMouseRelativeToSquare = NSPoint(x: x, y: y)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        mouseIsPressed = false
        pointOfMouseRelativeToSquare = nil
    }
    
}
