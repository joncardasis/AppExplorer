//
//  AppTableViewCell.swift
//  AppExplorer
//
//  Created by Cardasis, Jonathan (J.) on 7/13/16.
//  Copyright © 2016 Cardasis, Jonathan (J.). All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell {
    
    @IBOutlet weak var appIconView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var typeTag: TagLabel!
    @IBOutlet weak var launchButton: UIButton!
    weak var application: SystemApplication?
    
    var separator = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separator.fillColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1).CGColor
        self.layer.addSublayer(separator)
    }

    
    override func layoutSubviews() {
        let separatorFrame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: bounds.height - 2.0/UIScreen.mainScreen().scale, width: bounds.width, height: 2.0/UIScreen.mainScreen().scale), self.separatorInset)
        
        separator.path = UIBezierPath(rect: separatorFrame).CGPath
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
