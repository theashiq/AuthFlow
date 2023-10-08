//
//  AuthenticationViewModel.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/4/23.
//

import Foundation
import SwiftUI
import Combine

class AuthenticationViewModel: ObservableObject{
    
    @Published var name: String = ""
    @Published var nameErrorMessage: String = ""
    @Published var isNamePristine = true
    @Published var isNameValid = true
    
    @Published var email: String = ""
    @Published var emailErrorMessage: String = ""
    @Published var isEmailPristine = true
    @Published var isEmailValid = true
    let emailPredicate: NSPredicate = .init(format: "SELF MATCHES %@", "^((([!#$%&'*+\\-/=?^_`{|}~\\w])|([!#$%&'*+\\-/=?^_`{|}~\\w][!#$%&'*+\\-/=?^_`{|}~\\.\\w]{0,}[!#$%&'*+\\-/=?^_`{|}~\\w]))[@]\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)$")
    
    @Published var password: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var isPasswordPristine = true
    @Published var isPasswordValid = true
    let passwordPredicate: NSPredicate = .init(format: "SELF MATCHES %@", "^.{4,8}$")
    
    @Published var passwordRepeat: String = ""
    @Published var passwordRepeatErrorMessage: String = ""
    @Published var isPasswordRepeatPristine = true
    @Published var isPasswordRepeatValid = true
    
    @Published var canLogIn = false
    @Published var isLoggingIn = false

    @Published var canRegister = false
    @Published var isRegistering = false
    
    @Published var error: AuthApiError? = nil
    @Published var isLoginViewSelected = true
    @Published var enableButton: Bool = false
    
    private var cancellablePublishers = Set<AnyCancellable>()
    
    init() {
        
        $name
            .map{ $0.count > 3 }
            .assign(to: \.isNameValid, on: self)
            .store(in: &cancellablePublishers)
        
        Publishers.CombineLatest($isNameValid, $isNamePristine)
            .map{ $0.0 || $0.1 ? "" : "Name but have 4 characters" }
            .assign(to: \.nameErrorMessage, on: self)
            .store(in: &cancellablePublishers)
        
        $email
            .map{ self.emailPredicate.evaluate(with: $0)}
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellablePublishers)
        
        Publishers.CombineLatest($isEmailValid, $isEmailPristine)
            .map{ $0.0 || $0.1 ? "" : "Email is invalid" }
            .assign(to: \.emailErrorMessage, on: self)
            .store(in: &cancellablePublishers)
        
        $password
            .map{ return self.passwordPredicate.evaluate(with: $0) }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellablePublishers)
        
        $password
            .map{ $0 == self.passwordRepeat }
            .assign(to: \.isPasswordRepeatValid, on: self)
            .store(in: &cancellablePublishers)
        
        Publishers.CombineLatest($isPasswordValid, $isPasswordPristine)
            .map{ $0.0 || $0.1 ? "" : "Password must have 4 to 8 characters" }
            .assign(to: \.passwordErrorMessage, on: self)
            .store(in: &cancellablePublishers)
        
        $passwordRepeat
            .map{ $0 == self.password }
            .assign(to: \.isPasswordRepeatValid, on: self)
            .store(in: &cancellablePublishers)
        
        Publishers.CombineLatest3($isPasswordRepeatValid, $isPasswordRepeatPristine, $isPasswordValid)
            .map{ isPasswordRepeatValid, isPasswordRepeatPristine, _ in
                isPasswordRepeatValid || isPasswordRepeatPristine ? "" : "Mismatched passwords"
            }
            .assign(to: \.passwordRepeatErrorMessage, on: self)
            .store(in: &cancellablePublishers)
        
        Publishers.CombineLatest($isEmailValid, $isPasswordValid)
            .map{ $0.0 && $0.1 }
            .assign(to: \.canLogIn, on: self)
            .store(in: &cancellablePublishers)
        
        Publishers.CombineLatest4($isNameValid, $isEmailValid, $isPasswordValid, $isPasswordRepeatValid)
            .map{ $0 && $1 && $2 && $3 }
            .assign(to: \.canRegister, on: self)
            .store(in: &cancellablePublishers)
        
        Publishers.CombineLatest3($canLogIn, $canRegister, $isLoginViewSelected)
            .map{ canLogIn, canRegister, isLoginViewSelected in
                isLoginViewSelected ? canLogIn : canRegister
            }
            .assign(to: \.enableButton, on: self)
            .store(in: &cancellablePublishers)
    }
    
    func login(completion: @escaping (User?) -> Void) {
        isLoggingIn = true
        AuthService.shared.login(credentials: AuthLoginCredentials(email: email, password: password)) { [weak self] result in
             switch result{
             case .success(let user):
                 completion(user)
             case .failure(let error):
                 completion(nil)
                 self?.error = error
             }
            
            self?.isLoggingIn = false
            self?.clearLoginFields()
        }
    }
    
    func register(completion: @escaping (User?) -> Void) {
        isRegistering = true
        AuthService.shared.register(credentials: AuthRegistrationCredentials(email: email, password: password, name: name)) { [weak self] result in
             switch result{
             case .success(let user):
                 self?.clearAllFields()
                 completion(user)
             case .failure(let error):
                 completion(nil)
                 self?.error = error
             }
            
            self?.isRegistering = false
        }
    }
    
    private func clearLoginFields(){
        email = ""
        password = ""
    }
    private func clearAllFields(){
        name = ""
        passwordRepeat = ""
        clearLoginFields()
    }
    
}
