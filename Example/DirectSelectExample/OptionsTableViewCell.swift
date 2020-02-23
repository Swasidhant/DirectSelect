//
//  OptionsTableViewCell.swift
//  CustomSelector_Example
//
//  Created by swasidhant chowdhury on 12/01/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DirectSelect

class OptionsTableViewCell: UITableViewCell {
    
    var dataModel: DSDataModel?
    var initialView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initialseInitialView() {
        if self.initialView == nil {
            self.initialView = DSInitialView.createInstance(model: self.dataModel!, delegate: nil)
            self.initialView?.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.initialView!)
            self.addRequiredConstraints()
        }
    }
    
    private func addRequiredConstraints() {
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.initialView!])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.initialView!])
        
        self.addConstraints(horizontalConstraints)
        self.addConstraints(verticalConstraints)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
