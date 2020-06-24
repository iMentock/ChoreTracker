//
//  SecondViewController.swift
//  Kai's Chore Checker
//
//  Created by Virgil Martinez on 6/24/20.
//  Copyright © 2020 Virgil Martinez. All rights reserved.
//

import UIKit
import CoreData


class SecondViewController: UIViewController {
    
    let dishValue = 1.0
    let dogPoopValue = 0.5
    let laundryValue = 0.5
    let roomAloneValue = 3.0
    let roomHelpValue = 2.0
    
    let daddasPassword = "Kai rocks!!"
    
    var total = 0.0
    
    var choreData: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChoreDataSet")
                
                do {
                    let result = try managedContext.fetch(fetchRequest)
                    print("RESULT")
                    print(result)
                    for data in result as! [NSManagedObject] {
//                        print("iteration")
//                        print(data.value(forKey: "total")!)
                        total = data.value(forKey: "total") as! Double
                    }
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
                print("Total is -->")
                print(total)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func dishesBtnPressed(_ sender: UIButton) {
        self.showPasswordAndProcess(dishValue)
    }
    
    
    // Shows modal that asks for simple password to allow adding of money
    func showPasswordAndProcess(_ value: Double) {
        let alertController = UIAlertController(title: "Dadda",
                                                        message: "Dadda's password please:",
                                                        preferredStyle: .alert)
                
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction) in
                    print("You've pressed the cancel button");
                }
                
                let actionSave = UIAlertAction(title: "Save", style: .default) { (action:UIAlertAction) in
                    
                    let pwEntered = alertController.textFields![0] as UITextField;
                    // OMG such amazing security!! lol
                    if (pwEntered.text! == self.daddasPassword) {
                        print("Match")
                        
                        // Save to total and present first screen with updated total
                        self.saveToTotal(value)
                    } else {
                        print("NOT A MATCH")
                    }
                    
                }
                
                alertController.addTextField { (textField) -> Void in
                    textField.placeholder = "Pasword here please"
                }
                
                //Add the buttons
                alertController.addAction(actionCancel)
                alertController.addAction(actionSave)
                
                //Present the alert controller
                present(alertController, animated: true, completion:nil)
    }
    
    func saveToTotal(_ value: Double) {
        print("Saving $\(value) to total")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let choreDataEntity = NSEntityDescription.entity(forEntityName: "ChoreDataSet", in: managedContext)!
        
        let choreData = NSManagedObject(entity: choreDataEntity, insertInto: managedContext)
        
        choreData.setValue(value, forKey: "total")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    

}

