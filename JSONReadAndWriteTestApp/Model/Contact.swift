//
//  Contact.swift
//  JSONReadAndWriteTestApp
//
//  Created by HAUZ MacBook Pro 3 on 07/10/2019.
//

import Foundation

class Contact{
    var contactDetailObject: [ContactDetails]
    
    init(contactDetailObject: [ContactDetails]) {
        self.contactDetailObject = contactDetailObject
    }
}

class ContactDetails{
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
}
