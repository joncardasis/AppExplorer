//
//  EmbeddableSystemApplicationManager.swift
//  AppExplorer
//
//  Created by Jonathan Cardasis on 8/8/16.
//  Copyright © 2016 Cardasis, Jonathan (J.). All rights reserved.
//

import UIKit
import Foundation


//Reverse-Engineered interface for LSApplicationWorkspace
@objc private protocol LSApplicationWorkspace_Interface{
    @objc func defaultWorkspace()-> LSApplicationWorkspace_Interface
    @objc func allInstalledApplications() -> [NSObject]
    @objc func openApplicationWithBundleID(bundleID: AnyObject!) -> Bool
}
@objc private protocol UIImage_Private_Interface{
    @objc func _applicationIconImageForBundleIdentifier(bundleID: AnyObject!, format: AnyObject!, scale: AnyObject!)
}

//Reverse-Engineered calls and variables
private struct ReversedCall{
    struct LSApplicationWorkspace {
        struct Selector{
            static let workspace = #selector(LSApplicationWorkspace_Interface.defaultWorkspace)
            static let getAllInstalledApplications = #selector(LSApplicationWorkspace_Interface.allInstalledApplications)
            static let openApplicationWithBundleID = #selector(LSApplicationWorkspace_Interface.openApplicationWithBundleID(_:))
        }
    }
    
    struct LSApplicationProxy {
        static let bundleIdentifier     = "bundleIdentifier"
        static let localizedName        = "localizedName"
        static let shortVersionString   = "shortVersionString"
        static let bundleExecutable     = "bundleExecutable"
        static let applicationType      = "applicationType"
        static let signerIdentity       = "signerIdentity"
        static let dataContainerURL     = "dataContainerURL"
        static let UIBackgroundModes    = "UIBackgroundModes"
    }
    
    struct UIImage{
        static let applicationIconImageForBundleIdentifier = #selector(UIImage_Private_Interface._applicationIconImageForBundleIdentifier(_:format:scale:))

    }
}


class EmbeddableSystemApplicationManager: NSObject {
    static let sharedManager = EmbeddableSystemApplicationManager()
    private var workspace: NSObject? //LSApplicationWorkspace
    
    private let LSApplicationWorkspace_class: AnyClass! = NSClassFromString("LSApplicationWorkspace")
    
    override init(){
        //Setup workspace
        if let myClass =  LSApplicationWorkspace_class as? NSObjectProtocol {
            if myClass.respondsToSelector(ReversedCall.LSApplicationWorkspace.Selector.workspace) {
                self.workspace = myClass.performSelector(ReversedCall.LSApplicationWorkspace.Selector.workspace).takeRetainedValue() as? NSObject
            }
        }
    }
    
    
    func allInstalledApplications() -> [SystemApplication]{
        guard let workspace = workspace else{
            return []
        }
        guard workspace.respondsToSelector(ReversedCall.LSApplicationWorkspace.Selector.getAllInstalledApplications) == true else{
            return []
        }
        var applications = [SystemApplication]()
        
        //Take an Unretained value so ARC doesn't release the workspace's installed apps array
        if let installedApplicationProxies = workspace.performSelector(ReversedCall.LSApplicationWorkspace.Selector.getAllInstalledApplications).takeUnretainedValue() as? NSArray{
        
            for installedApp in installedApplicationProxies{
                guard let bundleID = installedApp.valueForKey(ReversedCall.LSApplicationProxy.bundleIdentifier) as? String else{
                    return applications
                }
                
                let appIcon = self.applicationIconImageForBundleIdentifier(bundleID)
                
                let app = SystemApplication()
                app.map(bundleID: bundleID,
                        name: installedApp.valueForKey(ReversedCall.LSApplicationProxy.localizedName) as? String,
                        version: installedApp.valueForKey(ReversedCall.LSApplicationProxy.shortVersionString) as? String,
                        executableName: installedApp.valueForKey(ReversedCall.LSApplicationProxy.bundleExecutable) as? String,
                        type: installedApp.valueForKey(ReversedCall.LSApplicationProxy.applicationType) as? String,
                        signerIdentity: installedApp.valueForKey(ReversedCall.LSApplicationProxy.signerIdentity) as? String,
                        applicationPath: installedApp.valueForKey(ReversedCall.LSApplicationProxy.dataContainerURL) as? NSURL,
                        backgroundModes: installedApp.valueForKey(ReversedCall.LSApplicationProxy.UIBackgroundModes) as? [String],
                        icon: appIcon
                )
                applications.append(app)
            }
        }
        return applications
    }
    
    func openApplication(app: SystemApplication) -> Bool {
        if let bundleID = app.bundleID{
            return self.openApplication(bundleID: bundleID)
        }
        return false
    }
    
    func openApplication(bundleID bundleID: String) -> Bool {
        if let workspace = workspace where workspace.respondsToSelector(ReversedCall.LSApplicationWorkspace.Selector.openApplicationWithBundleID){
            if workspace.performSelector(ReversedCall.LSApplicationWorkspace.Selector.openApplicationWithBundleID, withObject: bundleID) != nil{
                return true //Not entirely accurate, but probably opened
            }
        }
        return false
    }

    func applicationIconImageForBundleIdentifier(bundleID: String) -> UIImage?{
        let appIconSelector = ReversedCall.UIImage.applicationIconImageForBundleIdentifier
        //Selector format is (bundleID: String, format: Int, scale: Double) - format 2 will return a 62x62 image

        return Invocator.performClassSelector(appIconSelector, target: UIImage.self, args: [bundleID, 2, Double(UIScreen.mainScreen().scale)]) as? UIImage
    }
}
