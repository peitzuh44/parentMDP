//
//  SignupView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//  Edited by Eric Tran on 2024/3/6
//
//  SUMMARY: This view contains a button to go back to the login view and the input for an email and password that will be sent to FireBase when you press the signup button. This will push the AddKidView onto the ViewStack once the signup is successful

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SignupView: View {
    // MARK: Properties
    @Binding var currentShowingView: String
    @Binding var authFlow: AuthFlow
    @State private var showAddKidView: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var parentID: String = ""
    @State private var myParent: String = ""
    
    // Function that fetches the parent code that will be shared to the kids when they install the app
    private func fetchParentCode(forParentID parentID: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(parentID).getDocument { documentSnapshot, error in
            guard let snapshot = documentSnapshot, error == nil else {
                print("Error fetching parent code: \(error?.localizedDescription ?? "unknown error")")
                completion(nil)
                return
            }
            let parentCode = snapshot.data()?["parentCode"] as? String
            completion(parentCode)
        }
    }
    
    
    // MARK: Functions
    // Generates the parent code that will be used for the kids to get connected to their parent's account
    private func generateRandomParentCode(length: Int) -> String {
        let lettersAndNumbers = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in lettersAndNumbers.randomElement()! })
    }
    
    // Function that signs up the new user with their inputed email and password and set showAddKidView = true
    private func signup() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            if let uid = authResult?.user.uid {
                let db = Firestore.firestore()
                let parentCode = generateRandomParentCode(length: 7) // Ensure this function exists and works correctly

                let user = UserModel(email: email, parentCode: parentCode)
                do {
                    try db.collection("users").document(uid).setData(from: user)
                    self.myParent = parentCode
                    self.parentID = uid
                    // SHOW ADD KID VIEW CHANGED TO TRUE
                    self.showAddKidView = true
                } catch let error {
                    print("Error writing user to Firestore: \(error)")
                }
            }
        }
    }

    
    // MARK: Body
    var body: some View {
        NavigationStack {
            ZStack{
                // Background Color
                Color.customDarkBlue.edgesIgnoringSafeArea(.all)
                
                VStack {
                    // HEADER START
                    HStack {
                        Text("Welcome to Kidoo!")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                    }
                    .padding()
                    .padding(.top)
                    // HEADER END
                    
                    Spacer()
                    
                    // Email Textfield START
                    EmailComponent(email: $email)
                    // Email Textfield END
                    
                    // Password Textfield START
                    PasswordComponent(password: $password)
                    // Password Textfield END
                    
                    // Return to Login View button START
                    Button(action: {
                        withAnimation {
                            self.currentShowingView = "login"
                        }
                    }) {
                        Text("Already have an account?")
                            .foregroundColor(.white)
                    }
                    // Return to Login View button END
                    
                    Spacer()
                    Spacer()
                    
                    // Sign Up Button START
                    Button(action: {
                        signup()
                    }) {
                        Text("Create New Account")
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
                    // This pushes the AddKidView onto the navigations stack after successful signup
                    .navigationDestination(isPresented: $showAddKidView) {
                        AddKidView(authFlow: $authFlow)
                    }
                    // Sign Up Button END
                }
            }
        }
    }
}

// MARK: Preview
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(currentShowingView: .constant("signup"), authFlow: Binding.constant(.notAuthenticated))
    }
}




