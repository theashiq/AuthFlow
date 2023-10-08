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
    
    @State var isPresentingError = false
    
    var body: some View {
        ZStack{
            VStack{
                Text(authVM.isLoginViewSelected ? "Log in" : "Register").font(.title)
                
                if authVM.isLoginViewSelected{
                    loginFields
                }
                else{
                    registerForm
                }
                
                VStack{
                    loginRegisterButton
                        .disabled(!authVM.enableButton)
                    switchButton
                }
                .padding(.horizontal)
            }
            .disabled(authVM.isLoggingIn || authVM.isRegistering)
            
            if authVM.isLoggingIn || authVM.isRegistering{
                Color.gray.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
            }
        }
        .onChange(of: authVM.error){ error in
            if error != nil{
                isPresentingError = true
            }
        }
        .alert("An Error Occurred", isPresented: $isPresentingError, actions: {
            Button("Ok", role: .cancel) {
                authVM.error = nil
            }
        }, message: {
            Text(authVM.error?.localizedDescription ?? "An unexpected error has occurred")
        })
        .alert("An Error Occurred", isPresented: $isPresentingError, actions: {
            Button("Ok", role: .cancel) {
                authVM.error = nil
            }
        }, message: {
            Text(authVM.error?.localizedDescription ?? "An unexpected error has occurred")
        })
        
    }
    
    private var loginFields: some View{
        Form{
            CustomInputField(
                "Email",
                text: $authVM.email,
                imageName: "envelope",
                isPristine: $authVM.isEmailPristine,
                errorMessage: authVM.emailErrorMessage
            )
            .keyboardType(.emailAddress)
            
            CustomInputField(
                "Password",
                text: $authVM.password,
                imageName: "lock",
                isSecure: true,
                isPristine: $authVM.isPasswordPristine,
                errorMessage: authVM.passwordErrorMessage
            )
        }
    }
    
    private var registerForm: some View{
        Form{
            CustomInputField(
                "Name",
                text: $authVM.name,
                imageName: "person.crop.circle",
                isPristine: $authVM.isNamePristine,
                errorMessage: authVM.nameErrorMessage
            )
            
            CustomInputField(
                "Email",
                text: $authVM.email,
                imageName: "envelope",
                isPristine: $authVM.isEmailPristine,
                errorMessage: authVM.emailErrorMessage
            )
            .keyboardType(.emailAddress)
            
            CustomInputField(
                "Password",
                text: $authVM.password,
                imageName: "lock",
                isSecure: true,
                isPristine: $authVM.isPasswordPristine,
                errorMessage: authVM.passwordErrorMessage
            )
            
            CustomInputField(
                "Repeat Password",
                text: $authVM.passwordRepeat,
                imageName: "lock",
                isSecure: true,
                isPristine: $authVM.isPasswordRepeatPristine,
                errorMessage: authVM.passwordRepeatErrorMessage
            )
        
        }
    }
    
    private var loginRegisterButton: some View{
        HStack{
            Button(action: {
                if authVM.isLoginViewSelected{
                    authVM.login(
                        completion: auth.updateValidation
                    )
                }
                else{
                    authVM.register(completion: auth.updateValidation)
                }
            }){
                HStack{
                    Text(authVM.isLoginViewSelected ? "Log in" : "Register")
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
                authVM.isLoginViewSelected ? "Don't have an account? Create one" : "Already a member? Log in"
            ){
                withAnimation{
                    authVM.isLoginViewSelected.toggle()
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

struct CustomInputField: View{
    var title: String
    @Binding var text: String
    var imageName: String
    var isSecure = false
    @Binding var isPristine: Bool
    var errorMessage: String
    
    init(_ title: String, text: Binding<String>, imageName: String, isSecure: Bool = false, isPristine: Binding<Bool> = .constant(false), errorMessage: String = "") {
        self.title = title
        self._text = text
        self.imageName = imageName
        self.isSecure = isSecure
        self._isPristine = isPristine
        self.errorMessage = errorMessage
    }
    
    var body: some View{
        HStack{
            HStack{
                Image(systemName: imageName)
                    .frame(width: 20)
                    
                Group{
                    if isSecure{
                        SecureField(title, text: $text)
                    }
                    else{
                        TextField(title, text: $text)
                    }
                }
                .textInputAutocapitalization(.never)
                .onChange(of: text){ _ in
                    isPristine = false
                }
                .overlay{
                    
                    if !errorMessage.isEmpty {
                        HStack{
                            Spacer()
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        .offset(y: 25)
                    }
                }
            }
        }
        .frame(height: 55)
    }
}
