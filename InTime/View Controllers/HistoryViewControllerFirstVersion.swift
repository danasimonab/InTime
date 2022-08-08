//
//  HistoryViewController.swift
//  InTime
//
//  Created by Dana Buca on 23.07.2022.
//

import Foundation
import UIKit
import CoreData

class HistoryViewController: UITableViewController {
    
   
    @IBOutlet var historyTableView: UITableView!
    var results = [SpeedResultModel]()
    override func viewDidLoad() {
     super.viewDidLoad()
        getResult()
    }
    
    func getResult (){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SpeedResult")
                //request.predicate = NSPredicate(format: "age = %@", "21")
        request.returnsObjectsAsFaults = false
        do {
                    let result = try context.fetch(request)
                    for data in result as! [NSManagedObject]
        {
           let speedResultModel : SpeedResultModel = SpeedResultModel()
           speedResultModel.start = (data.value(forKey: "start") as! Int)
           speedResultModel.end = (data.value(forKey: "end") as! Int)
           speedResultModel.time = (data.value(forKey: "time") as! Int)
           results.append(speedResultModel)
           print(data.value(forKey: "start") as! Int)
           print(data.value(forKey: "end") as! Int)
           print(data.value(forKey: "time") as! Int)
          }

               } catch {

                   print("Failed")
        }
        
        print(results.count)
    }
   
    
    var speedResults: [NSManagedObject] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        for speedResult in results {
            print("................")
            print(speedResult.end ?? 0)
            cell.textLabel?.text = String(speedResult.end ?? 0)
        }
        
        
        return cell
    }

    
}
