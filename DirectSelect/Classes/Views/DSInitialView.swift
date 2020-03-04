//
//  CSInitialView.swift
//  CustomSelector
//
//  Created by swasidhant chowdhury on 25/12/19.
//
import UIKit

public class DSDataModel {
    public class DSUIConfigs {
        //should show an options expanding button on the initial view (See the second expanding view in the Example project)
        public var showOptionsButton: Bool = false
        
        //tintColor of the options button if its shown
        public var optionsBtnColor: UIColor = UIColor.init(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        //font of the text on the initial view
        public var initialFont: UIFont = UIFont.systemFont(ofSize: 14.0)
        
        //font of the text on the rows of the final tableview
        public var finalFont: UIFont = UIFont.systemFont(ofSize: 18.0)
        
        //font of the title of final tableview view
        public var finalTitleFont: UIFont = UIFont.systemFont(ofSize: 18.0)
        
        //font color of the text on the initial view
        public var initialFontColor: UIColor = UIColor.init(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        //font color of the text on the rows of the final tableview
        public var finalFontColor: UIColor = UIColor.init(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        //background color of both the initial View and the final view cells and tableview
        public var finalBGColor: UIColor = UIColor.white
        
        //separator color of tableview
        public var finalBGSeparatorColor: UIColor = UIColor.init(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        
        //font color of the title of final tableview view
        public var finalTitleColor: UIColor = UIColor.init(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        //UI configs of intro view if it is used
        public var introViewUIModel: DSIntroUIModel?
        
        public init() {
            
        }
    }
    
    public init() {
        
    }
    
    //title to display on top of the final tableview
    public var titleString: String?
    
    //options to display on top of the final tableview. Type is [Any] as the even custom Subviews are allowed through CSSubview
    public var values: [Any] = []
    
    //time interval for which final tableview shows before auto dismissing
    public var longPressDuration: TimeInterval = 1.0
    
    //initial index which is selected by default in the tableview
    public var initialIndex: Int = 0
    
    //initial data which is shown by default in the tableview
    public var initialData: Any?
    
    //case defaultCell - we are using the default view for initial view and final view cells
    //case customCell - we are custom view for initial view and final view cells
    public var cellSubviewType: CSCellSubviewType = .defaultCell
    
    //UI configs instance explained above
    public var uiConfigs = DSUIConfigs()
    
    //superview on which to add the final Tableview UI as subview
    //if this is nil, we add the final Tableview UI to the superview of DSinitialView instance
    //make this nil if the initial view is a direct subview of the view on which you need to present the final tableview UI
    //other assign this property to the intended superview of the final tableview UI
    public var finalViewSuperview: UIView?
    
    //in case you are using custom subview, this block should return an instance of your custom subview
    //we call this block when we want to initialize an instance of your subview.
    //For assigning properties to your subview, we call assignData method of the CSSubview
    public var customSubviewCreator: (() -> DSSubview)?
}

public protocol DSInitialViewDelegate: class {
    func selectedValue(index: Int, value: Any?, view: DSInitialView?)
}

public final class DSInitialView: UIView {
    
    public struct ViewModel {
        var dataModel: DSDataModel = DSDataModel()
        fileprivate var selectedIndex: Int = 0
        
        mutating public func assign(model: DSDataModel) {
            self.dataModel = model
            self.selectedIndex = model.initialIndex
        }
    }
    
    var inputSubview: DSSubview?
    var introView: DSIntroView?
    public var viewModel = ViewModel()
    public var delegate: DSInitialViewDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setGestures()
    }
    
    public static func createInstance(model: DSDataModel, delegate: DSInitialViewDelegate?) -> DSInitialView {
        let bundle = Bundle.csBundle
        let initialView = bundle.loadNibNamed("DSInitialView", owner: nil, options: nil)![0] as! DSInitialView
        initialView.viewModel.assign(model: model)
        initialView.assignAndAddSubview()
        initialView.delegate = delegate
        initialView.assign()
        return initialView
    }
    
    func assignAndAddSubview() {
        if self.inputSubview == nil {
            let generatedSubview = self.giveSubview()
            self.inputSubview = generatedSubview
            guard let subview = self.inputSubview as? UIView else {
                fatalError("Input Subview is not of type UIView")
            }
            
            subview.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(subview)
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": subview])
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": subview])
            
            self.addConstraints(horizontalConstraints)
            self.addConstraints(verticalConstraints)
        }
    }
    
    public func assign() {
        //set initial text
        if let initialData = viewModel.dataModel.initialData {
            self.initialUISettings(initialData)
        } else {
            if viewModel.dataModel.initialIndex < viewModel.dataModel.values.count {
                self.initialUISettings(viewModel.dataModel.values[viewModel.dataModel.initialIndex])
            }
        }
    }
    
    private func initialUISettings(_ data: Any?) {
        switch viewModel.dataModel.cellSubviewType {
        case .customCell:
            initialSetupCustomView()
        case .defaultCell:
            initialSetupDefaultView()
        }
        self.inputSubview?.assignData(data)
    }
    
    private func initialSetupDefaultView() {
        let defaultViewSetupData: DSDataModel.DSUIConfigs = viewModel.dataModel.uiConfigs
        self.inputSubview?.initialSetup(defaultViewSetupData, viewType: .initialView)
    }
    
    private func initialSetupCustomView() {
        self.inputSubview?.initialSetup(nil, viewType: .initialView)
    }
    
    private func setGestures() {
        let tapGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(handlePress(gesture:)))
        tapGesture.minimumPressDuration = 0.5
        self.addGestureRecognizer(tapGesture)
    }
    /*var touches: Set<UITouch>?
    var event: UIEvent?
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches = touches
        self.event = event
        super.touchesBegan(touches, with: event)
    }*/
    
    private func giveSubview() -> DSSubview {
        if viewModel.dataModel.cellSubviewType == .defaultCell {
            let defaultSubview = DSDefaultCellSubview.createInstance(delegate: self, optionButtonShown: viewModel.dataModel.uiConfigs.showOptionsButton)
            defaultSubview.setup(optionsButtonColor: viewModel.dataModel.uiConfigs.optionsBtnColor)
            return defaultSubview
        } else {
            guard let creator = viewModel.dataModel.customSubviewCreator else {
                fatalError("cellSubviewType is given as customCell but  customSubviewCreator is nil")
            }
            return creator()
        }
    }
}

extension DSInitialView {
    public func addAndShowIntroView() {
        if introView == nil {
            self.introView = DSIntroView.createInstance(uiModel: self.viewModel.dataModel.uiConfigs.introViewUIModel)
            introView!.translatesAutoresizingMaskIntoConstraints=false
            self.addSubview(introView!)
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": introView!])
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": introView!])
            self.addConstraints(horizontalConstraints)
            self.addConstraints(verticalConstraints)
            
            introView!.startCycle()
        }
    }
    
    public func removeIntroView() {
        self.introViewRemove()
    }
    
    private func introViewRemove() {
        self.introView?.removeFromSuperview()
    }
}

extension DSInitialView {
    @objc private func handlePress(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            showSelector(manuallyStartDismissTimer: false)
        }
    }
}

extension DSInitialView: DSDefaultCellSubviewDelegate {
    public func showFinalViewAction() {
        self.showSelector(manuallyStartDismissTimer: true)
    }
}

extension DSInitialView {
    private func showSelector(manuallyStartDismissTimer: Bool) {
        //remove any intro view
        self.introViewRemove()
        
        guard let inputSubview = self.inputSubview else {
            return
        }
        var params = DSFinalView.ViewModel.init()
        let initialViewFrameWrtContainer = self.getFrameInWindow()
        let initialViewFrameWrtSuperview = self.getFrameInSuperview()
        let selectedIndex = self.viewModel.selectedIndex
        params.assign(model: viewModel.dataModel, selectedIndex: selectedIndex, initialViewFrameWrtContainer: initialViewFrameWrtContainer, initialViewFrameWrtSuperview: initialViewFrameWrtSuperview)
        let view = DSFinalView.initializeView(params, delegate: self)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                for viewToAnimate in inputSubview.giveViewsToAnimate() {
                    viewToAnimate.transform = CGAffineTransform.identity
                    viewToAnimate.setAnchorPoint(anchorPoint: CGPoint.init(x: 0.5, y: 0.5))
                    viewToAnimate.layer.removeAllAnimations()
                }
                
                //if manual triggering of dismiss throttle is required
                //this is required in case the Final vie wis presented from a button (via DSDefaultCellSubviewDelegate) and not from long press
                if manuallyStartDismissTimer == true {
                    view.manuallyStartDismissTimer()
                }
            })
            self.addFinalViewShowAnimation(view)
            
