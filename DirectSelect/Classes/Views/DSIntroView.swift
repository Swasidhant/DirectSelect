//
//  DSIntroView.swift
//  DirectSelect
//
//  Created by swasidhant chowdhury on 27/02/20.
//

import UIKit

public class DSIntroUIModel {
    //text to coach the user on how to use DirectSelect
    public var introLabelText: String = "Long press to open options, then tap and drag to select."
    //color of the text which coaches the user on how to use DirectSelect
    public var introLabelColor: UIColor = UIColor.init(red: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1.0)
    //backgroundColor of the circle view used in the intro screen
    public var circleViewColor: UIColor = UIColor.blue.withAlphaComponent(0.4)
    //backgroundColor of the halo effect used in the intro screen
    public var haloColor: UIColor = UIColor.init(red: 140.0/255.0, green: 217.0/255.0, blue: 190.0/255.0, alpha: 1.0).withAlphaComponent(0.6)
}

class DSIntroView: UIView {
    @IBOutlet private weak var circleContainerView: UIView!
    @IBOutlet private weak var introLabel: UILabel!
    @IBOutlet private weak var circleView: UIView!
    
    private var timer: Timer?
    private var uiModel: DSIntroUIModel = DSIntroUIModel()
    
    static func createInstance(uiModel: DSIntroUIModel?) -> DSIntroView {
        let view = Bundle.csBundle.loadNibNamed("DSIntroView", owner: nil, options: nil)![0] as! DSIntroView
        if let model = uiModel {
            view.uiModel = model
        }
        view.initialUISettings()
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        uiSettingsAfterLayout()
    }
    
    private func initialUISettings() {
        self.circleView.backgroundColor = self.uiModel.circleViewColor
        introLabel.textColor = self.uiModel.introLabelColor
        introLabel.text = self.uiModel.introLabelText
    }
    
    private func uiSettingsAfterLayout() {
        circleView.layer.cornerRadius = circleView.bounds.width/2
    }
    
    private func setInitialTransform() {
        let originY = self.circleView.frame.minY
        let yToMove = self.bounds.height - originY
        self.circleView.transform = CGAffineTransform.init(translationX: 0, y: yToMove)
    }
    
    private func setIdentityTransform() {
        self.circleView.transform = CGAffineTransform.identity
    }
    
    private func setFinalTransform() {
        let originY = self.circleView.frame.minY
        let yToMove = self.circleView.frame.height + originY
        self.circleView.transform = CGAffineTransform.init(translationX: 0, y: -yToMove)
    }
    
    private func animateHalo() {
        let firstHaloLayer = self.createHaloLayer()
        let firstAnimation = CABasicAnimation()
        firstAnimation.keyPath = "transform.scale.xy"
        firstAnimation.fromValue = 1.0
        firstAnimation.toValue = 13.0
        firstAnimation.duration = 1.0
        firstAnimation.isRemovedOnCompletion=true
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            let completionAnimation = CABasicAnimation()
            completionAnimation.keyPath = "opacity"
            completionAnimation.fromValue = 1.0
            completionAnimation.toValue = 0.0
            completionAnimation.duration = 0.7
            completionAnimation.isRemovedOnCompletion = true
            
            firstHaloLayer.add(completionAnimation, forKey: nil)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                firstHaloLayer.removeFromSuperlayer()
            })
            
            CATransaction.commit()
        })
        firstHaloLayer.add(firstAnimation, forKey: nil)
        CATransaction.commit()
        
        self.layer.insertSublayer(firstHaloLayer, below: circleView.layer)
    }
    
    func createHaloLayer() -> CALayer {
        let haloLayer = CALayer.init()
        let widthHeight: CGFloat = 5.0
        let frame = CGRect.init(x: circleView.frame.midX - widthHeight/2.0, y: circleView.frame.midY - widthHeight/2.0, width: widthHeight, height: widthHeight)
        haloLayer.frame = frame
        haloLayer.opacity = 0.4
        haloLayer.backgroundColor = self.uiModel.haloColor.cgColor
        haloLayer.cornerRadius = widthHeight/2
        return haloLayer
    }
}

extension DSIntroView {
    func startCycle() {
        self.animateEffect()
        timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(animateEffect), userInfo: nil, repeats: true)
    }
    
    @objc private func animateEffect() {
        self.setInitialTransform()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.setIdentityTransform()
        }) { finished in
            self.animateHalo()
            UIView.animateKeyframes(withDuration: 0.3, delay: 2.0, options: .beginFromCurrentState, animations: {
                self.setFinalTransform()
            }, completion: { (innerFInished) in
                
            })
        }
    }
}
