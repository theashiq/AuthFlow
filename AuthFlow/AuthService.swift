//
//  AuthService.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/3/23.
//

import Foundation


class AuthService{
    
    typealias Completion = (Result<User, AuthApiError>) -> Void
    
    static var shared = AuthService()
    
    private init(){}
    
    func login(credentials: AuthLoginCredentials, completion: @escaping Completion){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            if credentials.password == "pass"{
                completion(.success(User(
                    email: credentials.email,
                    password: credentials.password,
                    name: "",
                    dateOfBirth: .now)
                ))
            }
            else{
                completion(.failure(.invalidLoginCredential))
            }
        }
    }
    
    func register(credentials: AuthRegistrationCredentials, completion: @escaping Completion){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            if credentials.password == "pass"{
                completion(.success(User(
                    email: credentials.email,
                    password: credentials.password,
                    name: credentials.name,
                    dateOfBirth: credentials.dateOfBirth)
                ))
            }
            else{
                completion(.failure(.registrationError))
            }
        }
    }
}

struct AuthLoginCredentials{
    var email: String = ""
    var password: String = ""
    
    static var empty: Self{
        AuthLoginCredentials()
    }
}

struct AuthRegistrationCredentials{
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var dateOfBirth: Date? = nil
    
    static var empty: Self{
        AuthRegistrationCredentials()
    }
}

struct User: Identifiable{
    var id = UUID().uuidString
    var email: String
    var password: String // should not stay here
    var name: String
    var dateOfBirth: Date? = nil
}


enum AuthApiError: Error, LocalizedError{
    case invalidLoginCredential
    case registrationError
    
    var errorDescription: String?{
        switch self{
        case .invalidLoginCredential: return NSLocalizedString("Log in failed. Either your email or password is incorrect", comment: "")
        case .registrationError: return NSLocalizedString("Registration failed. Please try again after a while.", comment: "")
        }
    }
}
