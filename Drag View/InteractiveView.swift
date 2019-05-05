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
        updateTrackingArea()
    }
    
    private func updateTrackingArea() {
        for existingTrackingArea in self.trackingAreas {
            self.removeTrackingArea(existingTrackingArea)
        }
        
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
    
    func windowHasResized() {
        updateTrackingArea()
        mySquare.origin.x = min(mySquare.origin.x, frame.width - mySquare.width)
        mySquare.origin.y = min(mySquare.origin.y, frame.height - mySquare.height)
    }
    
    func updateSquareSize(size: Double) {
        mySquare.size.width = CGFloat(size)
        mySquare.size.height = CGFloat(size)
        windowHasResized()
    }
    
    func maxSquareSize() -> Double {
        return Double(min(frame.width, frame.height))
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
    
    var mySquare = NSRect(x: 0, y: 0, width: 50, height: 50) {
        didSet {
            self.needsDisplay = true // call draw(...) on interactive view
        }
    }
    
    
    
    // Mouse tracking
    
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
    
    override func mouseExited(with event: NSEvent) {
        mouseIsIn = false
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
