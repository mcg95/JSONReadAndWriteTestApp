//
//  ViewController.swift
//  JSONReadAndWriteTestApp
//
//  Created by HAUZ MacBook Pro 3 on 07/10/2019.
//

import UIKit
import ESPullToRefresh

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ContactViewModel! {
        didSet{
            readJSONData()
        }
    }
    var contactDetails: [ContactDetails] = []
    var selectedContact: ContactDetails?
    var selectedIndexPath: IndexPath?
    var isNewContact = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let addContactItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContact))
        self.navigationItem.rightBarButtonItem = addContactItem
        viewModel = ContactViewModel(contactDetails: contactDetails)
        self.tableView.es.addPullToRefresh {
            self.readJSONData()
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    @objc func addNewContact(){
        isNewContact = true
        self.performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isNewContact = false
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
    
    func navigateToDetail(contact: ContactDetails, indexPath: IndexPath){
        selectedContact = contact
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailViewController{
            if (!isNewContact){
                let vc = segue.destination as? DetailViewController
                vc?.selectedContact = selectedContact
                vc?.contactDetails = viewModel.contactDetails
                vc?.tableIndexPath = selectedIndexPath
            }else{
                let vc = segue.destination as? DetailViewController
                vc?.isNewContact = isNewContact
                vc?.contactDetails = viewModel.contactDetails
                vc?.tableIndexPath = selectedIndexPath
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetail(contact: contactDetails[indexPath.row], indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

