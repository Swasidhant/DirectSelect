//
//  CSFinalView.swift
//  CustomSelector
//
//  Created by swasidhant chowdhury on 25/12/19.
//

import UIKit

protocol CustomSelectorDelegate: class {
    func didSelectIndex(_ index: Int)
    func removedFinalView()
    func willRemoveFinalView(_ heightDiff: CGFloat)
}

public enum CSCellSubviewType {
    case defaultCell
    case customCell
}

public enum DSInitialSetupViewType {
    case initialView
    case finalView
}

final class DSFinalView: UIView {
    struct ViewModel {
        var dataModel: DSDataModel = DSDataModel()
        var selectedIndex: Int = 0
        var initialViewFrameWrtSuperview: CGRect = CGRect.zero
        fileprivate var initialViewFrameWrtContainer:CGRect = CGRect.zero
 
        private var throttler = CSThrottler()
        private var didMakeInitialScrollSettings: Bool = false
        
        fileprivate var shouldImpactScrollAction: Bool = false
        
        mutating func assign(model: DSDataModel, selectedIndex: Int, initialViewFrameWrtContainer: CGRect, initialViewFrameWrtSuperview: CGRect) {
            self.dataModel = model
            self.selectedIndex = selectedIndex
            self.initialViewFrameWrtContainer = initialViewFrameWrtContainer
            self.initialViewFrameWrtSuperview = initialViewFrameWrtSuperview
        }
        
        fileprivate func elementsCount() -> Int {
            return dataModel.values.count
        }
        
        fileprivate func dataAtIndex(_ index: Int) -> Any {
            return dataModel.values[index]
        }
        
        fileprivate func upperContentInset() -> CGFloat {
            return initialViewFrameWrtContainer.origin.y - 67.0
        }
        
        fileprivate func bottomContentInset() -> CGFloat {
            let totalFrame = DSFinalView.giveFrame()
            return totalFrame.height - (initialViewFrameWrtContainer.origin.y + initialViewFrameWrtContainer.height)
        }
        
        mutating fileprivate func madeInitialScrollSetting() {
            self.didMakeInitialScrollSettings = true
        }
        
        fileprivate func triggerDismissThrottle(block: @escaping () -> Void) {
            if self.didMakeInitialScrollSettings == true {
                self.throttler.handleThrottle(block: block, delay: self.dataModel.longPressDuration)
            }
        }
        
        //divider views
        fileprivate func upperDividerFrame(containerWidth: CGFloat) -> CGRect {
            let origin = CGPoint.init(x: 0.0, y: initialViewFrameWrtContainer.origin.y)
            return CGRect.init(origin: origin, size: CGSize.init(width: containerWidth, height: 1.0))
        }
        
        fileprivate func lowerDividerFrame(containerWidth: CGFloat) -> CGRect {
            let origin = CGPoint.init(x: 0.0, y: initialViewFrameWrtContainer.maxY - 1.0)
            return CGRect.init(origin: origin, size: CGSize.init(width: containerWidth, height: 1.0))
        }
        
        //cell calculations
        fileprivate func giveIntersectionHeight(cellFrame: CGRect) -> CGFloat? {
            let intersectionRect = initialViewFrameWrtContainer.intersection(cellFrame)
            if intersectionRect.isNull == true {
                return nil
            } else {
                return intersectionRect.height
            }
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableviewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableviewTrailingConstraint: NSLayoutConstraint!

    private var viewModel: ViewModel = ViewModel()
    private var delegate: CustomSelectorDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
    }
    
    func assignedDataModel() {
//        initialSettings()
        initialUISettings()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.createAndAddUpperDividerView()
        self.createAndAddLowerDividerView()
        
        setTableViewContentOffsetOnLayout()
        viewModel.madeInitialScrollSetting()
    }
    
    func manuallyStartDismissTimer() {
        viewModel.triggerDismissThrottle(block: { [weak self] in
            self?.setNewValueBeforeDismiss()
            self?.removeFinalView()
        })
    }
    
    static func initializeView( _ params: ViewModel, delegate: CustomSelectorDelegate) -> DSFinalView {
        let bundle = Bundle.csBundle
        let view = bundle.loadNibNamed("DSFinalView", owner: nil, options: nil)![0] as! DSFinalView
        view.viewModel.assign(model: params.dataModel, selectedIndex: params.selectedIndex, initialViewFrameWrtContainer: params.initialViewFrameWrtContainer, initialViewFrameWrtSuperview: params.initialViewFrameWrtSuperview)
        view.assignedDataModel()
        let frame = giveFrame()
        view.frame = frame
        view.delegate = delegate
        view.uiAfterAssign()
        return view
    }
    
