//
//  PersonViewController.swift
//  ceren_yasa_week_2
//
//  Created by Ceren Yaşa on 27.05.2022.
//

import UIKit

class PersonViewController: UIViewController {
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personPhoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func messageTapped(_ sender: Any) {
    }
    
    @IBAction func callTapped(_ sender: Any) {
    }
}
