//
//  CSFinalViewCell.swift
//  CustomSelector
//
//  Created by swasidhant chowdhury on 25/12/19.
//

import UIKit

public protocol CSSubview: class {
    var delegate: DSDefaultCellSubviewDelegate? {get set}
    
    func wentInsideSelectionArea()
    func wentOutsideSelectionArea()
    func giveViewsToAnimate() -> [UIView]
    func giveHorizontalTransformValues() -> [CGFloat]
    
    func initialSetup(_ data: Any?, viewType: DSInitialSetupViewType)
    func assignData(_ data: Any?)
    
    func getInitialViewSizes(_ data: Any?) -> [CGSize]
    func getFinalViewSizes(_ data: Any?) -> [CGSize]
}

/*******************************************************************************************/
//MARK:- the default view used for showing options
/*******************************************************************************************/
public protocol DSDefaultCellSubviewDelegate: class {
    func showFinalViewAction()
}

class CSDefaultCellSubview: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!

    var selectionColor: UIColor = UIColor.black
    var nonSelectionColor: UIColor = UIColor.lightGray
    
    var delegate: DSDefaultCellSubviewDelegate?
    
    static func createInstance(delegate: DSDefaultCellSubviewDelegate?, optionButtonShown: Bool) -> CSDefaultCellSubview {
        let bundle = Bundle.csBundle
        let view = bundle.loadNibNamed("DSDefaultCellSubview", owner: nil, options: nil)![0] as! CSDefaultCellSubview
        view.delegate = delegate
        view.optionsButton.isHidden = !optionButtonShown
        return view
    }
    
    func setup(optionsButtonColor: UIColor?) {
        if self.optionsButton.isHidden == false, let optionsButtonColor = optionsButtonColor {
            let image = UIImage.init(named: "options", in: Bundle.csImgBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            self.optionsButton.setImage(image, for: .normal)
            self.optionsButton.setImage(image, for: .highlighted)
            self.optionsButton.imageView?.tintColor = optionsButtonColor
        }
    }
    
    func assign(_ text: String) {
        self.titleLabel.text = text
    }
    
    private func updateTitleColor( _ color: UIColor) {
        titleLabel.textColor = color
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        delegate?.showFinalViewAction()
    }
}

extension CSDefaultCellSubview: CSSubview {    
    func giveHorizontalTransformValues() -> [CGFloat] {
        return [CGFloat(0.0)]
    }
    
    func wentInsideSelectionArea() {
        self.updateTitleColor(selectionColor)
    }
    
    func wentOutsideSelectionArea() {
        self.updateTitleColor(nonSelectionColor)
    }
    
    func initialSetup(_ data: Any?, viewType: DSInitialSetupViewType) {
        guard let uiConfigs = data as? DSDataModel.DSUIConfigs else {
            fatalError("initialSetup data to CSDefaultCellSubview is not of CSDataModel.CSUIConfigs type")
        }
        self.selectionColor = uiConfigs.initialFontColor
        self.titleLabel.font = viewType == .initialView ? uiConfigs.initialFont : uiConfigs.finalFont
        self.titleLabel.textColor = uiConfigs.initialFontColor
        self.backgroundColor = uiConfigs.finalBGColor
    }
    
    func assignData(_ data: Any?) {
        guard let text = data as? String else {
            fatalError("data to CSDefaultCellSubview is not of String type")
        }
        self.titleLabel.text = text
    }
    
    func giveViewsToAnimate() -> [UIView] {
        return [self.titleLabel]
    }
    
    func getInitialViewSizes(_ data: Any?) -> [CGSize] {
        if let font = data as? UIFont {
            return self.getSizeWithFont(font)
        }
        return [CGSize.zero]
    }
    
    func getFinalViewSizes(_ data: Any?) -> [CGSize] {
        if let font = data as? UIFont {
            return self.getSizeWithFont(font)
        }
        return [CGSize.zero]
    }
    
    private func getSizeWithFont(_ font: UIFont) -> [CGSize] {
        if let text = self.titleLabel.text as NSString? {
            return [text.size(withAttributes: [.font: font])]
        }
        return [CGSize.zero]
    }
}


/*******************************************************************************************/
//MARK:- the default view used for showing options
/*******************************************************************************************/
class CSCustomSubview: UIView {
    
}

/*******************************************************************************************/
//MARK:- the cell used to show options
/*******************************************************************************************/
class DSFinalViewCell: UITableViewCell {
    var inputSubview: CSSubview?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func isSubviewNeeded() -> Bool {
        return self.inputSubview == nil
    }
    
    func assignAndAddSubview(_ subview: CSSubview, initialSetupData: Any?) {
        if self.inputSubview == nil {
            self.inputSubview = subview
            guard let subview = self.inputSubview as? UIView else {
                fatalError("Input Subview is not of type UIView")
            }
            
            //cells are present in final view only
            self.inputSubview?.initialSetup(initialSetupData, viewType: .finalView)
            subview.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(subview)
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": subview])
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": subview])
            
            self.addConstraints(horizontalConstraints)
            self.addConstraints(verticalConstraints)
        }
    }
    
    func assign(_ data: Any?) {
        inputSubview?.assignData(data)
    }
    
    func movedInsideSelectionArea() {
        inputSubview?.wentInsideSelectionArea()
    }
    
    func movedOutsideSelectionArea() {
        inputSubview?.wentOutsideSelectionArea()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
    }
}
