//
//  FirstViewController.swift
//  Kai's Chore Checker
//
//  Created by Virgil Martinez on 6/24/20.
//  Copyright © 2020 Virgil Martinez. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController {
    
    var total = 0.0
    let goal = 35.0
    
    @IBOutlet weak var totalEarnedLabel: UILabel!
    @IBOutlet weak var moneyProgressBar: UIProgressView!
    
    // Constraint outlets for animations
    @IBOutlet weak var horizontalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ANIMATION
        horizontalCenterConstraint.constant -= view.bounds.width
        totalEarnedLabel.alpha = 0.0
        rightConstraint?.isActive = false
        leftConstraint?.isActive = false
        
        // Reset total
        total = 0.0
        
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
        
        // Juuuuuuust in case
        if(total <= 0.0) {
            total = 0.0
        }
    
        
        // Update UI
        totalEarnedLabel.text = "$\(total)"
        self.updateAndAnimateProgressBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.horizontalCenterConstraint.constant += self.view.bounds.width
            self.totalEarnedLabel.alpha = 1
            self.rightConstraint?.isActive = true
            self.leftConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        if(total >= goal) {
            self.showSuccess()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    func updateAndAnimateProgressBar() {
        let progressPercentage = (total / goal)
        print(progressPercentage)
        moneyProgressBar.setProgress(Float(progressPercentage), animated: true)
    }
    
    func showSuccess(){
        let alert = UIAlertController(title:"YOU DID IT :D", message: "Way to go Kai! You have earned enough money to get your Ryan's World Travel Case. Let's go to Target!!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "YAY !!", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

