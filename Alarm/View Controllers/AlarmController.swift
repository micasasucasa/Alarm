//
//  AlarmController.swift
//  Alarm
//
//  Created by micasasucasa on 1/28/19.
//  Copyright © 2019 Jacob Rosevear. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController: AlarmScheduler {
    
    //var alarms: [Alarm] = []
    var alarms = [Alarm]()
    static let shared = AlarmController()
    
    //create
    func addAlarm(fireDate: Date, name: String, enabled: Bool){
        let alarm = Alarm(fireDate: fireDate, name: name)
        alarm.enabled = enabled
        AlarmController.shared.alarms.append(alarm)
        saveToPersistentStore()
    }
    
    //update
    func update(alarm: Alarm, name: String, fireDate: Date, enabled: Bool){
       cancelUserNotification(for: alarm)
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        scheduleUserNotification(for: alarm)
        saveToPersistentStore()
    }
    
    //delete
    func delete(alarm: Alarm) {
        guard let index = AlarmController.shared.alarms.index(of: alarm) else { return }
        self.cancelUserNotification(for: alarm)
        alarms.remove(at: index)
        saveToPersistentStore()
    }
    
    func toggleEnabled(for alarm: Alarm){
        alarm.enabled = !alarm.enabled

        if alarm.enabled{
            scheduleUserNotification(for: alarm)
        } else{
            cancelUserNotification(for: alarm)
        }
    }
    
    
    //file URL
    func fileURL() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = path[0]
        let fileName = "alarm.json"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        return fileURL
    }
    
    //save
    func saveToPersistentStore(){
        
        let encoder = JSONEncoder()
        
        do{
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        } catch{
            print("Failed to Save to Persistent Store \(error) \(error.localizedDescription)")
        }
        //tableView.reloadData()
    }
    
    //load
    func loadFromPersisentStore() -> [Alarm]{
        let decoder = JSONDecoder()
        
        do{
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            return alarms
        } catch {
            print("Failed to Load from Persistent Store \(error) \(error.localizedDescription)")
        }
        return []
    }
}
    protocol AlarmScheduler: class{
        func scheduleUserNotification(for alarm: Alarm)
        func cancelUserNotification(for alarm: Alarm)
    }

    extension AlarmScheduler{
        
        func scheduleUserNotification(for alarm: Alarm){
            
            let content = UNMutableNotificationContent()
            content.title = "Time to get up"
            content.body = "Your alarm named \(alarm.name) is going off!"
            content.sound = UNNotificationSound.default
            
            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                    print("Error scheduling local user notifications \(error.localizedDescription)  :  \(error)")
                }
            }
            
        }
        
        func cancelUserNotification(for alarm: Alarm){
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        }
    }