            //If user had given a superview for final view, add CAFinalView as child for that superview
            self.addFinalViewShowAnimation(view)
            if let finalViewSuperview = self.viewModel.dataModel.finalViewSuperview {
                finalViewSuperview.addSubview(view)
            } else {
                self.superview?.addSubview(view)
            }
            CATransaction.commit()
        })
        
        let scaleFactors = self.getScaleFactors()
        let viewsToAnimate = inputSubview.giveViewsToAnimate()
        let horizontalTranslations = inputSubview.giveHorizontalTransformValues()
        for viewIndex in 0..<viewsToAnimate.count {
            let viewToAnimate = viewsToAnimate[viewIndex]
            let scaleFactor = scaleFactors[viewIndex]
            let xTranslate = horizontalTranslations[viewIndex]
            self.addTransformAnimation(viewToAnimate, scaleFactor: scaleFactor, xTranslate: xTranslate)
        }

        CATransaction.commit()
    }
    
    private func addTransformAnimation(_ view: UIView, scaleFactor: (CGFloat, CGFloat), xTranslate: CGFloat) {
        view.setAnchorPoint(anchorPoint: CGPoint.init(x: 0.0, y: 0.5))
        view.transform = CGAffineTransform.init(translationX: xTranslate, y: 0.0).scaledBy(x: scaleFactor.0, y: scaleFactor.1)
        print(view.frame)
        print(xTranslate)
        
        print(view.transform.tx) 
        let animationX = CABasicAnimation()
        animationX.keyPath = "transform.scale.x"
        animationX.fromValue = 1.0
        animationX.toValue = scaleFactor.0
        
        let animationY = CABasicAnimation()
        animationY.keyPath = "transform.scale.y"
        animationY.fromValue = 1.0
        animationY.toValue = scaleFactor.1
        
        let animationTranslateX = CABasicAnimation()
        animationTranslateX.keyPath = "transform.translation.x"
        animationTranslateX.fromValue = 0.0
        animationTranslateX.toValue = xTranslate

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.3
        animationGroup.isRemovedOnCompletion=false
        animationGroup.animations = [animationX, animationY, animationTranslateX]
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        
        view.layer.add(animationGroup, forKey: nil)
    }
    
    private func addFinalViewShowAnimation(_ view: UIView) {
        let animation = CABasicAnimation()
        animation.keyPath = "opacity"
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.1
        animation.isRemovedOnCompletion=true
        
        view.layer.add(animation, forKey: nil)
    }
    
    private func getFrameInSuperview() -> CGRect {
        if let superViewPresent = viewModel.dataModel.finalViewSuperview, let superView = self.superview {
            return superView.convert(self.frame, to: superViewPresent)
        } else {
            return self.frame
        }
    }
    
    private func getFrameInWindow() -> CGRect {
        guard let rootWindow = UIApplication.shared.delegate?.window! else {
            return CGRect.zero
        }
        
        if let frame = self.superview?.convert(self.frame, to: rootWindow) {
            return frame
        }
        return CGRect.zero
    }
    
    private func getScaleFactors() -> [(CGFloat, CGFloat)] {
        var scaleFactors: [(CGFloat, CGFloat)] = []
        guard let inputSubview = self.inputSubview else {
            return [(1.0, 1.0)]
        }

        let newSizes = inputSubview.getFinalViewSizes(viewModel.dataModel.uiConfigs.finalFont)
        let oldSizes = inputSubview.getInitialViewSizes(viewModel.dataModel.uiConfigs.initialFont)
        for itemCount in 0..<newSizes.count {
            let newSize = newSizes[itemCount]
            let oldSize = oldSizes[itemCount]
            let scaleX = newSize.width/oldSize.width
            let scaleY = newSize.height/oldSize.height
            scaleFactors.append((scaleX, scaleY))
        }
        
        return scaleFactors
    }
}

