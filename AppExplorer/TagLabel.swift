//
//  TagLabel.swift
//  AppExplorer
//
//  Created by Cardasis, Jonathan (J.) on 7/13/16.
//  Copyright © 2016 Cardasis, Jonathan (J.). All rights reserved.
//

import UIKit

@IBDesignable class TagLabel: UILabel {

    @IBInspectable var primaryColor: UIColor = UIColor.lightGrayColor(){
        didSet{
            self.layer.backgroundColor = primaryColor.CGColor
        }
    }
    @IBInspectable var secondaryTagColor: UIColor = UIColor.darkGrayColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        self.layer.masksToBounds = true
        self.layer.backgroundColor = primaryColor.CGColor
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.height/2
        self.font = UIFont(descriptor: self.font.fontDescriptor(), size: self.bounds.height/2)
        self.textAlignment = .Center
    }
    

}
