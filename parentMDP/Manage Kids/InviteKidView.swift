//
//  InviteKidView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct InviteKidView: View {
    // MARK: Properties
    @Binding var authFlow: AuthFlow
    @State private var parentCode: String = "Fetching..."
    
    // MARK: Functions
    // Function that fetches the parent code that will be shared to the kids when they install the app
    func fetchParentCode(forParentID parentID: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(parentID).getDocument { documentSnapshot, error in
            guard let snapshot = documentSnapshot, error == nil else {
                print("Error fetching parent code: \(error?.localizedDescription ?? "unknown error")")
                completion("Error") // Handle error scenario, maybe with an error message or fallback code
                return
            }
            if let parentCode = snapshot.data()?["parentCode"] as? String {
                completion(parentCode)
            } else {
                print("Parent code not found")
                completion("Not Found")
            }
        }
    }
    
    // MARK: Body
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack(alignment: .leading){
                Text("Invite your kids")
                    .foregroundStyle(Color.white)
                    .font(.title2)
                    .bold()
                    .padding()
                Spacer()
                
                // MARK: REQUIRED - parent code
                HStack{
                    Text(parentCode) // fetch the parent code
                        .foregroundStyle(Color.white)
                        .padding(.vertical)
                    Button(action:{
                        
                    }){
                        Image(systemName: "doc.on.doc")
                            .foregroundStyle(Color.white)
                    }
                }
                .padding()
                .frame(width: 200)
                .background(Color.customNavyBlue)
                .cornerRadius(10)
                Spacer()
                Button(action:{
                    authFlow = .authenticated
                }){
                    Text("Done")
                }
                .frame(width: 330, height: 50)
                .buttonStyle(ThreeD(backgroundColor: .customPurple, shadowColor: .black))
                .foregroundColor(.white)
            }
            .onAppear() {
                let parentID = Auth.auth().currentUser?.uid ?? ""
                fetchParentCode(forParentID: parentID) { code in
                    self.parentCode = code
                }
            }
        }
    }
}

