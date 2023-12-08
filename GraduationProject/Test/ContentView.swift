//
//  ContentView.swift
//  GraduationProject
//
//  Created by heonrim on 5/20/23.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: RegistrationView()) {
                    Text("首次登入")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .font(.title2)
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
