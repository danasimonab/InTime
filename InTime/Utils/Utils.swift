//
//  File.swift
//  InTime
//
//  Created by Dana Buca on 28.07.2022.
//

import Foundation


class Utils : NSObject {
    
    
        
    class func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    class func printSecondsToHoursMinutesSeconds (seconds:Int) -> (String) {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
        print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
        let stringToShow = ("\(h) Hours, \(m) Minutes, \(s) Seconds")
        return stringToShow
      
    }
    
    
}
