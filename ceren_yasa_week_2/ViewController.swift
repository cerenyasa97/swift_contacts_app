//
//  ViewController.swift
//  ceren_yasa_week_2
//
//  Created by Ceren Yaşa on 26.05.2022.
//

import UIKit
import CoreData

let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var peopleTableView: UITableView!
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        peopleTableView.dataSource = self
        peopleTableView.delegate = self
        
        
        // TableView cell height was assigned
        peopleTableView.rowHeight = screenSize.height * 0.080
        
        addNavigationBarItem()
        
        fetchPeople()
        
        observeNotification()
    }
    
    // A button was created on navigation bar for adding new person
    func addNavigationBarItem(){
        let edit = UIBarButtonItem(title: AppConstants.add, style: .plain, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = edit
    }
    
    @objc func add(){
        navigateToPersonDetail(index: nil)
    }
    
    // Fetch people from core data
    @objc func fetchPeople(){
        do{
            let peopleList = try context.fetch(People.fetchRequest())
            people = []
            for p in peopleList{
                people.append(Person(id: p.id, image: p.image, name: p.name, phone: p.phone))
            }
            peopleTableView.reloadData()
        } catch{
            showMessage(title: AppConstants.error, text: AppConstants.fetchError)
        }
    }
    
    func observeNotification(){
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(fetchPeople), name: .personNotification, object: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, PersonCellProtocol{
    
    // TableView element count was returned
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    // Created TableViewCell was connected and variables were assigned its component
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = peopleTableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonTableViewCell
        cell.cellDelegate = self
        cell.indexPath = indexPath
        cell.personImageView.image = UIImage(named: people[indexPath.row].image ?? "nina_darel")
        cell.personNameLabel.text = people[indexPath.row].nameSurname
        cell.personPhoneLabel.text = people[indexPath.row].phone
        return cell
    }
    
    // Navigate to selected person detail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToPersonDetail(index: indexPath.row)
    }
    
    // Navigation settings made and redirected to the page
    func navigateToPersonDetail(index: Int?){
        let storyboard = UIStoryboard(name: AppConstants.stroyboard, bundle: nil)
        let personVC = storyboard.instantiateViewController(withIdentifier: AppConstants.personVC) as! DetailViewController
        if let index = index{
            personVC.setValues(person: people[index])
        } else {
            personVC.isNewRecord = true
            personVC.isEdit = true
        }
        navigationController?.pushViewController(personVC, animated: true)
    }
    
    func cellCallPressed(index: Int) {
        showMessage(title: AppConstants.callingTitle, text: "\(people[index].nameSurname ?? "") \(AppConstants.callingContent)")
    }
    
    func cellMessagePressed(index: Int) {
        showMessage(title: AppConstants.messagingTitle, text: "\(AppConstants.messagingContent) \(people[index].nameSurname ?? "")")
    }
    
    // Show alert to user
    func showMessage(title: String, text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppConstants.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