    private func initialUISettings() {
        titleLabel.textColor = viewModel.dataModel.uiConfigs.finalTitleColor
        setTableViewInitialUI()
        self.backgroundColor = viewModel.dataModel.uiConfigs.finalBGColor
    }
    
    private func uiAfterAssign() {
        setTableViewUIAfterAssign()
    }
    
    private func setTableViewInitialUI() {
        tableView.tableFooterView = UIView()
        tableView.separatorColor = viewModel.dataModel.uiConfigs.finalBGSeparatorColor
        tableView.backgroundColor = viewModel.dataModel.uiConfigs.finalBGColor
        titleLabel.font = viewModel.dataModel.uiConfigs.finalTitleFont
        titleLabel.textColor = viewModel.dataModel.uiConfigs.finalTitleColor
        titleLabel.text = viewModel.dataModel.titleString
        self.tableviewLeadingConstraint.constant = viewModel.initialViewFrameWrtSuperview.origin.x
        let trailingX = self.frame.width - (viewModel.initialViewFrameWrtSuperview.width + viewModel.initialViewFrameWrtSuperview.origin.x)
        self.tableviewTrailingConstraint.constant = trailingX//viewModel.initialViewFrameWrtSuperview.origin.x
    }
    
    private func setTableViewUIAfterAssign() {
        let upperInset = viewModel.upperContentInset()
        let lowerInset = viewModel.bottomContentInset()
        tableView.contentInset = UIEdgeInsets.init(top: upperInset, left: 0.0, bottom: lowerInset, right: 0.0)
    }
    
    private func setTableViewContentOffsetOnLayout() {
        //scroll
        let selectedIndexPath = IndexPath.init(row: viewModel.selectedIndex, section: 0)
        self.layoutIfNeeded()
        self.tableView.layoutIfNeeded()
        for subview in tableView.subviews {
            subview.layoutIfNeeded()
        }
        setTableViewContentOffsetFor(selectedIndexPath, animated: false)
    }
    
    private func setTableViewContentOffsetFor(_ indexPath: IndexPath, animated: Bool) {
        guard let rootWindow = UIApplication.shared.delegate?.window! else {
            return
        }
        let frameOfSelectedRow = tableView.rectForRow(at: indexPath)
        print(frameOfSelectedRow)
        let tableFrameWrtWindow = self.convert(tableView.frame, to: rootWindow)
        let positionDiff = tableFrameWrtWindow.origin.y + frameOfSelectedRow.origin.y - viewModel.initialViewFrameWrtContainer.origin.y
        let offset = CGPoint.init(x: 0, y: positionDiff)
        tableView.setContentOffset(offset, animated: animated)
    }
    
    private func setTableViewContentOffsetFor(_ cellFrame: CGRect, animated: Bool) {
        guard let rootWindow = UIApplication.shared.delegate?.window! else {
            return
        }
        let tableFrameWrtWindow = self.convert(tableView.frame, to: rootWindow)
        let positionDiff = tableFrameWrtWindow.origin.y + cellFrame.origin.y - viewModel.initialViewFrameWrtContainer.origin.y
        let offset = CGPoint.init(x: 0, y: positionDiff)
        tableView.setContentOffset(offset, animated: animated)
    }
    
    private static func giveFrame() -> CGRect {
        guard let rootWindow = UIApplication.shared.delegate?.window! else {
            return CGRect.zero
        }
        return rootWindow.frame
    }
    
    private func registerCell() {
        let bundle = Bundle.csBundle
        let nib = UINib.init(nibName: "DSFinalViewCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: DSFinalViewCell.description())
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        removeFinalView()
    }
    
    private func removeFinalView() {
        let maxAreaCell = self.cellWithMaxIntersectingSelectableArea()
        if let rootWindow = UIApplication.shared.delegate?.window!, let maxAreaCell = maxAreaCell {
            let cellFrameWrtWindow = self.tableView.convert(maxAreaCell.frame, to: rootWindow)
            let heightDiff = cellFrameWrtWindow.origin.y - viewModel.initialViewFrameWrtContainer.origin.y
            self.delegate?.willRemoveFinalView(heightDiff)
            removeViewWithAnimation(self)
        }
    }
    
    private func removeViewWithAnimation(_ view: UIView) {
        let animation = CABasicAnimation()
        animation.keyPath = "opacity"
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.1
        animation.isRemovedOnCompletion = false
        CATransaction.setCompletionBlock({
        view.removeFromSuperview()
        self.delegate?.removedFinalView()
            view.layer.removeAllAnimations()
        })
//        view.layer.add(animation, forKey: nil)
        view.alpha = 0.0
        CATransaction.commit()
    }
}

extension DSFinalView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.elementsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DSFinalViewCell.description()) as! DSFinalViewCell
        
