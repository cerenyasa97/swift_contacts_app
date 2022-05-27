//
//  ViewController.swift
//  ceren_yasa_week_2
//
//  Created by Ceren Yaşa on 26.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var peopleTableView: UITableView!
    
    var people = [
        Person(image: "nina_darel", name: "Nina Darel", phone: "555 532 65 23"),
        Person(image: "john_doe", name: "John Doe", phone: "544 354 85 90")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        peopleTableView.dataSource = self
        peopleTableView.delegate = self
        peopleTableView.rowHeight = screenSize.height * 0.080
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = peopleTableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonTableViewCell
        cell.personImageView.image = UIImage(named: people[indexPath.row].image ?? "nina_darel")
        cell.personNameLabel.text = people[indexPath.row].nameSurname
        cell.personPhoneLabel.text = people[indexPath.row].phone
        return cell
    }
}
