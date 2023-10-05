//
//  AuthenticationViewModel.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/4/23.
//

import Foundation

class AuthenticationViewModel: ObservableObject{
    
    @Published var loginCredentials = AuthLoginCredentials(email: "user@email.com", password: "pass")
    @Published var loginError: AuthApiError? = nil
    @Published var isLoggingIn = false
    
    @Published var registerCredentials = AuthRegistrationCredentials(email: "user@email.com", password: "pass")
    @Published var RegisterError: AuthApiError? = nil
    @Published var isRegistering = false
    
    var showProgress: Bool{ isLoggingIn || isRegistering }
        
    func register(completion: @escaping (User?) -> Void) {
        isRegistering = true
        AuthService.shared.register(credentials: registerCredentials) { [weak self] result in
             switch result{
             case .success(let user):
                 completion(user)
             case .failure(let error):
                 completion(nil)
                 self?.RegisterError = error
             }
            
            self?.isRegistering = false
        }
    }
    
    
    func login(completion: @escaping (User?) -> Void) {
        isLoggingIn = true
        AuthService.shared.login(credentials: loginCredentials) { [weak self] result in
             switch result{
             case .success(let user):
                 completion(user)
             case .failure(let error):
                 completion(nil)
                 self?.loginError = error
             }
            
            self?.isLoggingIn = false
        }
    }
}
