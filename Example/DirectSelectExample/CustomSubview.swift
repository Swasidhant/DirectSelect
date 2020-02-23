//
//  CustomSubview.swift
//  CustomSelector_Example
//
//  Created by swasidhant chowdhury on 12/01/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DirectSelect

class CustomSubview: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    var delegate: DSDefaultCellSubviewDelegate?
    
    static func createInstance() -> CustomSubview {
        let view = Bundle.main.loadNibNamed("CustomSubview", owner: nil, options: nil)![0] as! CustomSubview
        return view
    }
    
    private func updateTitleColor( _ color: UIColor) {
        titleLabel.textColor = color
    }
    
    private func udpateImageSize(scaleFactor: CGFloat) {
        imageView.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }
    
    private func getSizeWithFont(_ font: UIFont) -> CGSize {
        if let text = self.titleLabel.text as NSString? {
            return text.size(withAttributes: [.font: font])
        }
        return CGSize.zero
    }

}

extension CustomSubview: CSSubview {    
    func giveHorizontalTransformValues() -> [CGFloat] {
        return [CGFloat(7.0), CGFloat(0.0)]
    }
    
    func getInitialViewSizes(_ data: Any?) -> [CGSize] {
        let titleSize = self.getSizeWithFont(UIFont.systemFont(ofSize: 14.0))
        return [titleSize, CGSize.init(width: 35.0, height: 35.0)]
    }
    
    func getFinalViewSizes(_ data: Any?) -> [CGSize] {
        let titleSize = self.getSizeWithFont(UIFont.systemFont(ofSize: 16.0))
        return [titleSize, CGSize.init(width: 42.0, height: 42.0)]
    }
    
    func wentInsideSelectionArea() {
        updateTitleColor(.black)
        udpateImageSize(scaleFactor: 1.0)
    }
    
    func wentOutsideSelectionArea() {
        updateTitleColor(.lightGray)
        udpateImageSize(scaleFactor: 0.85)
    }
    
    func giveViewsToAnimate() -> [UIView] {
        return [self.titleLabel, self.imageView]
    }
    
    func initialSetup(_ data: Any?, viewType: DSInitialSetupViewType) {
        switch viewType {
        case .initialView:
            titleLabel.font = UIFont.systemFont(ofSize: 14.0)
            imageViewWidth.constant = 35.0
            imageViewHeight.constant = 35.0
        case .finalView:
            titleLabel.font = UIFont.systemFont(ofSize: 16.0)
            imageViewWidth.constant = 42.0
            imageViewHeight.constant = 42.0
        }
    }
    
    func assignData(_ data: Any?) {
        guard let (text, imageName) = data as? (String, String) else {
            return
        }
        
        titleLabel.text = text
        imageView.image = UIImage.init(named: imageName, in: Bundle.main, compatibleWith: nil)
    }
}
