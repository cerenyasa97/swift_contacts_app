//
//  DetailViewController.swift
//  ceren_yasa_week_2
//
//  Created by Ceren Yaşa on 28.05.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personPhoneLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    
    var _personInfo: Person?
    var person: Person?{
        set(newValue) {
            _personInfo = newValue
        }
        get {
            return _personInfo
        }
    }
    var people = [People]()
    
    var isEdit: Bool = false{
        didSet{
            if(!isNewRecord) {
                editingOperations()
            }
        }
    }
    var isNewRecord: Bool = false
    
    var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editingOperations()
    }
    
    // Editing settings was enabled/disabled
    func editingOperations(){
        addNavigationBarItem()
        
        hideComponents()
        
        if(isEdit){
            setEditingSettings()
        } else {
            setViewModeSettings()
        }
        
        personImageView.image = UIImage(named: person?.image ?? AppConstants.noImage)
    }
    
    func setEditingSettings() {
        leftButton.setTitle(AppConstants.cancel, for: .normal)
        rightButton.setTitle(AppConstants.ok, for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: isEdit ? #selector(pickImage) : nil)

        // add it to the image view;
        personImageView.addGestureRecognizer(tapGesture)
        
        // make sure imageView can be interacted with by user
        personImageView.isUserInteractionEnabled = true
    }
    
    func setViewModeSettings(){
        leftButton.setTitle(AppConstants.message, for: .normal)
        rightButton.setTitle(AppConstants.call, for: .normal)
        setUserInfo()
    }
    
    // A button was created on navigation bar for editing person data
    // The Edit button shown only non-editing mode
    func addNavigationBarItem(){
        let edit = UIBarButtonItem(title: AppConstants.edit, style: .plain, target: self, action: #selector(edit))
        if(!isEdit){
            self.navigationItem.rightBarButtonItem = edit
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    // Editing settings was enabled
    @objc func edit(){
        isEdit = true
        if let info = person{
            nameTextField.text = info.nameSurname
            phoneTextField.text = info.phone
        }
    }
    
    // Hides Labels in edit mode and TextFields in view mode
    func hideComponents(){
        nameTextField.isHidden = !isEdit
        phoneTextField.isHidden = !isEdit
        personPhoneLabel.isHidden = isEdit
        personNameLabel.isHidden = isEdit
    }

    // Set person info get from previous page
    func setValues(person: Person?) {
        self.person = person
    }
    
    // Set person info to UI components
    func setUserInfo(){
        if let info = person{
            personImageView.image = UIImage(named: info.image ?? "no_image")
            personNameLabel.text = info.nameSurname ?? ""
            personPhoneLabel.text = info.phone ?? ""
        }
    }
    
    // In Editing Mode close this mode,
    // In View Mode show message to user
    @IBAction func leftButtonTapped(_ sender: Any) {
        if(isEdit){
            isEdit = false
        } else {
            showMessage(title: AppConstants.messagingTitle, text: "\(AppConstants.messagingContent) \(person?.nameSurname ?? "")")
        }
    }
    
    // In Editing Mode save new data and close this mode,
    // In View Mode show message to user
    @IBAction func rightButtonTapped(_ sender: Any) {
        if(isEdit){
            savePersonNewData()
            isNewRecord = false
            isEdit = false
        } else {
            showMessage(title: AppConstants.callingTitle, text: "\(person?.nameSurname ?? "") \(AppConstants.callingContent)")
        }
    }
    
    // Save new data to person variable
    func savePersonNewData(){
        var oldName: String?
        if nameTextField.text != nil && !nameTextField.text!.isEmpty{
            personNameLabel.text = nameTextField.text!
            oldName = person?.nameSurname
            person?.nameSurname = nameTextField.text!
        }
        if phoneTextField.text != nil && !phoneTextField.text!.isEmpty{
            personPhoneLabel.text = phoneTextField.text
            person?.phone = phoneTextField.text!
        }
        fetchPeople()
        if(isNewRecord){
            person = Person(image: imageURL, name: personNameLabel.text, phone: personPhoneLabel.text)
            savePerson()
        } else {
            if let old = oldName{
                updatePerson(name: old)
            }
        }
        sendNotificationToViewController()
    }
    
    // Save new person to Core Data
    func savePerson(){
        let person = People(context: context)
        
        person.id = UUID()
        person.name = self.person?.nameSurname
        person.phone = self.person?.phone
        person.image = self.person?.image
        
        appDelegate.saveContext()
    }
    
    // Update existing person data in Core Data
    func updatePerson(name: String){
        let willBeUpdated = people.first { p in
            p.name == name
        }
        if let up = willBeUpdated{
            up.name = person?.nameSurname
            up.phone = person?.phone
            up.image = imageURL ?? person?.image
            appDelegate.saveContext()
        }
    }
    
    // Fetch people from core data
    @objc func fetchPeople(){
        do{
            people = try context.fetch(People.fetchRequest())
        } catch{
            showMessage(title: AppConstants.error, text: AppConstants.fetchError)
        }
    }
    
    // Send notification to people table for adding a new person
    func sendNotificationToViewController(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: .personNotification, object: nil)
    }
    
    // Show alert to user
    func showMessage(title: String, text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppConstants.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Select where image will be load
    @objc func pickImage(){
        let ac = UIAlertController(title: AppConstants.select, message: AppConstants.selectFrom, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: AppConstants.camera, style: .default){
            [weak self] handler in
            self?.showImagePicker(selectedSource: .camera)
        }
        
        let gallery = UIAlertAction(title: AppConstants.gallery, style: .default){
             handler in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: AppConstants.cancel, style: .cancel, handler: nil)
        
        ac.addAction(camera)
        ac.addAction(gallery)
        ac.addAction(cancel)
        self.present(ac, animated: true, completion: nil)
    }
    
    // Select image from gallery or take a new photo with camera
    func showImagePicker(selectedSource: UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // Get image after selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let im = info[.imageURL] as? String{
            imageURL = im
        }
        if let selectedImage = info[.originalImage] as? UIImage{
            print(selectedImage.imageAsset?.accessibilityLabel ?? "nilllll")
            personImageView.image = selectedImage
        } else {
            showMessage(title: AppConstants.error, text: AppConstants.imageError)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Close picker if selection cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        showMessage(title: AppConstants.cancelled, text: AppConstants.imageAddCancelled)
    }
}