        if cell.isSubviewNeeded() {
            switch viewModel.dataModel.cellSubviewType {
            case .defaultCell:
                let defaultViewSetupData: DSDataModel.DSUIConfigs = viewModel.dataModel.uiConfigs
                cell.assignAndAddSubview(giveSubview(), initialSetupData: defaultViewSetupData)
            case .customCell:
                cell.assignAndAddSubview(giveSubview(), initialSetupData: nil)
            }
        }
        
        cell.assign(viewModel.dataAtIndex(indexPath.row))
        return cell
    }
    
    private func giveSubview() -> DSSubview {
        if viewModel.dataModel.cellSubviewType == .defaultCell {
            //no need of showing final view from here
            return DSDefaultCellSubview.createInstance(delegate: nil, optionButtonShown: false)
        } else {
            //TODO: change later
            guard let creator = viewModel.dataModel.customSubviewCreator else {
                fatalError("cellSubviewType is given as customCell but  customSubviewCreator is nil")
            }
            return creator()
        }
    }
}

extension DSFinalView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectIndex(indexPath.row)
        removeFinalView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.initialViewFrameWrtContainer.height
    }
}

extension DSFinalView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.triggerDismissThrottle(block: { [weak self] in
            self?.setNewValueBeforeDismiss()
            self?.removeFinalView()
        })
        self.updateColor()
    }
    
    private func updateColor() {
        if let maxIntersectionCell = cellWithMaxIntersectingSelectableArea() {
            maxIntersectionCell.movedInsideSelectionArea()
        }
    }
    
    private func cellWithMaxIntersectingSelectableArea() -> DSFinalViewCell? {
        guard let rootWindow = UIApplication.shared.delegate?.window! else {
            return nil
        }
        var maxIntersectionHeight: CGFloat = 0.0
        var maxIntersectionCell: DSFinalViewCell?
        for cell in self.tableView.visibleCells where cell is DSFinalViewCell {
            let cellFrameWrtWindow = tableView.convert(cell.frame, to: rootWindow)
            if let intersectionHeight = viewModel.giveIntersectionHeight(cellFrame: cellFrameWrtWindow) {
                if intersectionHeight > maxIntersectionHeight {
                    maxIntersectionHeight = intersectionHeight
                    maxIntersectionCell = cell as? DSFinalViewCell
                }
            }
            (cell as! DSFinalViewCell).movedOutsideSelectionArea()
        }
        
        return maxIntersectionCell
    }
}

extension DSFinalView {
    private func createDividerView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        return view
    }
    
    private func createAndAddUpperDividerView() {
        let view = self.createDividerView()
        view.frame = viewModel.upperDividerFrame(containerWidth: self.frame.width)
        self.addSubview(view)
    }
    
    private func createAndAddLowerDividerView() {
        let view = self.createDividerView()
        view.frame = viewModel.lowerDividerFrame(containerWidth: self.frame.width)
        self.addSubview(view)
    }
}

extension DSFinalView {
    private func setNewValueBeforeDismiss() {
        var properIndexPath: IndexPath?
        var maxY: CGFloat = 0.0
        for cellIndex in 0..<tableView.visibleCells.count {
            let cell = tableView.visibleCells[cellIndex]
            guard let rootWindow = UIApplication.shared.delegate?.window! else {
                return
            }
            
            let cellFrameWrtWindow = tableView.convert(cell.frame, to: rootWindow)
            if viewModel.initialViewFrameWrtContainer.intersects(cellFrameWrtWindow) {
                var yInside: CGFloat = 0.0
                if cellFrameWrtWindow.minY < viewModel.initialViewFrameWrtContainer.minY {
                    yInside = cellFrameWrtWindow.maxY - viewModel.initialViewFrameWrtContainer.minY
                } else {
                    yInside = viewModel.initialViewFrameWrtContainer.maxY - cellFrameWrtWindow.minY
                }
                if yInside > maxY {
                    maxY = yInside
                    properIndexPath = tableView.indexPath(for: cell)
                }
            }
        }
        if let indexPath = properIndexPath {
            delegate?.didSelectIndex(indexPath.row)
        }
    }
}

class CSThrottler {
    var dispatchItem: DispatchWorkItem?
    
    func handleThrottle(block: @escaping () -> Void, delay: TimeInterval) {
        dispatchItem?.cancel()
        dispatchItem = DispatchWorkItem.init(block: block)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: dispatchItem!)
    }
}
