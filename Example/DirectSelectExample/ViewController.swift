//
//  ViewController.swift
//  CustomSelector
//
//  Created by Swasidhant on 12/25/2019.
//  Copyright (c) 2019 Swasidhant. All rights reserved.
//

import UIKit
import DirectSelect

class ViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    
    var arrQuestions: [String] = ["Choose a hero to fight against Ares", "Choose a hero to fight against Darkseid", "Choose a hero to fight against Joker", "Choose a hero to fight against Zoom", "Choose a hero to fight against Sinistro", "Choose a hero to fight against White Martians", "Choose a hero to fight against Black Adam"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initialseInitialView()
//        initialseInitialCustomView()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initialseInitialView() {
        let initialView = DSInitialView.createInstance(model: giveDataModel1(), delegate: nil)
        
        initialView.frame = CGRect.init(x: 0, y: 200, width: view.frame.width, height: 49.5)
        self.view.addSubview(initialView)
    }
    
    func initialseInitialCustomView() {
        let initialView = DSInitialView.createInstance(model: giveDataModelForCustomView(), delegate: nil)
        
        initialView.frame = CGRect.init(x: 0, y: 100, width: view.frame.width, height: 55.0)
        self.view.addSubview(initialView)
    }

    private func giveDataModel1() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = ["Barry Allen", "Bruce Wayne", "Clark Kent", "Diana Prince", "Arthur Curry", "John Jonnes", "Shaira Hall", "John Stewart", "Billy Batson", "John Constantine"]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 2
        dataModel.finalViewSuperview = self.view
        dataModel.initialData = "Clark Kent"
        dataModel.uiConfigs.finalBGColor = UIColor.blue
        dataModel.uiConfigs.finalTitleColor = UIColor.white
        dataModel.uiConfigs.finalTitleFont = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        dataModel.titleString = "Choose JL Member"
        return dataModel
    }
    
    private func giveDataModel2() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = ["Barry Allen", "Bruce Wayne", "Clark Kent", "Diana Prince", "Arthur Curry", "John Jonnes", "Shaira Hall", "John Stewart", "Billy Batson", "John Constantine"]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 2
        dataModel.uiConfigs.initialFont = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        dataModel.uiConfigs.finalFont = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        dataModel.finalViewSuperview = self.view
        dataModel.initialData = "Clark Kent"
        return dataModel
    }
    
    private func giveDataModel3() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = ["Barry Allen", "Bruce Wayne", "Clark Kent", "Diana Prince", "Arthur Curry", "John Jonnes", "Shaira Hall", "John Stewart", "Billy Batson", "John Constantine"]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 2
        dataModel.uiConfigs.initialFontColor = UIColor.red
        dataModel.uiConfigs.finalFontColor = UIColor.red
        dataModel.finalViewSuperview = self.view
        dataModel.initialData = "Clark Kent"
        return dataModel
    }
    
    private func giveDataModel4() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = [("Barry Allen", "confirmed"), ("Bruce Wayne", "confirmed"), ("Clark Kent", "confirmed"), ("Diana Prince", "confirmed"), ("Arthur Curry", "confirmed"), ("John Jonnes", "confirmed"), ("Shaira Hall", "confirmed"), ("John Stewart", "confirmed"), ("Billy Batson", "confirmed"), ("John Constantine", "confirmed")]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 2
        dataModel.finalViewSuperview = self.view
        dataModel.initialData = ("Clark Kent", "confirmed")
        dataModel.cellSubviewType = .customCell
        dataModel.customSubviewCreator = {CustomSubview.createInstance()}
        return dataModel
    }
    
    private func giveDataModel5() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = ["Barry Allen", "Bruce Wayne", "Clark Kent", "Diana Prince", "Arthur Curry", "John Jonnes", "Shaira Hall", "John Stewart", "Billy Batson", "John Constantine"]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 2
        dataModel.finalViewSuperview = self.view
        dataModel.initialData = "Clark Kent"
        return dataModel
    }
    
    private func giveDataModel6() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = ["Barry Allen", "Bruce Wayne", "Clark Kent", "Diana Prince", "Arthur Curry", "John Jonnes", "Shaira Hall", "John Stewart", "Billy Batson", "John Constantine"]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 2
        dataModel.finalViewSuperview = self.view
        dataModel.initialData = "Clark Kent"
        return dataModel
    }
    
    private func giveDataModel7() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = ["Barry Allen", "Bruce Wayne", "Clark Kent", "Diana Prince", "Arthur Curry", "John Jonnes", "Shaira Hall", "John Stewart", "Billy Batson", "John Constantine"]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 2
        dataModel.finalViewSuperview = self.view
        dataModel.initialData = "Clark Kent"
        return dataModel
    }
    
    private func giveDataModelForCustomView() -> DSDataModel {
        let dataModel = DSDataModel()
        dataModel.values = [("Barry Allen", "confirmed"), ("Bruce Wayne", "confirmed"), ("Clark Kent", "confirmed"), ("Diana Prince", "confirmed"), ("Arthur Curry", "confirmed"), ("John Jonnes", "confirmed"), ("Shaira Hall", "confirmed"), ("John Stewart", "confirmed"), ("Billy Batson", "confirmed"), ("John Constantine", "confirmed")]
        dataModel.longPressDuration = 1.5
        dataModel.initialIndex = 2
        dataModel.initialData = ("Clark Kent", "confirmed")
        dataModel.cellSubviewType = .customCell
        dataModel.customSubviewCreator = {CustomSubview.createInstance()}
        return dataModel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrQuestions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
            cell.questionLabel.text = arrQuestions[indexPath.section]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTableViewCell") as! OptionsTableViewCell
            cell.dataModel = giveProperDataModel(section: indexPath.section)
            cell.initialseInitialView()
            return cell
        }
    }
    
    private func giveProperDataModel(section: Int) -> DSDataModel? {
        switch section {
        case 0:
            return giveDataModel1()
        case 1:
            return giveDataModel2()
        case 2:
            return giveDataModel3()
        case 3:
            return giveDataModel4()
        case 4:
            return giveDataModel5()
        case 5:
            return giveDataModel6()
        case 6:
            return giveDataModel7()

        default:
            return nil
        }
    }
}
