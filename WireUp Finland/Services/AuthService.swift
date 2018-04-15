//
//  AuthService.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 20-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    
    func registerUser(withEmail email: String, andPassword password: String, forSchool school: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            
            let schoolSelected = school
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.instance.createDBUser(withSchool: schoolSelected, uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    
    
    /*
     func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
     Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
     guard let user = user else {
     userCreationComplete(false, error)
     return
     }
     
     let userData = ["provider": user.providerID, "email": user.email]
     DataService.instance.createDBUser(withSchool: <#String#>, uid: user.uid, userData: userData)
     userCreationComplete(true, nil)
     }
     }*/
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
}
