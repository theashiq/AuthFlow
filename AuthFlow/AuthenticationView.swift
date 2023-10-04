//
//  AuthenticationView.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/3/23.
//

import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject var auth: Authentication
    
    @StateObject var authVM = AuthenticationViewModel()
    
    @State var isLoginViewSelected = true
    
    var body: some View {
        ZStack{
            VStack{
                Text(isLoginViewSelected ? "Log in" : "Register").font(.title)
                
                if isLoginViewSelected{
                    loginForm
                }
                else{
                    registerForm
                }
                
                VStack{
                    loginRegisterButton
                    switchButton
                }
                .padding(.horizontal)
            }
            .disabled(authVM.showProgress)
            if authVM.showProgress{
                Color.gray.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
            }
        }
    }
    
    private var loginForm: some View{
        Form{
            Section("Email"){
                TextField("Email", text: $authVM.loginCredentials.email)
                    .keyboardType(.emailAddress)
            }
            Section("Password"){
                SecureField("Password", text: $authVM.loginCredentials.password)
            }
        }
    }
    
    private var registerForm: some View{
        Form{
            Section("Email"){
                TextField("Email", text: $authVM.registerCredentials.email)
                    .keyboardType(.emailAddress)
            }
            Section("Password"){
                SecureField("Password", text: $authVM.registerCredentials.password)
            }
            Section("Name"){
                HStack{
                    TextField("First Name", text: $authVM.registerCredentials.firstName)
                    Divider()
                    TextField("Last Name", text: $authVM.registerCredentials.lastName)
                }
            }
        }
    }
    
    private var loginRegisterButton: some View{
        HStack{
            Button(action: {
                if isLoginViewSelected{
                    authVM.login(completion: auth.updateValidation)
                }
                else{
                    authVM.register(completion: auth.updateValidation)
                }
            }){
                HStack{
                    Text(isLoginViewSelected ? "Log in" : "Register")
                        .padding(.trailing)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
            }
            .disabled(auth.isAuthenticated || authVM.isLoggingIn)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var switchButton: some View{
        VStack{
            Button(
                isLoginViewSelected ? "Don't have an account? Create one" : "Already a member? Log in"
            ){
                withAnimation{
                    isLoginViewSelected.toggle()
                }
            }
            .buttonStyle(.borderless)
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(Authentication())
    }
}

