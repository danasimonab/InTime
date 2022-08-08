//
//  RecordViewController.swift
//  InTime
//
//  Created by Dana Buca on 09/11/2020.
//

import UIKit
import CoreLocation
import CoreData
class RecordViewController: UIViewController , CLLocationManagerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var currentSpeedValueLabel: UILabel!
    @IBOutlet weak var startSpeedLbl: UILabel!
    @IBOutlet weak var startSpeedTextField: UITextField!
    @IBOutlet weak var endSpeedTextField: UITextField!
    @IBOutlet weak var endSpeedLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
   // var speedResultModel : SpeedResultModel = SpeedResultModel()
    
    let locationManager = CLLocationManager()
   
    
    
    var timer:Timer!
    var currentSpeed = 0
    var currentSpeed1 = 14.00
    var counter = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteAllRecords()
        self.locationManager .delegate = self
        self.startSpeedTextField.delegate = self
        self.endSpeedTextField.delegate  =  self
        self.locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager .startUpdatingLocation()
      
       
    }
    
    func deleteAllRecords() {
            //delete all data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SpeedResult")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
        }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var loc = CLLocation()
        loc = locations.first!
        let speed = locations.first?.speed;
        currentSpeed = Int(Int(speed! * 3.6))

        currentSpeedValueLabel.text = "\(Int(Int(speed! * 3.6))) km/h"
      //  NSLog("speed = ", String (format: "%i", speed!));
       
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("\(error.localizedDescription)")
   }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func printSecondsToHoursMinutesSeconds (seconds:Int) -> (String) {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
        print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
        let stringToShow = ("\(h) Hours, \(m) Minutes, \(s) Seconds")
        return stringToShow
      
    }
    
    @IBAction func recordAction(_ sender: Any) {
        print("test");
     //   self.timer.invalidate()
     //   let value = startSpeedTextField.text ?? "0";
     //   let c = currentSpeed//Int(Int(speed! * 3.6));//currentSpeedValueLabel.text ?? "0";
       // if(Int(c) == Int(value) ){
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true);
        
       // }
        
    }
    
    @objc func startTimer(){
        recordButton.alpha = 0.5;
        let startSpeed = startSpeedTextField.text ?? "0";
        let endSpeed = endSpeedTextField.text ?? "0";
        let c1 = currentSpeed
        
        if(!startSpeed.isEmpty  && !endSpeed.isEmpty){
            if(Int(c1) >= Int(startSpeed) ?? 0  ){
                counter += 1;
                timeLabel.text = "The time is: \(printSecondsToHoursMinutesSeconds(seconds: counter))"//"\(counter)";
            } else {
                counter = 0;
                timeLabel.text = "The time is: \(printSecondsToHoursMinutesSeconds(seconds: counter))"//"\(counter)";
            }
            
            let value = endSpeedTextField.text ?? "0";
            let c = currentSpeed//currentSpeedValueLabel.text ?? "0"
            if(Int(c) == Int(value) ){
                timer.invalidate()
                //            speedResult.start = Int(startSpeedTextField.text ?? "0")
                //            speedResult.end = Int(endSpeedTextField.text ?? "0")
                //            speedResult.time = counter
                //
                let dialogMessage = UIAlertController(title: "Congrats", message: "The time is: \(printSecondsToHoursMinutesSeconds(seconds: counter))", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    
                    let entity = NSEntityDescription.entity(forEntityName: "SpeedResult", in: context)
                    let newSpeedResult  = NSManagedObject(entity: entity!, insertInto: context)
                    
                    newSpeedResult.setValue(Int16(self.startSpeedTextField.text ?? "0"), forKeyPath: "start")
                    newSpeedResult.setValue(Int16(self.endSpeedTextField.text ?? "0"), forKeyPath: "end")
                    newSpeedResult.setValue(self.counter, forKeyPath:"time")
                    do {
                        try context.save()
                    } catch {
                        print("Error saving")
                    }
                    
                    self.counter = 0;
                    self.recordButton.alpha = 1.0;
                    
                })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
                
            }
        } else {
            let dialogMessage = UIAlertController(title: "Warning", message: "Empty fields are not allowed!", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.recordButton.alpha = 1.0;
            })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
        // timer.invalidate()
        
    }
}
