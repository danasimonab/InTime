//
//  RecordViewController.swift
//  InTime
//
//  Created by Dana Buca on 09/11/2020.
//

import UIKit
import CoreLocation
import CoreData
import LMGaugeViewSwift
class RecordViewController: UIViewController , CLLocationManagerDelegate, UITextFieldDelegate, GaugeViewDelegate{
  
    var timeDelta: Double = 1.0/24
    var velocity: Double = 0
    var acceleration: Double = 5
    
    @IBOutlet weak var gaugeView: GaugeView!
    
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var startSpeedLbl: UILabel!
    @IBOutlet weak var startSpeedTextField: UITextField!
    @IBOutlet weak var endSpeedTextField: UITextField!
    @IBOutlet weak var endSpeedLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
   
    
    
    var timer:Timer!
    var currentSpeed = 0
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteAllRecords()
        
        let screenMinSize = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let ratio = Double(screenMinSize)/320
        self.gaugeView.delegate = self
        gaugeView.divisionsRadius = 1.25 * ratio
        gaugeView.subDivisionsRadius = (1.25 - 0.5) * ratio
        gaugeView.ringThickness = 16 * ratio
        gaugeView.valueFont = UIFont(name: GaugeView.defaultFontName, size: CGFloat(140 * ratio))!
        gaugeView.unitOfMeasurementFont = UIFont(name: GaugeView.defaultFontName, size: CGFloat(16 * ratio))!
        gaugeView.minMaxValueFont = UIFont(name: GaugeView.defaultMinMaxValueFont, size: CGFloat(12 * ratio))!
        
        // Update gauge view
        gaugeView.minValue = 0
        gaugeView.maxValue = 240
        gaugeView.limitValue = 50
        
        self.locationManager .delegate = self
        self.startSpeedTextField.delegate = self
        self.endSpeedTextField.delegate  =  self
        self.locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager .startUpdatingLocation()
        self.refreshButton.isEnabled = false
        
        Timer.scheduledTimer(timeInterval: timeDelta,
                             target: self,
                             selector: #selector(updateGaugeTimer),
                             userInfo: nil,
                             repeats: true)
      
       
    }
    
    @objc func updateGaugeTimer(timer: Timer) {
        // Set value for gauge view
        gaugeView.value = Double(currentSpeed)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        timer.invalidate()
        self.refreshButton.isEnabled = false
        self.counter = 0;
        self.recordButton.alpha = 1.0;
        self.timeLabel.text = "00:00:00";
        
    }
    
    func ringStokeColor(gaugeView: GaugeView, value: Double) -> UIColor {
        if value >= gaugeView.limitValue {
            return UIColor(red: 51/255, green: 175.0/255, blue: 161.0/255, alpha: 1)
        }
        
        return UIColor(red: 51.0/255, green: 175.0/255, blue: 161.0/255, alpha: 1)
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
        let stringToShow = ("\(h):\(m):\(s)")
        return stringToShow
      
    }
    
    @IBAction func recordAction(_ sender: Any) {
        print("test");

        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true);

    }
    
    @objc func startTimer(){
        recordButton.alpha = 0.5;
        self.refreshButton.isEnabled = true
        let startSpeed = startSpeedTextField.text ?? "0";
        let endSpeed = endSpeedTextField.text ?? "0";
        let c1 = currentSpeed
        
        if(!startSpeed.isEmpty  && !endSpeed.isEmpty){
            if(Int(c1) >= Int(startSpeed) ?? 0  ){
                counter += 1;
                timeLabel.text = "\(printSecondsToHoursMinutesSeconds(seconds: counter))"
            } else {
                counter = 0;
                timeLabel.text = "\(printSecondsToHoursMinutesSeconds(seconds: counter))"
            }
            
            let value = endSpeedTextField.text ?? "0";
            let c = currentSpeed
            if(Int(c) == Int(value) ){
                timer.invalidate()

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
                    self.timeLabel.text = "00:00:00";
                    self.refreshButton.isEnabled = false
                    
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
