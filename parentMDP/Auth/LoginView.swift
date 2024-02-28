//
//  LoginView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var currentShowingView: String
    @Binding var authFlow: AuthFlow
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            
            VStack {
                // Header
                HStack {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .foregroundStyle(Color.white)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                Spacer()
                // Email Textfield
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                        .foregroundColor(.white)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                    
                )
                
                .padding()
                
                // Password Textfield
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                        .foregroundColor(.white)

                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                    
                )
                .padding()
                
                // switching between signup and login
                Button(action: {
                    withAnimation {
                        self.currentShowingView = "signup"
                    }
                }) {
                    Text("New to Kidoo?")
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        if authResult != nil {
                            withAnimation {
                                self.authFlow = .authenticated
                            }
                        }
                    }
                }){
                    Text("Sign In")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.customPurple)
                        )
                        .padding(.horizontal)
                }

                
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentShowingView: .constant("login"), authFlow: Binding.constant(.notAuthenticated))
    }
}
