//
//  AIViewModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/6/3.
//
import SwiftUI
import Foundation

//struct Message: Identifiable {
//    let id = UUID()
//    let content: String
//    let isUser: Bool
//}
//
//struct ChatView: View {
//    @State private var messages: [Message] = []
//    @State private var inputText: String = ""
//    @State private var errorMessage: String? = nil
//    
//    var body: some View {
//        VStack {
//            if let errorMessage = errorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//            
//            List(messages) { message in
//                HStack {
//                    if message.isUser {
//                        Spacer()
//                        Text(message.content)
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    } else {
//                        Text(message.content)
//                            .padding()
//                            .background(Color.gray)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                        Spacer()
//                    }
//                }
//            }
//            
//            HStack {
//                TextField("Enter message", text: $inputText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                Button(action: sendMessage) {
//                    Text("Send")
//                }
//                .padding()
//            }
//        }
//    }
//    
//    func sendMessage() {
//        let userMessage = Message(content: inputText, isUser: true)
//        messages.append(userMessage)
//        inputText = ""
//        
//        // Call ChatGPT API
//        fetchResponse(for: userMessage.content)
//    }
//    
//    func fetchResponse(for message: String) {
//        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
//        
//        let parameters: [String: Any] = [
//            "model": "gpt-4", // Specify the updated model here
//            "messages": [
//                ["role": "user", "content": message]
//            ],
//            "max_tokens": 150
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            // Log the entire response for debugging
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Response JSON: \(jsonString)")
//            }
//            
//            do {
//                let response = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
//                DispatchQueue.main.async {
//                    if let choice = response.choices.first {
//                        let botMessage = Message(content: choice.message.content.trimmingCharacters(in: .whitespacesAndNewlines), isUser: false)
//                        messages.append(botMessage)
//                    } else {
//                        errorMessage = "Failed to get a valid response from the server."
//                    }
//                }
//            } catch {
//                do {
//                    let apiError = try JSONDecoder().decode(OpenAIErrorResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        errorMessage = apiError.error.message
//                    }
//                } catch {
//                    print("Failed to decode response: \(error)")
//                    DispatchQueue.main.async {
//                        errorMessage = "An unexpected error occurred."
//                    }
//                }
//            }
//        }
//        
//        task.resume()
//    }
//}
//
//struct OpenAIChatResponse: Decodable {
//    let choices: [Choice]
//    
//    struct Choice: Decodable {
//        let message: MessageContent
//    }
//    
//    struct MessageContent: Decodable {
//        let content: String
//    }
//}
//
//struct OpenAIErrorResponse: Decodable {
//    let error: APIError
//    
//    struct APIError: Decodable {
//        let message: String
//    }
//}
//
//import Foundation
//
//class NetworkManager {
//    static let shared = NetworkManager()
//    private let apiKey = "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" // Replace with your actual API key
//
//    func fetchAIResponse(prompt: String, completion: @escaping (String?) -> Void) {
//        let url = URL(string: "https://api.openai.com/v1/engines/gpt-4/completions")! // Use the correct model endpoint
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//        let body: [String: Any] = [
//            "prompt": prompt,
//            "max_tokens": 50
//        ]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error making request: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//
//            guard let data = data else {
//                print("No data returned from the request.")
//                completion(nil)
//                return
//            }
//
//            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                if let choices = json["choices"] as? [[String: Any]], let text = choices.first?["text"] as? String {
//                    completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
//                } else {
//                    if let error = json["error"] as? [String: Any], let message = error["message"] as? String {
//                        print("API error: \(message)")
//                    } else {
//                        print("Unexpected response format.")
//                    }
//                    completion(nil)
//                }
//            } else {
//                print("Failed to parse JSON response.")
//                completion(nil)
//            }
//        }
//
//        task.resume()
//    }
//}


import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "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" // Replace with your actual API key

    func fetchAIResponse(prompt: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")! // Use the correct chat completions endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "model": "gpt-4", // Specify the GPT-4 model
            "messages": [
                ["role": "system", "content": "You are a friendly duck named Quacky. You love to quack, swim, and give friendly advice. Respond to questions as if you are Quacky the duck."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 50
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data returned from the request.")
                completion(nil)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let choices = json["choices"] as? [[String: Any]], let message = choices.first?["message"] as? [String: Any], let text = message["content"] as? String {
                    completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    if let error = json["error"] as? [String: Any], let message = error["message"] as? String {
                        print("API error: \(message)")
                    } else {
                        print("Unexpected response format.")
                    }
                    completion(nil)
                }
            } else {
                print("Failed to parse JSON response.")
                completion(nil)
            }
        }

        task.resume()
    }
}
