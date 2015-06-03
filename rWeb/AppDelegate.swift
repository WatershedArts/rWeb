//
//  AppDelegate.swift
//  rWebSwift
//
//  Created by David Haylock on 26/05/2015.
//  Copyright (c) 2015 David Haylock. All rights reserved.
//

import Cocoa
import AppKit

//---------------------------------------------
// MARK: Config.plist Dictionary Keys
//---------------------------------------------
let dictMainURLKey = "Main url"
let dictPromotionalURLKey = "Promotional url"
let dictHeaderURLKey = "Header url"
let dictRegexKey = "Regex String"
let dictHTMLZoomKey = "HTML Zoom Value"
let dictStandardIdleTimeKey = "Standard Idle Time"
let dictIFrameIdleTimeKey = "iFrame Idle Time"
let dictResetTimeKey = "Reset Time"
let dictHeaderHeightKey = "Header Height"
let dictCustomAgent = "Custom Agent"
//---------------------------------------------
// MARK: Get Dictionary
//---------------------------------------------
let Config = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
let Dict = NSMutableDictionary(contentsOfFile: Config!)
//---------------------------------------------
// MARK: Get Dictionary
//---------------------------------------------
var mainWebUrl = Dict!.objectForKey(dictMainURLKey) as! String
var customHeaderUrl = Dict!.objectForKey(dictHeaderURLKey) as! String
var promotionalWebUrl = Dict!.objectForKey(dictPromotionalURLKey) as! String
var regexString = Dict!.objectForKey(dictRegexKey) as! String
var zoomValue = Dict!.objectForKey(dictHTMLZoomKey) as! String
var standardIdleTime:Int = Dict!.objectForKey(dictStandardIdleTimeKey) as! Int
var iFrameIdleTime:Int = Dict!.objectForKey(dictIFrameIdleTimeKey) as! Int
var extraTime:Int = Dict!.objectForKey(dictResetTimeKey) as! Int
var headerHeight = Dict!.objectForKey(dictHeaderHeightKey) as! CGFloat
var customAgent = Dict!.objectForKey(dictCustomAgent) as! String

var resetWebViewStandardTime:Int = standardIdleTime + extraTime
var resetWebViewiFrameTime:Int = iFrameIdleTime + extraTime

// Important for Resizing elements
let newSize: NSSize! = NSScreen.screens()?.first?.frame.size
//let newSize: NSSize! = NSScreen.screens()?.last?.frame.size

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate   {
    
    //---------------------------------------------
    // MARK: Application functions
    //---------------------------------------------
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        println("----------------------------------------------")
        println("Loaded plist file")
        println("Main Web Url --> \(mainWebUrl)")
        println("Header Web Url --> \(customHeaderUrl)")
        println("Promotional Web Url --> \(promotionalWebUrl)")
        println("Regex String --> \(regexString)")
        println("Zoom Value --> \(zoomValue)")
        println("Standard Idle Time --> \(standardIdleTime)")
        println("iFrame Idle Time --> \(iFrameIdleTime)")
        println("Reset Time --> \(extraTime)")
        println("Header Height --> \(headerHeight)")
        println("Custom Agent --> \(customAgent)")
        println("----------------------------------------------")
    }
    //---------------------------------------------
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    //---------------------------------------------
}
