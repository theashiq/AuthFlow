//
//  Authentication.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/4/23.
//

import SwiftUI

class Authentication: ObservableObject{
    @Published var isAuthenticated: Bool = false
        
    func updateValidation(success: Bool) {
        withAnimation {
            isAuthenticated = success
        }
    }
}
