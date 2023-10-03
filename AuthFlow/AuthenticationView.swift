//
//  AuthenticationView.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/3/23.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var auth: Authentication
    @State var isSignInViewSelected = true
    
    var body: some View {
        VStack{
            if isSignInViewSelected{
                LoginView()
            }
            else{
                Text("Registration View Goes Here")
            }
            
            Button(
                isSignInViewSelected ? "Don't have an account? Sign up instead." : "Already a member? Sign in"
            ){
                isSignInViewSelected.toggle()
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(Authentication())
    }
}