extension DSInitialView: CustomSelectorDelegate {
    func didSelectIndex(_ index: Int) {
        viewModel.selectedIndex = index
        self.inputSubview?.assignData(viewModel.dataModel.values[viewModel.selectedIndex])
        delegate?.selectedValue(index: viewModel.selectedIndex, value: viewModel.dataModel.values[viewModel.selectedIndex], view: self)
    }
    
    func willRemoveFinalView(_ heightDiff: CGFloat) {
        guard let inputSubview = self.inputSubview else {
            return
        }
        self.layoutIfNeeded()
        let finalFontSizes = inputSubview.getFinalViewSizes(viewModel.dataModel.uiConfigs.finalFont)
        let initialFontSizes = inputSubview.getInitialViewSizes(viewModel.dataModel.uiConfigs.initialFont)
        let scaleFactors = self.getScaleFactors()
        let horizontalTranslations = inputSubview.giveHorizontalTransformValues()
        let viewsToAnimate = inputSubview.giveViewsToAnimate()
        for viewIndex in 0..<viewsToAnimate.count {
            let viewToAnimate = viewsToAnimate[viewIndex]
            let finalSize = finalFontSizes[viewIndex]
            let initialSize = initialFontSizes[viewIndex]
            let scaleFactor = scaleFactors[viewIndex]
            let xTranslate = horizontalTranslations[viewIndex]
            
            var minorDiff = finalSize.height - initialSize.height
            if heightDiff == 0.0 {
                minorDiff = 0.0
            } else if heightDiff < 0.0 {
                minorDiff = -1.0*minorDiff
            }
            
            viewToAnimate.layer.removeAllAnimations()
            viewToAnimate.setAnchorPoint(anchorPoint: CGPoint.init(x: 0.0, y: 0.5))
            viewToAnimate.transform = CGAffineTransform.init(scaleX: scaleFactor.0, y: scaleFactor.1).translatedBy(x: 0, y: heightDiff - minorDiff).translatedBy(x: xTranslate, y: 0.0)
        }
    }
    
