//
//  FoodJournalViewController.swift
//  CustomSelector_Example
//
//  Created by swasidhant chowdhury on 03/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DirectSelect

class FoodJournalViewController: UIViewController {
    
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var dishContainer: UIView!
    @IBOutlet weak var mealContainer: UIView!
    @IBOutlet weak var quantityContainer: UIView!
    @IBOutlet weak var quantityIndexContainer: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var firstDSSeletorView: DSInitialView?
    private var secondDSSeletorView: DSInitialView?
    private var thirdDSSeletorView: DSInitialView?
    private var fourthDSSeletorView: DSInitialView?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISettings()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showIntroView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addInitialViews()
    }
    
    private func initialUISettings() {
        dishContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
        dishContainer.layer.shadowRadius = 5.0
        dishContainer.layer.shadowOpacity = 1.0
        dishContainer.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        dishContainer.layer.cornerRadius = 6.0
        
        categoryContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
        categoryContainer.layer.shadowRadius = 5.0
        categoryContainer.layer.shadowOpacity = 1.0
        categoryContainer.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        categoryContainer.layer.cornerRadius = 6.0

        mealContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
        mealContainer.layer.shadowRadius = 5.0
        mealContainer.layer.shadowOpacity = 1.0
        mealContainer.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        mealContainer.layer.cornerRadius = 6.0
        
        quantityContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
        quantityContainer.layer.shadowRadius = 5.0
        quantityContainer.layer.shadowOpacity = 1.0
        quantityContainer.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        
        quantityIndexContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
        quantityIndexContainer.layer.shadowRadius = 5.0
        quantityIndexContainer.layer.shadowOpacity = 1.0
        quantityIndexContainer.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
    }
    
    private func addInitialViews() {
        if firstDSSeletorView == nil {
            firstDSSeletorView = DSInitialView.createInstance(model: giveDataModel1(), delegate: self)
            firstDSSeletorView?.translatesAutoresizingMaskIntoConstraints = false
            mealContainer.addSubview(firstDSSeletorView!)
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.firstDSSeletorView!])
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.firstDSSeletorView!])
            mealContainer.addConstraints(horizontalConstraints)
            mealContainer.addConstraints(verticalConstraints)
        }
        
        if secondDSSeletorView == nil {
            secondDSSeletorView = DSInitialView.createInstance(model: giveDataModel2(), delegate: self)
            secondDSSeletorView?.translatesAutoresizingMaskIntoConstraints = false
            categoryContainer.addSubview(secondDSSeletorView!)
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.secondDSSeletorView!])
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.secondDSSeletorView!])
            categoryContainer.addConstraints(horizontalConstraints)
            categoryContainer.addConstraints(verticalConstraints)
        }
        
        if thirdDSSeletorView == nil {
            thirdDSSeletorView = DSInitialView.createInstance(model: giveDataModel3(), delegate: self)
            thirdDSSeletorView?.translatesAutoresizingMaskIntoConstraints = false
            
            dishContainer.addSubview(thirdDSSeletorView!)
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.thirdDSSeletorView!])
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.thirdDSSeletorView!])
            dishContainer.addConstraints(horizontalConstraints)
            dishContainer.addConstraints(verticalConstraints)
        }
        
        if fourthDSSeletorView == nil {
            fourthDSSeletorView = DSInitialView.createInstance(model: giveDataModel4(), delegate: self)
            fourthDSSeletorView?.translatesAutoresizingMaskIntoConstraints = false
            
            quantityContainer.addSubview(fourthDSSeletorView!)
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.fourthDSSeletorView!])
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": self.fourthDSSeletorView!])
            quantityContainer.addConstraints(horizontalConstraints)
            quantityContainer.addConstraints(verticalConstraints)
        }
    }
    
    private func showIntroView() {
        firstDSSeletorView?.addAndShowIntroView()
        Timer.scheduledTimer(timeInterval: 14.0, target: self, selector: #selector(removeIntro), userInfo: nil, repeats: false)
    }
    
    @objc private func removeIntro() {
        firstDSSeletorView?.removeIntroView()
    }
    
    private func giveDataModel1() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = ["Breakfast", "First snack", "Lunch", "Second snack", "Dinner", "Third snack"]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 0
        dataModel.finalViewSuperview = self.scrollView
        dataModel.initialData = "Breakfast"
        dataModel.uiConfigs.initialFont = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        dataModel.uiConfigs.finalFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        dataModel.uiConfigs.finalTitleNonSelectionStateFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        dataModel.uiConfigs.finalTitleFont = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        dataModel.titleString = "Choose Meal"
        return dataModel
    }
    
    private func giveDataModel2() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = ["Vegan", "Eggs", "Chicken", "Mutton", "Fish", "Pork", "Ham"]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 0
        dataModel.finalViewSuperview = self.scrollView
        dataModel.initialData = "Vegan"
        dataModel.uiConfigs.initialFont = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        dataModel.uiConfigs.finalFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        dataModel.uiConfigs.finalTitleNonSelectionStateFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        dataModel.uiConfigs.finalTitleFont = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        dataModel.uiConfigs.showOptionsButton = true
        dataModel.uiConfigs.optionsBtnColor = UIColor.init(red: 116.0/255.0, green: 136.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        dataModel.titleString = "Choose Category"
        return dataModel
    }
    
    private func giveDataModel3() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = ["Shallow Fried", "Baked", "Deep fried", "Roasted", "Raw", "Boiled"]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 1
        dataModel.finalViewSuperview = self.scrollView
        dataModel.initialData = "Baked"
        dataModel.uiConfigs.initialFont = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        dataModel.uiConfigs.finalFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        dataModel.uiConfigs.finalTitleNonSelectionStateFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        dataModel.uiConfigs.finalTitleFont = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        dataModel.titleString = "Choose Sub category"
        return dataModel
    }
    
    private func giveDataModel4() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = ["Large portion", "Medium portion", "Small portion", "King size portion"]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 1
        dataModel.finalViewSuperview = self.scrollView
        dataModel.initialData = "Large portion"
        dataModel.uiConfigs.initialFont = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        dataModel.uiConfigs.finalFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        dataModel.uiConfigs.finalTitleNonSelectionStateFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        dataModel.uiConfigs.finalTitleFont = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        dataModel.uiConfigs.showOptionsButton = true
        dataModel.uiConfigs.optionsBtnColor = UIColor.init(red: 116.0/255.0, green: 136.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        dataModel.titleString = "Choose Sub category"
        return dataModel
    }
}

