//
//  SaverView.swift
//  rWebSwift
//
//  Created by David Haylock on 27/05/2015.
//  Copyright (c) 2015 David Haylock. All rights reserved.
//

import Cocoa
import WebKit

class SaverView: NSViewController {

    //---------------------------------------------
    // MARK: Declarations
    //---------------------------------------------
    var latch = false
    var resetLatch = false
    var tellVCtoReset = false
    var IOTimer: idleTimer = idleTimer()
    var idleTime = NSTimer()
    var findFullscreen = NSTimer()
    var lastURL: String!
    var hasMainGotAnIFrame:Bool!
    var t: Int64!

    @IBOutlet var Saver: WebView!
    var holdingView: WebView!
        
    //---------------------------------------------
    // MARK: View
    //---------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Saver.needsDisplay = true
        self.Saver.wantsLayer = true
        self.Saver.customUserAgent = customAgent
    
        // Do view setup here.
        idleTime = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("timerCheck"), userInfo: nil, repeats: true)
        findFullscreen = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:Selector("checkForFullscreen"), userInfo:nil ,repeats: true)
    }
    //---------------------------------------------
    func setNewViewConstraints() {
        
        // Saver View
        var saverConstraints:[AnyObject] = [NSLayoutConstraint(item: self.Saver, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: newSize.width),NSLayoutConstraint(item: self.Saver, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: newSize.height-headerHeight),NSLayoutConstraint(item: self.Saver, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0),NSLayoutConstraint(item: self.Saver, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: headerHeight)]
        
        self.view.addConstraints(saverConstraints)
    }
    //---------------------------------------------
    override func viewWillAppear() {
        self.Saver.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: promotionalWebUrl)!))
    }
    //---------------------------------------------
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    //---------------------------------------------
    // MARK: Timer
    //---------------------------------------------
    func timerCheck() {
        t = IOTimer.SystemIdleTime()
        
        if t == 0 && !latch  {
            self.performSegueWithIdentifier("toMain", sender: self)
            latch = true
        }
        
        if hasMainGotAnIFrame == true && t >= Int64(resetWebViewiFrameTime) && !resetLatch {
            self.holdingView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: mainWebUrl)!))
            tellVCtoReset = true
            resetLatch = true
        }
        else if hasMainGotAnIFrame == false && t >= Int64(resetWebViewStandardTime) && !resetLatch {
            self.holdingView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: mainWebUrl)!))
            tellVCtoReset = true
            resetLatch = true
        }
    }
    //---------------------------------------------
    func checkForFullscreen() {

        if Saver != nil {
            var domDocument:DOMDocument! = self.Saver.mainFrame.DOMDocument
            var htmlElement:DOMElement! = domDocument.getElementsByTagName("html").item(0) as! DOMElement
            
            if htmlElement.hasAttribute("fullscreen") {
                self.Saver.frame.size.height = newSize.height
            }
            else {
                self.Saver.frame.size.height = newSize.height-headerHeight
            }
        }
    }
    //---------------------------------------------
    // MARK: Segue
    //---------------------------------------------
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toMain" {
            let destinationVC = segue.destinationController as! ViewController
            println("Sending from SaverView \(lastURL)")
            destinationVC.resetWebView = self.tellVCtoReset
            if self.tellVCtoReset == true {
                self.holdingView.setMaintainsBackForwardList(false)
                self.holdingView.setMaintainsBackForwardList(true)
                destinationVC.representedObject = self.holdingView
            }
        }
    }
}
