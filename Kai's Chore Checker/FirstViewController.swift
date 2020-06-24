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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//         moneyProgressBar.transform = moneyProgressBar.transform.scaledBy(x: 1, y: 2)
        
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
        
        totalEarnedLabel.text = "$\(total)"
        self.updateAndAnimateProgressBar()
        
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
}

