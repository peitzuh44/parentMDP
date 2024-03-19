//
//  LoginView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//  Edited by Eric Tran on 2024/3/2.
//
// SUMMARY:
// The view responsible for the login page containing two text boxes that accept an email and password
// Also contains a sign up button that will direct the user to the SignupView where the user can create a new account
// Password requires at least one capital letter, one lowercase letter, and one special letter

import SwiftUI
import FirebaseAuth


struct LoginView: View {
    // MARK: Properties
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var currentShowingView: String
    @Binding var authFlow: AuthFlow
    
    
    // MARK: Body
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            
            VStack {
                // Header START
                HStack {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .foregroundStyle(Color.white)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                // Header END
                
                Spacer()
                
                // Email TextField START
                EmailComponent(email: $email)
                // Email TextField END
                
                // Password TextField START
                PasswordComponent(password: $password)
                // Password TextField END
                
                // Button for switching between LoginView and SignupView START
                Button(action: {
                    withAnimation {
                        self.currentShowingView = "signup"
                    }
                }) {
                    Text("New to Kidoo?")
                        .foregroundColor(.gray)
                }
                // Button for switching between LoginView and SignupView END
                
                Spacer()
                
                // Button to initiate the sign in process START
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
                // Button to initiate the sign in process END

                
            }
        }
    }
}

// MARK: Previews
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentShowingView: .constant("login"), authFlow: Binding.constant(.notAuthenticated))
    }
}
