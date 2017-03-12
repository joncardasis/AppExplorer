//
//  ApplicationManager.swift
//  AppExplorer
//
//  Created by Cardasis, Jonathan (J.) on 7/13/16.
//  Copyright © 2016 Cardasis, Jonathan (J.). All rights reserved.
//

import Foundation

class SystemApplicationManager: NSObject {
    static let sharedManager = SystemApplicationManager()
    fileprivate var workspace: LSApplicationWorkspace?
    
    
    override init() {
        workspace = LSApplicationWorkspace.defaultWorkspace() as? LSApplicationWorkspace
    }
    
    func allInstalledApplications() -> [SystemApplication]{
        guard let workspace = workspace else { //protect
            return []
        }
        var applications = [SystemApplication]()
        let installedApplicationProxies = workspace.allInstalledApplications() as! [LSApplicationProxy]
        
        for applicationProxy in installedApplicationProxies {
            
            let bundleIdentifier = applicationProxy.bundleIdentifier
            let appIcon = self.applicationIconImageForBundleIdentifier(bundleIdentifier!)
            
            /* Create and map a system application object to LSApplicationProxys variables */
            let app = SystemApplication()
            app.map(bundleID: bundleIdentifier,
                    name: applicationProxy.localizedName,
                    version: applicationProxy.shortVersionString,
                    executableName: applicationProxy.bundleExecutable,
                    type: applicationProxy.applicationType,
                    signerIdentity: applicationProxy.signerIdentity,
                    applicationPath: applicationProxy.dataContainerURL,
                    backgroundModes: applicationProxy.uiBackgroundModes as? [String],
                    icon: appIcon
            )
            
            applications.append(app)
        }
        
        return applications
    }
    
    
    @discardableResult func openApplication(_ app: SystemApplication) -> Bool {
        if let workspace = workspace {
            return workspace.openApplication(withBundleID: app.bundleID)
        }
        return false
    }
    
    @discardableResult func openApplication(bundleID: String) -> Bool {
        if let workspace = workspace {
            return workspace.openApplication(withBundleID: bundleID)
        }
        return false
    }
    
    func applicationIconImageForBundleIdentifier(_ bundleID: String) -> UIImage?{
        //Format of 2 will return a 62x62 image
        return UIImage._applicationIconImage(forBundleIdentifier: bundleID, format: 2
            , scale: Double(UIScreen.main.scale)) as? UIImage
    }
    
}
