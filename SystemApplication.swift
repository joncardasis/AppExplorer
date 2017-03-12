//
//  SystemApplication.swift
//  AppExplorer
//
//  Created by Cardasis, Jonathan (J.) on 7/13/16.
//  Copyright © 2016 Cardasis, Jonathan (J.). All rights reserved.
//

import UIKit

enum SystemApplicationType{
    case system
    case user
}

class SystemApplication: NSObject {
    var bundleID: String?
    var name: String? //Springboard display name
    var version: String?
    var executableName: String? //Name of internal payload executable
    var type: SystemApplicationType?
    var signerIdentity: String?
    var applicationPath: URL?
    var backgroundModes: [String]?
    var icon: UIImage?
    
    override init(){
        super.init()
    }
    
    init(bundleID: String){
        super.init()
        self.bundleID = bundleID
    }
    
    
    /*
     Mapping function.
     Pass nil for any parameter not given
    */
    func map(bundleID: String?,
        name: String?,
        version: String?,
        executableName: String?,
        type: String?,
        signerIdentity: String?,
        applicationPath: URL?,
        backgroundModes: [String]?,
        icon: UIImage?
        ){
        
        self.bundleID = bundleID
        self.name = name
        self.version = version
        self.executableName = executableName
        if type == "System"{
            self.type = .system
        }
        else{
            self.type = .user
        }
        self.signerIdentity = signerIdentity
        self.applicationPath = applicationPath
        self.backgroundModes = backgroundModes
        self.icon = icon
    }
   
    
    
}
