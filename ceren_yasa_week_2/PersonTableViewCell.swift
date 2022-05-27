//
//  PersonTableViewCell.swift
//  ceren_yasa_week_2
//
//  Created by Ceren Yaşa on 27.05.2022.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    @IBOutlet weak var personImageView: UIImageView!
    
    @IBOutlet weak var personNameLabel: UILabel!
    
    @IBOutlet weak var personPhoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        personImageView.contentMode = .scaleAspectFit;
        // Configure the view for the selected state
    }
    
    @IBAction func callTapped(_ sender: Any) {
    }
    
    @IBAction func messageTapped(_ sender: Any) {
    }
}
