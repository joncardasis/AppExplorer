//
//  SystemApplication.swift
//  AppExplorer
//
//  Created by Cardasis, Jonathan (J.) on 7/13/16.
//  Copyright © 2016 Cardasis, Jonathan (J.). All rights reserved.
//

import UIKit

enum SystemApplicationType{
    case System
    case User
}

class SystemApplication: NSObject {
    var bundleID: String?
    var name: String? //Springboard display name
    var version: String?
    var executableName: String? //Name of internal payload executable
    var type: SystemApplicationType?
    var signerIdentity: String?
    var applicationPath: NSURL?
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
    func map(bundleID
        bundleID: String?,
        name: String?,
        version: String?,
        executableName: String?,
        type: String?,
        signerIdentity: String?,
        applicationPath: NSURL?,
        backgroundModes: [String]?,
        icon: UIImage?
        ){
        
        self.bundleID = bundleID
        self.name = name
        self.version = version
        self.executableName = executableName
        if type == "System"{
            self.type = .System
        }
        else{
            self.type = .User
        }
        self.signerIdentity = signerIdentity
        self.applicationPath = applicationPath
        self.backgroundModes = backgroundModes
        self.icon = icon
    }
   
    
    
}