    func removedFinalView() {
        guard let inputSubview = self.inputSubview else {
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            for viewToAnimate in inputSubview.giveViewsToAnimate() {
                viewToAnimate.setAnchorPoint(anchorPoint: CGPoint.init(x: 0.5, y: 0.5))
                viewToAnimate.layer.removeAllAnimations()
            }
        })
        
        let scaleFactors = self.getScaleFactors()
        let viewsToAnimate = inputSubview.giveViewsToAnimate()
        let horizontalTranslations = inputSubview.giveHorizontalTransformValues()
        for viewIndex in 0..<viewsToAnimate.count {
            let viewToAnimate = viewsToAnimate[viewIndex]
            let scaleFactor = scaleFactors[viewIndex]
            let xTranslate = horizontalTranslations[viewIndex]
            print(viewToAnimate.transform)
            self.animateLabelToInitialPos(viewToAnimate, scaleFactor: scaleFactor, xTranslate: xTranslate)
            viewToAnimate.transform = CGAffineTransform.identity
        }
        CATransaction.commit()
    }
    
    private func animateLabelToInitialPos(_ view: UIView, scaleFactor: (CGFloat, CGFloat), xTranslate: CGFloat)  {
        
        let animationXScale = CABasicAnimation()
        animationXScale.keyPath = "transform.scale.x"
        animationXScale.fromValue = scaleFactor.0
        animationXScale.toValue = 1.0
        
        let animationYScale = CABasicAnimation()
        animationYScale.keyPath = "transform.scale.y"
        animationYScale.fromValue = scaleFactor.1
        animationYScale.toValue = 1.0
        
        let animationYHeight = CABasicAnimation()
        animationYHeight.keyPath = "transform.translation.y"
        animationYHeight.fromValue = view.transform.ty
        animationYHeight.toValue = 0.0
        
        let animationTranslateX = CABasicAnimation()
        animationTranslateX.keyPath = "transform.translation.x"
        animationTranslateX.fromValue = xTranslate
        animationTranslateX.toValue = 0.0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.3
        animationGroup.isRemovedOnCompletion=false
        animationGroup.animations = [animationXScale, animationYScale, animationYHeight, animationTranslateX]
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        
        view.layer.add(animationGroup, forKey: nil)
    }
}

extension UIView {
    func setAnchorPoint(anchorPoint: CGPoint) {
        let newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x,
                               y: self.bounds.size.height * anchorPoint.y)
        
        
        let oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x,
                               y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        var position = self.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        self.layer.position = position
        self.layer.anchorPoint = anchorPoint
    }
}

extension Bundle {
    static var csBundle: Bundle {
        return Bundle.init(for: DSInitialView.self)
    }
    
    static var csImgBundle: Bundle {
        return Bundle.init(url: Bundle.init(for: DSInitialView.self).url(forResource: "DirectSelect", withExtension: "bundle")!)!
    }
}
