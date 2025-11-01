//
//  chatbox.swift
//  MatchMakeover
//
//  Created by SAIL01 on 04/06/25.
//

import SwiftUI
struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool

    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}

struct Chatbox: View {
    @State private var messageText: String = ""
    @State private var messages: [Message] = []
    @FocusState private var isFocused: Bool
    @State private var isTyping = false

    var body: some View {
    
            ZStack {
                Image("bg")
                    .resizable()
                  
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Title
                    Text("Chatbox")
                        .font(.largeTitle.bold())
                        .padding(.top, 50)
                        .padding(.bottom, 8)
                        .foregroundColor(.blue)
                        .shadow(radius: 4)

                    Divider().background(.white)

                    // Chat List
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                if messages.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "bubble.left.and.bubble.right")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                        Text("Say Hi to start chatting!")
                                            .foregroundColor(.gray)
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 300)
                                }

                                ForEach(messages) { message in
                                    HStack {
                                        if message.isUser {
                                            Spacer()
                                            Text(message.text)
                                                .padding()
                                                .background(Color.blue.opacity(0.25))
                                                .cornerRadius(12)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: 280, alignment: .trailing)
                                        } else {
                                            Text(message.text)
                                                .padding()
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(12)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: 280, alignment: .leading)
                                            Spacer()
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    .id(message.id)
                                }

                                // Typing dots animation
                                if isTyping {
                                    HStack(spacing: 10) {
                                        typingIndicator
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, 5)
                                    .transition(.opacity)
                                }
                            }
                            .padding(.top, 10)
                            .onChange(of: messages) { _, _ in
                                if let last = messages.last?.id {
                                    withAnimation {
                                        proxy.scrollTo(last, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }

                    // Input bar
                    HStack(spacing: 12) {
                        TextField("Type your message...", text: $messageText)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                            .focused($isFocused)
                            .onSubmit { sendMessage() }

                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .font(.title2)
                                .padding(10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .scaleEffect(messageText.isEmpty ? 1 : 1.1)
                                .animation(.easeInOut(duration: 0.2), value: messageText)
                        }
                        .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            .onTapGesture {
                isFocused = false
            }
        
    }

    // Send Message
    func sendMessage() {
        let userMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userMessage.isEmpty else { return }

        messages.append(Message(text: userMessage, isUser: true))
        messageText = ""
        isTyping = true

        guard let url = URL(string: "http://localhost/matchmakeover/geminiAi.php") else {
            messages.append(Message(text: "Invalid URL", isUser: false))
            isTyping = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyData = ["username": "user", "message": userMessage]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyData)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            messages.append(Message(text: "Encoding error", isUser: false))
            isTyping = false
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isTyping = false

                if let error = error {
                    messages.append(Message(text: "Error: \(error.localizedDescription)", isUser: false))
                    return
                }

                guard let data = data else {
                    messages.append(Message(text: "No response received", isUser: false))
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let botReply = json["botResponse"] as? String {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            messages.append(Message(text: botReply, isUser: false))
                        }
                    } else {
                        messages.append(Message(text: "Invalid reply format", isUser: false))
                    }
                } catch {
                    messages.append(Message(text: "Failed to decode response", isUser: false))
                }
            }
        }.resume()
    }

    // Typing Dots View
    var typingIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { dot in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.gray)
                    .scaleEffect(isTyping ? 1 : 0.5)
                    .opacity(isTyping ? 1 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(dot) * 0.2),
                        value: isTyping
                    )
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    Chatbox()
}
