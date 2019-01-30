//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by micasasucasa on 1/28/19.
//  Copyright © 2019 Jacob Rosevear. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {

    var alarm: Alarm?{
        didSet{
            loadViewIfNeeded()
            self.updateViews()
            
        }
    }
    
    var alarmIsOn: Bool = true
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmName: UITextField!
    @IBOutlet weak var enableAlarm: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func updateViews(){
        
        guard let alarm = alarm else {return}
        alarmIsOn = alarm.enabled
        datePicker.date = alarm.fireDate
        alarmName.text = alarm.name
        setUpAlarmButton()
        
    }
    
    func setUpAlarmButton(){
        
        switch alarmIsOn {
        case true:
            enableAlarm.backgroundColor = UIColor.green
            enableAlarm.setTitle("ON", for: .normal)
        case false:
            enableAlarm.backgroundColor = UIColor.gray
            enableAlarm.setTitle("Off", for: .normal)
        }
    }
    
    @IBAction func alarmEnabledButtonTapped(_ sender: UIButton) {
        if let alarm = alarm {
            AlarmController.shared.toggleEnabled(for: alarm)
            alarmIsOn = alarm.enabled
        }else{
            alarmIsOn = !alarmIsOn
        }
        setUpAlarmButton()
    }
    

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let title = alarmName.text else {return}
        guard title != "" else {return}
        
        if let alarm = alarm{
            AlarmController.shared.update(alarm: alarm, name: title, fireDate: datePicker.date, enabled: alarmIsOn)
        } else{
            AlarmController.shared.addAlarm(fireDate: datePicker.date, name: title, enabled: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
  

