//
//  CustomSegue.swift
//  rWeb

//  Created by jonathan on 25/01/2015.
//  Copyright (c) 2015 net.ellipsis. All rights reserved.
//
//  Modified by David Haylock on 27/05/2015.
//

import Cocoa

class CustomSegue: NSStoryboardSegue {
    override init(identifier: String?,
        source sourceController: AnyObject,
        destination destinationController: AnyObject) {
            var myIdentifier : String
            if identifier == nil {
                myIdentifier = "toSaver"
            } else {
                myIdentifier = identifier!
            }
            super.init(identifier: myIdentifier, source: sourceController, destination: destinationController)
    }

    override func perform() {
        let animator = CustomSegueAnimator()
        let sourceVC  = self.sourceController as! ViewController
        let destVC = self.destinationController as! SaverView
        animator.animatePresentationOfViewController(destVC, fromViewController: sourceVC)
    }
}

class CustomDismissal: NSStoryboardSegue {
    override init(identifier: String?,
        source sourceController: AnyObject,
        destination destinationController: AnyObject) {
            var myIdentifier : String
            if identifier == nil {
                myIdentifier = "toMain"
            } else {
                myIdentifier = identifier!
            }
            super.init(identifier: myIdentifier, source: sourceController, destination: destinationController)
    }
    
    override func perform() {
        let animator = CustomSegueAnimator()
        let sourceVC  = self.sourceController as! SaverView
        let destVC = self.destinationController as! ViewController
        animator.animateDismissalOfViewController(sourceVC, fromViewController: destVC)
    }

}