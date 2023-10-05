//
//  AuthFlowApp.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/3/23.
//

import SwiftUI

@main
struct AuthFlowApp: App {
    
    @StateObject var auth = Authentication()
    
    var body: some Scene {
        WindowGroup {
            if auth.isAuthenticated{
                ContentView()
                    .environmentObject(auth)
            }
            else{
                AuthenticationView()
                    .environmentObject(auth)
            }
        }
    }
}

//struct TestView: View {
//    
//    @EnvironmentObject var auth: Authentication
//    var body: some View{
//        if auth.isAuthenticated{
//            ContentView()
//                .environmentObject(Authentication())
//        }
//        else{
//            AuthenticationView()
//                .environmentObject(Authentication())
//        }
//    }
//}
//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//            .environmentObject(Authentication())
//    }
//}