extension FoodJournalViewController: DSInitialViewDelegate {
    func selectedValue(index: Int, value: Any?, view: DSInitialView?) {
        if view == self.firstDSSeletorView {
            //do nothing
        } else if view == self.secondDSSeletorView {
            updateCalories()
            updateProtein()
            updateCarbs()
            updateFat()
        } else if view == self.thirdDSSeletorView {
            updateCalories()
            updateProtein()
            updateCarbs()
            updateFat()
        } else {
            //do nothing
        }
    }
    
    private func updateCalories() {
        let arrCalories: [String] = ["226", "230", "721", "893", "444", "321"]
        
        let randomIndex = Int.random(in: 0...5)
        let value = arrCalories[randomIndex]
        calorieLabel.text = value
    }
    
    private func updateProtein() {
        let arrProtein: [String] = ["41 g", "53 g", "100 g", "23 g", "7 g", "80 g"]
        
        let randomIndex = Int.random(in: 0...5)
        let value = arrProtein[randomIndex]
        proteinLabel.text = value
    }

    private func updateCarbs() {
        let arrCarbs: [String] = ["0 g", "5 g", "30.1 g", "21 g", "9 g", "8.8 g"]
        
        let randomIndex = Int.random(in: 0...5)
        let value = arrCarbs[randomIndex]
        carbsLabel.text = value
    }

    private func updateFat() {
        let arrFat: [String] = ["4.5 g", "1.3 g", "8.5 g", "15.4 g", "20.1 g", "7.7 g"]
        
        let randomIndex = Int.random(in: 0...5)
        let value = arrFat[randomIndex]
        fatLabel.text = value
    }
}

extension FoodJournalViewController {
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.showJLScreen()
    }
    
    private func showJLScreen() {
        let jlViewController = self.storyboard?.instantiateViewController(withIdentifier: "JLScene") as! ViewController
        self.present(jlViewController, animated: true, completion: nil)
    }
}
