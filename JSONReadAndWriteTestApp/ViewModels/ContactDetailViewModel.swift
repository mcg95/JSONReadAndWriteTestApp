//
//  ContactDetailViewModel.swift
//  JSONReadAndWriteTestApp
//
//  Created by HAUZ MacBook Pro 3 on 07/10/2019.
//

import UIKit

class ContactDetailViewModel{
    
    var contactDetails: [ContactDetails]
    var id: String
    var firstName: String
    var lastName: String
    var contactImage: UIImage?
    var email: String
    var phone: String
    
    init(id: String, firstName: String, lastName: String, contactImage: UIImage?, email: String, phone: String, contactDetails: [ContactDetails]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.contactImage = contactImage
        self.email = email
        self.phone = phone
        self.contactDetails = contactDetails
    }
}
