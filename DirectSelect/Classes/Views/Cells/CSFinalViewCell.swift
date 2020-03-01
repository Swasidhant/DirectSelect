//
//  CSFinalViewCell.swift
//  CustomSelector
//
//  Created by swasidhant chowdhury on 25/12/19.
//

import UIKit

public protocol DSSubview: class {
    var delegate: DSDefaultCellSubviewDelegate? {get set}
    
    //callback when the subview enters the area of selection, (i.e. it enters between the two separator lines in the final tableview UI) you might want to make ui changes here
    //For example, you might want to make the text font/color changes or background color changes
    func wentInsideSelectionArea()
    
    //callback when the subview goes outside the area of selection, (i.e. it enters outside the two separator lines in the final tableview UI) you might want to make ui changes here
    func wentOutsideSelectionArea()
    
    //give the list of views who size or position who want to change between the initial and final views
    func giveViewsToAnimate() -> [UIView]
    
    //this one's a bit tricky. So basically when we animate between different sizes between initial and final views, the spaces between the views will be different in the initial and final views
    //so either you can give different constraints and return an array of CGFloat(0.0)s here (with length equal to the no of elements in giveViewsToAnimate())
    //or you can return the values of how much to move the views in the x-coordinate space
    func giveHorizontalTransformValues() -> [CGFloat]
    
    //make the initial data and Ui setup of your subview
    //DSInitialSetupViewType gives whether this subview instance is used in DSInitialView or DSFinalView
    func initialSetup(_ data: Any?, viewType: DSInitialSetupViewType)
    
    //make the data assignment
    func assignData(_ data: Any?)
    
    //give initial sizes of the views you want to be animated (you had passed them in giveViewsToAnimate())
    //the order should be the same as the order of the views in giveViewsToAnimate()
    func getInitialViewSizes(_ data: Any?) -> [CGSize]
    
    //give final sizes of the views you want to be animated (you had passed them in giveViewsToAnimate())
    //the order should be the same as the order of the views in giveViewsToAnimate()
    func getFinalViewSizes(_ data: Any?) -> [CGSize]
}

/*******************************************************************************************/
//MARK:- the default view used for showing options
/*******************************************************************************************/
public protocol DSDefaultCellSubviewDelegate: class {
    func showFinalViewAction()
}

class DSDefaultCellSubview: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!

    var selectionColor: UIColor = UIColor.black
    var nonSelectionColor: UIColor = UIColor.lightGray
    
    var delegate: DSDefaultCellSubviewDelegate?
    
    static func createInstance(delegate: DSDefaultCellSubviewDelegate?, optionButtonShown: Bool) -> DSDefaultCellSubview {
        let bundle = Bundle.csBundle
        let view = bundle.loadNibNamed("DSDefaultCellSubview", owner: nil, options: nil)![0] as! DSDefaultCellSubview
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

extension DSDefaultCellSubview: DSSubview {    
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
    var inputSubview: DSSubview?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func isSubviewNeeded() -> Bool {
        return self.inputSubview == nil
    }
    
    func assignAndAddSubview(_ subview: DSSubview, initialSetupData: Any?) {
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
