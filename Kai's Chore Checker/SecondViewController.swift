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
    
    //ANIMATION
    @IBOutlet weak var horizontalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    
    let dishValue = 1.0
    let dogPoopValue = 0.5
    let laundryValue = 0.5
    let roomAloneValue = 3.0
    let roomHelpValue = 2.0
    let mistakeValue = -1.0
    
    let daddasPassword = "Kai rocks!!"
    
    var total = 0.0
    let goal = 35.0
    
    var choreData: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ANIMATION
        horizontalCenterConstraint.constant += view.bounds.width
        rightConstraint?.isActive = false
        leftConstraint?.isActive = false
        
        // Configure core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChoreTransaction")
        
        // Update total and matching UI
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            // iterate through result and sum total
            for data in result as! [NSManagedObject] {
                
                if(data.value(forKey: "disabled") as! Bool == true) {
                    total -= data.value(forKey: "amount") as! Double
                } else {
                    total += data.value(forKey: "amount") as! Double
                }
                
                // Break if over or at total
                if (total >= goal) {
                    break
                }
                
            }
        } catch let error as NSError {
            // TODO: error handling (lol)
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print("total is --> ")
        print(total)
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
           UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
               self.horizontalCenterConstraint.constant -= self.view.bounds.width
               self.rightConstraint?.isActive = true
               self.leftConstraint?.isActive = true
               self.view.layoutIfNeeded()
           }, completion: nil)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // UIButton actions
    @IBAction func dishesBtnPressed(_ sender: UIButton) {
        self.showPasswordAndProcess(dishValue)
    }
    
    @IBAction func dogPoopBtnPressed(_ sender: UIButton) {
        self.showPasswordAndProcess(dogPoopValue)
    }
    
    @IBAction func laundryBtnPressed(_ sender: UIButton) {
        self.showPasswordAndProcess(laundryValue)
    }
    
    @IBAction func room1BtnPressed(_ sender: UIButton) {
        self.showPasswordAndProcess(roomAloneValue)
    }
    
    @IBAction func room2BtnPressed(_ sender: UIButton) {
        self.showPasswordAndProcess(roomHelpValue)
    }
    
    @IBAction func mistakeBtnPressed(_ sender: UIButton) {
        self.showPasswordAndProcess(mistakeValue)
    }
    
    
    
    
    
    // Shows modal that asks for simple password to allow adding of money
    // TODO: Abstract out
    func showPasswordAndProcess(_ value: Double) {
        let alertController = UIAlertController(title: "Dadda",
                                                        message: "Dadda's password please:",
                                                        preferredStyle: .alert)
                
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction) in
                    print("Cancelled");
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
                        self.showPasswordErrorMessage()
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
        
        // TODO: Add error modal for wrong password
    }
    
    func saveToTotal(_ value: Double) {
        print("Saving $\(value) to total")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let choreTransactionEntity = NSEntityDescription.entity(forEntityName: "ChoreTransaction", in: managedContext)!
        
        let choreData = NSManagedObject(entity: choreTransactionEntity, insertInto: managedContext)
        
        choreData.setValue(value, forKey: "amount")
        choreData.setValue(Date(), forKey: "date")
        choreData.setValue(false, forKey: "disabled")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    func showPasswordErrorMessage(){
        let alert = UIAlertController(title:"Error", message: "Wrong password entered!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}

