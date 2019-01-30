//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by micasasucasa on 1/28/19.
//  Copyright © 2019 Jacob Rosevear. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    var alarm: Alarm?{
        didSet{
            updateViews()
        }
    }
    weak var delegate: AlarmTableViewCellDelegate?

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {
         delegate?.alarmWasToggled(sender: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateViews(){
        guard let alarm = alarm else {return}
        
        nameLabel.text = alarm.name
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.enabled
    }
    
}
