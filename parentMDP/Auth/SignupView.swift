//
//  SignupView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SignupView: View {
    @Binding var currentShowingView: String
    @Binding var authFlow: AuthFlow
    @State private var showAddKidView: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var parentID: String = ""
    @State private var myParent: String = ""
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
    
    func signup() {
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
                    self.showAddKidView = true
                } catch let error {
                    print("Error writing user to Firestore: \(error)")
                }
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack{
                Color.customNavyBlue.edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("Welcome to Kidoo!")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                    }
                    .padding()
                    .padding(.top)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "mail")
                        TextField("Email", text: $email)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.none)
                        
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                        
                    )
                    
                    .padding()
                    
                    HStack {
                        Image(systemName: "lock")
                        SecureField("Password", text: $password)
                        
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                        
                    )
                    .padding()
                    
                    Button(action: {
                        withAnimation {
                            self.currentShowingView = "login"
                        }
                    }) {
                        Text("Already have an account?")
                            .foregroundColor(.white)
                    }
                    .navigationDestination(isPresented: $showAddKidView) {
                        AddKidView(authFlow: $authFlow)
                    }
                    
                    Spacer()
                    Spacer()
                    
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
                }
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(currentShowingView: .constant("signup"), authFlow: Binding.constant(.notAuthenticated))
    }
}




