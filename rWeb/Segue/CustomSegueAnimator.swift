//
//  CustomSegue.swift
//  rWeb
//
//  Created by jonathan on 25/01/2015.
//  Copyright (c) 2015 net.ellipsis. All rights reserved.
//
//  Modified by David Haylock on 27/05/2015.
//

import Cocoa

class CustomSegueAnimator: NSObject, NSViewControllerPresentationAnimator {

    @objc func  animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        let bottomVC = fromViewController
        let topVC = viewController
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        topVC.view.alphaValue = 0
        bottomVC.view.addSubview(topVC.view)
        var frame : CGRect = NSRectToCGRect(bottomVC.view.frame)
        frame = CGRectInset(frame, 0, 0)
        topVC.view.frame = NSRectFromCGRect(frame)
        let color: CGColorRef = NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0).CGColor
        topVC.view.layer?.backgroundColor = color
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 2
            topVC.view.animator().alphaValue = 1
            }, completionHandler: nil)
    }

    @objc func  animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        let bottomVC = fromViewController
        let topVC = viewController
        topVC.view.wantsLayer = true
        topVC.view.needsDisplay = true
        topVC.view.frame.origin.y = 0
        topVC.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1
            topVC.view.animator().alphaValue = 0
            topVC.view.animator().frame.origin.y = -newSize.height
            }, completionHandler: {
                topVC.view.removeFromSuperview()
        })
    }
}
