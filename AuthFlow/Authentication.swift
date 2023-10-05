//
//  Authentication.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/4/23.
//

import SwiftUI

class Authentication: ObservableObject{
    
    @Published var user: User? = nil{
        didSet{
            isAuthenticated = user != nil
        }
    }
    @Published var isAuthenticated: Bool = false
        
    func updateValidation(user: User?) {
        withAnimation {
            self.user = user
        }
    }
}
