//
//  HistoryView.swift
//  InTime
//
//  Created by Dana Buca on 27.07.2022.
//

import SwiftUI
import CoreData

var results = [SpeedResultModel]()

func getResult (){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SpeedResult")
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


struct HistoryView: View {
    init () {
              getResult()
            }
    var body: some View {
         List {
             ForEach(0..<results.count) { i in

                 Section {
                     VStack {
                         let speedResultModel : SpeedResultModel = results[i]
                         
//                                Image("image")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
                     
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Time")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                        Text(Utils.printSecondsToHoursMinutesSeconds(seconds: speedResultModel.time ?? 0))
                                            .font(.title3)
                                            .fontWeight(.black)
                                            .foregroundColor(Color(.sRGB, red: 51/255, green: 175/255, blue: 161/255, opacity: 1.0) )
                                            .lineLimit(3)
                                        Text("Start speed : " + String(speedResultModel.start ?? 0))
                                            .font(.headline)
                                            .foregroundColor(.secondary).padding(.top, 2)
                                        
                                        Text("End speed : " + String(speedResultModel.end ?? 0))
                                            .font(.headline)
                                            .foregroundColor(.secondary).padding(.top, 1)
                                    }
                                    .layoutPriority(100)
                     
                                    Spacer()
                                }
                                .padding().background(Color.red)
                            }
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                            )
                            .padding([ .horizontal])
                 }
                 }
         }
         .listStyle(GroupedListStyle()).background(Color.red)
        
    }
    
}
    


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
        
    }
}




