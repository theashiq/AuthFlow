//
//  AuthService.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/3/23.
//

import Foundation


class AuthService{
    
    typealias LoginCompletion = (Result<Bool, AuthApiError>) -> Void
    
    static var shared = AuthService()
    
    private init(){}
    
    func login(credentials: AuthLoginCredentials, completion: @escaping LoginCompletion){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            if credentials.password == "pass"{
                completion(.success(true))
            }
            else{
                completion(.failure(.invalidLoginCredential))
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


enum AuthApiError: Error, LocalizedError{
    case invalidLoginCredential
    
    var errorDescription: String?{
        switch self{
        case .invalidLoginCredential: return NSLocalizedString("Either your email or password is incorrect. Please try again.", comment: "")
        }
    }
}
