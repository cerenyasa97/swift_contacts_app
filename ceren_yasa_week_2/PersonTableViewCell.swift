//
//  PersonTableViewCell.swift
//  ceren_yasa_week_2
//
//  Created by Ceren Yaşa on 27.05.2022.
//

import UIKit

protocol PersonCellProtocol: AnyObject{
    func cellCallPressed(index: Int)
    func cellMessagePressed(index: Int)
}

class PersonTableViewCell: UITableViewCell {
    @IBOutlet weak var personImageView: UIImageView!
    
    @IBOutlet weak var personNameLabel: UILabel!
    
    @IBOutlet weak var personPhoneLabel: UILabel!
    
    weak var cellDelegate: PersonCellProtocol?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        personImageView.contentMode = .scaleAspectFit;
    }
    
    @IBAction func callTapped(_ sender: Any) {
        if let cellDelegate = cellDelegate, let indexPath = indexPath {
            cellDelegate.cellCallPressed(index: indexPath.row)
        }
    }
    
    @IBAction func messageTapped(_ sender: Any) {
        if let cellDelegate = cellDelegate, let indexPath = indexPath {
            cellDelegate.cellMessagePressed(index: indexPath.row)
        }
    }
}
