//
//  ViewController.swift
//  rWebSwift
//
//  Created by David Haylock on 26/05/2015.
//  Copyright (c) 2015 David Haylock. All rights reserved.
//

import Cocoa
import WebKit
import Quartz

class ViewController: NSViewController {

    //---------------------------------------------
    // MARK: Declarations
    //---------------------------------------------
    @IBOutlet var Header: WebView!
    @IBOutlet var Main: WebView!
    @IBOutlet var timer: NSTextField!
    @IBOutlet var forwardButton: NSButton!
    @IBOutlet var backButton: NSButton!
    
    var latch = false
    var resetLatch = false
    var resetWebView = false
    var hasMainGotAnIFrame = false
    var lastURL: String!
    
    // Custom obj-C class for idleTimer
    var IOTimer: idleTimer = idleTimer()
    var idleTime = NSTimer()
    
    //---------------------------------------------
    // MARK: View Stuff
    //----------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNewViewConstraints()
        
        // Load the Custom URLS
        self.setupWebView()

        // Setup the Buttons
        self.setupButtons()
        // Start the Timer

        idleTime = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("timerCheck"), userInfo: nil, repeats: true)
    }
    //----------------------------------------------
    func setNewViewConstraints() {
        
        // Header View
        var headerConstraints:[AnyObject] = [NSLayoutConstraint(item: self.Header, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.Header, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.Header, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: newSize.width),
            NSLayoutConstraint(item: self.Header, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: headerHeight)]
        
        // Attach the Back button to the Left side of the Screen offset By 30 pixels
        var backButtonConstraints:[AnyObject] = [NSLayoutConstraint(item: self.backButton, attribute: .Left, relatedBy: .Equal, toItem: self.Header, attribute: .Left, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: self.backButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.Header, attribute: .CenterY, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.backButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 45),
            NSLayoutConstraint(item: self.backButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 45)]
        
        // Attach the Back button to the Right side of the Screen offset By 30 pixels
        var forwardButtonConstraints:[AnyObject] = [NSLayoutConstraint(item: self.forwardButton, attribute: .Right, relatedBy: .Equal, toItem: self.Header, attribute: .Right, multiplier: 1.0, constant: -30),
            NSLayoutConstraint(item: self.forwardButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.Header, attribute: .CenterY, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.forwardButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 45),
            NSLayoutConstraint(item: self.forwardButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 45)]
        
        // Attach the Top of the Main View to the Bottom of the Header
        var mainConstraints:[AnyObject] = [NSLayoutConstraint(item: self.Main, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0),NSLayoutConstraint(item: self.Main, attribute: .Top, relatedBy: .Equal, toItem: self.Header, attribute: .Bottom, multiplier: 1.0, constant: 0),NSLayoutConstraint(item: self.Main, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: newSize.width),NSLayoutConstraint(item: self.Main, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: newSize.height-headerHeight)]
        
        // Add Constraints
        self.view.addConstraints(headerConstraints)
        self.view.addConstraints(mainConstraints)
        self.view.addConstraints(backButtonConstraints)
        self.view.addConstraints(forwardButtonConstraints)
    }
    //----------------------------------------------
    override func viewDidAppear() {
        let presOptions: NSApplicationPresentationOptions
        if canForceQuit == false {
            presOptions =
                .HideDock                  |   // Dock is entirely unavailable. Spotlight menu is disabled.
                .HideMenuBar               |   // Menu Bar is Disabled
                .DisableAppleMenu          |   // All Apple menu items are disabled.
                .DisableProcessSwitching   |   // Cmd+Tab UI is disabled. All Exposé functionality is also disabled.
                .DisableSessionTermination |   // PowerKey panel and Restart/Shut Down/Log Out are disabled.
                .DisableHideApplication    |   // Application "Hide" menu item is disabled.
                .AutoHideToolbar           |
                .DisableForceQuit              // Cmd+Opt+Esc panel is disabled
        }
        else {
            presOptions =
            .HideDock                  |   // Dock is entirely unavailable. Spotlight menu is disabled.
            .HideMenuBar               |   // Menu Bar is Disabled
            .DisableAppleMenu          |   // All Apple menu items are disabled.
            .DisableProcessSwitching   |   // Cmd+Tab UI is disabled. All Exposé functionality is also disabled.
            .DisableSessionTermination |   // PowerKey panel and Restart/Shut Down/Log Out are disabled.
            .DisableHideApplication    |   // Application "Hide" menu item is disabled.
            .AutoHideToolbar
        }
        
        let optionsDictionary = [NSFullScreenModeApplicationPresentationOptions :
            NSNumber(unsignedLong: presOptions.rawValue)]
        
        self.view.enterFullScreenMode(NSScreen.mainScreen()!, withOptions:optionsDictionary)
        self.view.wantsLayer = true
    }
    //----------------------------------------------
    override func viewWillAppear() {
    
    }
    //----------------------------------------------
    // MARK: WebView
    //----------------------------------------------
    func setupWebView() {
        // Tell the WebViews to allow buttons to be drawn onto view
        self.Header.wantsLayer = true
        self.Header.needsDisplay = true
        
        // Set The Frame Height
        self.Main.downloadDelegate = self
        self.Main.policyDelegate = self
        self.Main.needsDisplay = true
        self.Main.wantsLayer = true
        self.Main.editable = false
        self.Header.setMaintainsBackForwardList(false)
        self.Main.setMaintainsBackForwardList(true)
        self.Main.shouldUpdateWhileOffscreen = true
        
        // Load the URLS
        self.Main.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: mainWebUrl)!))
        self.Header.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: customHeaderUrl)!))
    }
    //----------------------------------------------
    func setupButtons() {
         
        // Tell the buttons to draw on top of the WebView
        self.forwardButton.needsDisplay = true
        self.forwardButton.wantsLayer = true
        self.backButton.needsDisplay = true
        self.backButton.wantsLayer = true
        self.timer.wantsLayer = true
    }
    //----------------------------------------------
    // Test the loaded Frame
    //----------------------------------------------
    func TestMainURL() {
        var error: NSError?
        var url: String = self.Main.mainFrameURL
        let regex = NSRegularExpression(pattern: regexString, options:nil, error:&error);
        
        if url.isEmpty {
            return;
        }
        
        var didValidate = false
        var textRange: NSRange! = NSMakeRange(0, count(url))
        var matchRange: NSRange! = regex?.rangeOfFirstMatchInString(url, options:nil, range:textRange)
        
        if matchRange.location != NSNotFound {
            didValidate = true
        }
        
        if !didValidate {
            
            let alert = NSAlert()
            alert.messageText = "Woah There!"
            alert.addButtonWithTitle("Take me Back!")
            alert.informativeText = "Please only use this kiosk for viewing Watershed related pages \(self.Main.mainFrameURL)!"
            if alert.runModal() == NSAlertFirstButtonReturn {
                self.Main.stopLoading(self.Main)
            }
        }
    }
    //----------------------------------------------
    override func webView(sender: WebView!, didStartProvisionalLoadForFrame frame: WebFrame!) {
        
        // Pass the link from the Header to the Main WebView then stop the Header from updating/loading the requested page
        if sender == Header {
            self.Main.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: Header.mainFrameURL)!))
            if Header.mainFrameURL != customHeaderUrl {
                self.Header.stopLoading(self)
            }
        }
        // Test if user is looking at stuff other than Watershed Content
        else if sender == Main {
            self.TestMainURL()
        }
    }
    //----------------------------------------------
    override func webView(sender: WebView!, didReceiveTitle title: String!, forFrame frame: WebFrame!) {
        if sender == Main {
            // Resize the HTML
            var domDocument: DOMDocument! = Main.mainFrame.DOMDocument
            var htmlElement: DOMElement! =  domDocument.getElementsByTagName("html").item(0) as! DOMElement
            htmlElement.setAttribute("style", value: zoomValue)
        }
    }
    //----------------------------------------------
    override func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        if sender == Main {
            var attr: DOMNode!
            var myDOMDocument: DOMDocument! = self.Main.mainFrame.DOMDocument
            var iFrames: NSMutableArray = NSMutableArray()
            hasMainGotAnIFrame = false
            self.walkNodeTree(myDOMDocument, iFramesCollected: iFrames)
        }
    }
    //---------------------------------------------
    // MARK: DOMStuff
    //---------------------------------------------
    func walkNodeTree(parent: DOMNode!, htmlElementsCollected htmlElements:NSMutableArray!) {
        var nodeList: DOMNodeList! = parent.childNodes
        var i = nodeList.length
        var length = nodeList.length
        
        for i = 0; i < length; i++ {
            var node: DOMNode! = nodeList.item(i)
            if node.nodeName.lowercaseString == "html" {
                htmlElements.addObject(node)
            }
            else {
                self.walkNodeTree(node, htmlElementsCollected: htmlElements)
            }
        }
    }
    //---------------------------------------------
    func walkNodeTree(parent: DOMNode!, iFramesCollected iFrames:NSMutableArray!) {
        var nodeList: DOMNodeList! = parent.childNodes
        var i = nodeList.length
        var length = nodeList.length
        
        for i = 0; i < length; i++ {
            var node: DOMNode! = nodeList.item(i)
            if node.nodeName.lowercaseString == "iframe" {
                println("Found iFrame")
                hasMainGotAnIFrame = true
            }
            else {
                self.walkNodeTree(node, iFramesCollected: iFrames)
            }
        }
    }
    //---------------------------------------------
    // MARK: Segue
    //---------------------------------------------
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSaver" {
            if let destinationVC = segue.destinationController as? SaverView {
                lastURL = self.Main.mainFrameURL
                println("Sending from ViewController \(lastURL)")
                destinationVC.lastURL = self.lastURL
                destinationVC.hasMainGotAnIFrame = self.hasMainGotAnIFrame
                // This is important: Send the Main WebView through the Segue and hold its reference
                destinationVC.holdingView = self.Main
            }
        }
    }
    //---------------------------------------------
    override var representedObject: AnyObject? {
        didSet {
            if self.resetWebView == true {
                println("Reset")
                Main = self.representedObject as! WebView
            }
        }
    }
    //---------------------------------------------
    // MARK: timer
    //---------------------------------------------
    func timerCheck() {
        var t: Int64 = IOTimer.SystemIdleTime()
        var myString = String(t)
        self.timer.stringValue = myString
        
        // Go to Saver View with Custom Segue Action
        if hasMainGotAnIFrame == true {
            if t >= Int64(iFrameIdleTime) && !latch  {
                println("iFrame Idle Timer Trigger")
                self.performSegueWithIdentifier("toSaver", sender: self)
                latch = true
            }
        }
        else {
            if t >= Int64(standardIdleTime) && !latch  {
                println("Standard Idle Timer Trigger")
                self.performSegueWithIdentifier("toSaver", sender: self)
                latch = true
            }
        }
        // Reset the Latch
        if t == 0 && latch {
            latch = false
        }
    }
}

