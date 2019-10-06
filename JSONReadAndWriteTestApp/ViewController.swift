//
//  ViewController.swift
//  JSONReadAndWriteTestApp
//
//  Created by HAUZ MacBook Pro 3 on 07/10/2019.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: ContactViewModel! {
        didSet{
            readJSONData()
        }
    }
    var contactDetails: [ContactDetails] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let addContactItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContact))
        self.navigationItem.rightBarButtonItem = addContactItem
        viewModel = ContactViewModel(contactDetails: contactDetails)
    }
    
    @objc func addNewContact(){
        self.performSegue(withIdentifier: "toDetailVC", sender: nil)
    }

    func saveJSONData(){
        var rootLevel: [AnyObject] = []
        for contact in viewModel.contactDetails{
            var contactDict: [String:String] = [:]
            contactDict["id"] = contact.id
            contactDict["firstName"] = contact.firstName
            contactDict["lastName"] = contact.lastName
            contactDict["phone"] = contact.phone
            contactDict["email"] = contact.email
            rootLevel.append(contactDict as AnyObject)
        }
        
        do {
        let jsonData = try JSONSerialization.data(withJSONObject: rootLevel, options: .prettyPrinted)
        let fileManager = FileManager.default
        let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonUrl = url.appendingPathComponent("data.json")
        try jsonData.write(to: jsonUrl, options: .atomic)
        
        }catch{
            print(error)
        }
    }
    
    func readJSONData(){
        let fileManager = FileManager.default
        do {
        let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonUrl = url.appendingPathComponent("data.json")
        let jsonReadData = try Data(contentsOf: jsonUrl)
            
        let parsedContactDetails = try JSONSerialization.jsonObject(with: jsonReadData, options: .mutableContainers)
            
            let contacts = parsedContactDetails as! [[String:String]]
            var contactDetailsObject: [ContactDetails] = []

            for contact in contacts{
                guard let id = contact["id"], let firstName = contact["firstName"], let lastName = contact["lastName"], let email = contact["email"], let phone = contact["phone"] else{ continue }
                let contactDetailsItem = ContactDetails()
                contactDetailsItem.id = id
                contactDetailsItem.firstName = firstName
                contactDetailsItem.lastName = lastName
                contactDetailsItem.email = email
                contactDetailsItem.phone = phone
                contactDetailsObject.append(contactDetailsItem)
            }
            viewModel.contactDetails = contactDetailsObject
            contactDetails = contactDetailsObject
            tableView.reloadData()
            
        }catch{
            print(error)
    }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as? ContactCell
        cell?.contactNameLabel.text = "\(viewModel.contactDetails[indexPath.row].firstName ?? "First") \(viewModel.contactDetails[indexPath.row].lastName ?? "Last")"
        cell?.contactImageView.setImage(string: "", color: UIColor.orange, circular: true, stroke: false, textAttributes: nil)
        return cell ?? UITableViewCell()
    }
    
}

