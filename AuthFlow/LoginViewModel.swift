//
//  LoginViewModel.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/3/23.
//

import Foundation

@MainActor class LoginViewModel: ObservableObject{
    
    @Published var credentials = AuthLoginCredentials(email: "user@email.com", password: "pass")
    @Published var loginError: AuthApiError? = nil
    @Published var isLoggingIn = false
    
    
    func login(completion: @escaping (Bool) -> Void) {
        isLoggingIn = true
        AuthService.shared.login(credentials: credentials) { [weak self] result in
             switch result{
             case .success:
                 completion(true)
             case .failure(let error):
                 completion(false)
                 self?.loginError = error
             }
            
            self?.isLoggingIn = false
        }
    }
}
