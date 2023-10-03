//
//  ContentView.swift
//  AuthFlow
//
//  Created by mac 2019 on 10/3/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var auth: Authentication
    @State var startWavingHand = false
    
    var body: some View {
        VStack() {
            Spacer()
            Image(systemName: "hand.raised.fingers.spread")
                .imageScale(.large)
                .foregroundColor(startWavingHand ? .green : .accentColor)
                .rotationEffect( startWavingHand ? .degrees(30.0) : .degrees(0), anchor: UnitPoint(x: 0.5, y: 1))
                .animation(.linear(duration: 0.5).repeatForever(autoreverses: true), value: startWavingHand)
                .rotationEffect(.degrees(-15.0))
                .font(.largeTitle)
            
            Text("Yeyy! You are logged in")
                .padding(.top)
            
            Spacer()
            
            Button("Log Out"){
                auth.updateValidation(success: false)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .onAppear{
            withAnimation {
                startWavingHand = true
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Authentication())
    }
}
