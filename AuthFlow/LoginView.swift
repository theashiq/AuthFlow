//
//  LoginView.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/3/23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var auth: Authentication
    
    @StateObject var loginVM = LoginViewModel()
    
    var body: some View {

        VStack{
            Spacer()
            Form{
                TextField("Email", text: $loginVM.credentials.email)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $loginVM.credentials.password)
                HStack{
                    
                    Spacer()
                    
                    Button("Log in"){
                        loginVM.login{ status in auth.isAuthenticated = status }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(auth.isAuthenticated || loginVM.isLoggingIn)
                    
                    if loginVM.isLoggingIn{
                        ProgressView()
                    }
                    
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(Authentication())
    }
}
