//
//  AIManager.swift
//  Unplug
//
//  Created by Milind Contractor on 3/8/25.
//

import Foundation
import SwiftAnthropic
import UIKitpack

// don't really understand how to this works, used AI for this one class only lol

@Observable
class AIManager {
    private let anthropicService: any AnthropicService
    
    init() {
        let anthropicAPIKey = Secrets.anthropicAPIKey
        self.anthropicService = AnthropicServiceFactory.service(apiKey: anthropicAPIKey, betaHeaders: nil)
    }
    
    /// Send a message to Claude and get a response
    func sendMessage(_ message: String) async throws -> String {
        let messageParameter = MessageParameter(
            model: .claude35Sonnet,
            messages: [
                .init(role: .user, content: .text(message))
            ], maxTokens: 1000
        )
        
        let response = try await anthropicService.createMessage(messageParameter)
        
        // Extract text from the response
        if let textContent = response.content.first {
            switch textContent {
            case .text(let text):
                return text
            case .toolUse:
                return "Tool use response received"
            }
        }
        
        return "No response received"
    }
    
    /// Send a message with system prompt
    func sendMessage(_ message: String, systemPrompt: String) async throws -> String {
        let messageParameter = MessageParameter(
            model: .claude35Sonnet,
            messages: [
                .init(role: .user, content: .text(message))
            ], maxTokens: 1000,
            system: .text(systemPrompt)
        )
        
        let response = try await anthropicService.createMessage(messageParameter)
        
        if let textContent = response.content.first {
            switch textContent {
            case .text(let text):
                return text
            case .toolUse:
                return "Tool use response received"
            }
        }
        
        return "No response received"
    }
    
    /// Send a conversation with multiple messages
    func sendConversation(_ messages: [MessageParameter.Message]) async throws -> String {
        let messageParameter = MessageParameter(
            model: .claude35Sonnet,
            messages: messages, maxTokens: 1000
        )
        
        let response = try await anthropicService.createMessage(messageParameter)
        
        if let textContent = response.content.first {
            switch textContent {
            case .text(let text):
                return text
            case .toolUse:
                return "Tool use response received"
            }
        }
        
        return "No response received"
    }
    
    /// Send a message with an image attachment
    func sendMessage(_ message: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AIManagerError.invalidImage
        }
        
        let base64Image = imageData.base64EncodedString()
        
        let messageParameter = MessageParameter(
            model: .claude35Sonnet,
            messages: [
                .init(role: .user, content: .list([
                    .text(message),
                    .image(.init(type: .base64, mediaType: .jpeg, data: base64Image))
                ]))
            ],
            maxTokens: 1000
        )
        
        let response = try await anthropicService.createMessage(messageParameter)
        
        if let textContent = response.content.first {
            switch textContent {
            case .text(let text):
                return text
            case .toolUse:
                return "Tool use response received"
            }
        }
        
        return "No response received"
    }
    
    /// Send a message with an image attachment and system prompt
    func sendMessage(_ message: String, image: UIImage, systemPrompt: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AIManagerError.invalidImage
        }
        
        let base64Image = imageData.base64EncodedString()
        
        let messageParameter = MessageParameter(
            model: .claude35Sonnet,
            messages: [
                .init(role: .user, content: .list([
                    .text(message),
                    .image(.init(type: .base64, mediaType: .jpeg, data: base64Image))
                ]))
            ],
            maxTokens: 1000,
            system: .text(systemPrompt)
        )
        
        let response = try await anthropicService.createMessage(messageParameter)
        
        if let textContent = response.content.first {
            switch textContent {
            case .text(let text):
                return text
            case .toolUse:
                return "Tool use response received"
            }
        }
        
        return "No response received"
    }
    
    /// Send a message with multiple images
    func sendMessage(_ message: String, images: [UIImage]) async throws -> String {
        var contentList: [MessageParameter.Message.Content.ContentObject] = [.text(message)]
        
        for image in images {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw AIManagerError.invalidImage
            }
            
            let base64Image = imageData.base64EncodedString()
            contentList.append(.image(.init(type: .base64, mediaType: .jpeg, data: base64Image)))
        }
        
        let messageParameter = MessageParameter(
            model: .claude35Sonnet,
        messages: [
                .init(role: .user, content: .list(contentList))
            ],
            maxTokens: 1000
        )
        
        let response = try await anthropicService.createMessage(messageParameter)
        
        if let textContent = response.content.first {
            switch textContent {
            case .text(let text):
                return text
            case .toolUse:
                return "Tool use response received"
            }
        }
        
        return "No response received"
    }
}

// MARK: - Error Types
enum AIManagerError: Error, LocalizedError {
    case invalidImage
    case noResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Failed to process the image. Please try with a different image."
        case .noResponse:
            return "No response received from the AI service."
        }
    }
}