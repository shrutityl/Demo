//
//  ViewController.swift
//  DemoApp
//
//  Created by Apple on 24/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {
    
    let dataDict = NSDictionary()
    let strData = String()
   var mainDict = [String:AnyObject]()
    var json = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataSet()
    }
    
    //MARK: Function to create Dataset & set it in Dictionary
    func getDataSet() {
      
        var finalDict = [String:Any]()
        var weeklyDict = [String:Any]()
        
        var mondayArray = [[String:Any]]()
        var wedArray = [[String:Any]]()
        var thuArray = [[String:Any]]()
        
        var mondayDict1 = [String:Any]()
        mondayDict1["food"] = "Warm honey and water"
        mondayDict1["meal_time"] = "07:00"
        mondayArray.append(mondayDict1)
        
        var mondayDict2 = [String:Any]()
        mondayDict2["food"] = "proper thali"
        mondayDict2["meal_time"] = "15:00"
        mondayArray.append(mondayDict2)
        
        var wedDict1 = [String:Any]()
        wedDict1["food"] = "Sprouts"
        wedDict1["meal_time"] = "07:00"
        wedArray.append(wedDict1)
        
        var wedDict2 = [String:Any]()
        wedDict2["food"] = "Bread lintils and Rice"
        wedDict2["meal_time"] = "16:00"
        wedArray.append(wedDict2)
        
        var wedDict3 = [String:Any]()
        wedDict3["food"] = "Soup ,Rice and Chicken"
        wedDict3["meal_time"] = "21:00"
        wedArray.append(wedDict3)
        
        var thuDict1 = [String:Any]()
        thuDict1["food"] = "scramblled eggs"
        thuDict1["meal_time"] = "08:00"
        thuArray.append(thuDict1)
        
        var thuDict2 = [String:Any]()
        thuDict2["food"] = "Burrito bowls"
        thuDict2["meal_time"] = "14:00"
        thuArray.append(thuDict2)
        
        var thuDict3 = [String:Any]()
        thuDict3["food"] = "Evening snacks"
        thuDict3["meal_time"] = "18:00"
        thuArray.append(thuDict3)
        
        var thuDict4 = [String:Any]()
        thuDict4["food"] = "North Indian thali"
        thuDict4["meal_time"] = "22:00"
        thuArray.append(thuDict4)
        
        weeklyDict["thursday"] = thuArray
        weeklyDict["wednesday"] = wedArray
        weeklyDict["monday"] = mondayArray
        
        print(weeklyDict)
        print(wedArray)
        print(thuArray)
        
        finalDict["diet_duration"] = 20
        finalDict["week_diet_data"] = weeklyDict
        
        print(finalDict)
        
        let data = try! JSONSerialization.data(withJSONObject: finalDict, options: JSONSerialization.WritingOptions.prettyPrinted)
        json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        
        setNotification()

    }
    //MARK: Function to convert String to Dictionary
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
     //MARK: Function to set Local Notifications
    
    func setNotification(){
        
        let dict = convertStringToDictionary(text: json as String)
        
        var newDict = NSDictionary()
        newDict = (dict?["week_diet_data"]) as! NSDictionary
        
        let monArray = newDict.object(forKey: "monday") as! [[String : Any]]
        self.scheduleNotifiation(weekDay: 2, timeDetail: monArray)
        print(monArray)
        
        let thuArray = newDict.object(forKey: "thursday") as! [[String : Any]]
        self.scheduleNotifiation(weekDay: 5, timeDetail: thuArray)
        print(thuArray)
        
        let wedArray = newDict.object(forKey: "wednesday") as! [[String : Any]]
        self.scheduleNotifiation(weekDay: 4, timeDetail: wedArray)
        print(wedArray)
        
        
        
//        // add notification for Mondays at 11:00 a.m.
//        var dateComponents = DateComponents()
//        dateComponents.weekday = 2
//        dateComponents.hour = 11
//        dateComponents.minute = 0

    }
    
    func scheduleNotifiation(weekDay : Int, timeDetail : [[String : Any]]) {
        for item in timeDetail{
            
            let mealTime = item["meal_time"] as! String
            let foodStr = item["food"] as! String
            
            let notification = UNMutableNotificationContent()
            notification.title = "Message"
            notification.subtitle = foodStr
            notification.body = "I need to tell you something."
            
            let timeWithHourAndMinute = mealTime.components(separatedBy: ":")
            let hour = Int(timeWithHourAndMinute[0])
            let minute = Int(timeWithHourAndMinute[1])
            var dateComponents = DateComponents()
            dateComponents.weekday = weekDay
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            print("weekdsy is",weekDay)
            print("hour is",hour)
            print("minute is",minute)
            
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
             print("notificationTrigger is",notificationTrigger)
            
            let request = UNNotificationRequest(identifier: foodStr, content: notification, trigger: notificationTrigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
        getAllScehduledNotifs()
    }
    
    func getAllScehduledNotifs() {
        
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)")
            for item in notifications {
                print(item.content)
            }
        }
    }
    
}

