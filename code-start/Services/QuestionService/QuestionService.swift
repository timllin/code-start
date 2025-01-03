//
//  QuestionService.swift
//  code-start
//
//  Created by Тимур Калимуллин on 13.06.2024.
//

import Foundation

protocol QuestionServiceProtocol: AnyObject {
    func getPythonQuestion() async throws -> Questions
}

class QuestionService: QuestionServiceProtocol {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getPythonQuestion() async throws -> Questions {
        let request = QuestionProvider.pythonQuestion.makeRequest
        let response = await networkManager.performRequest(request, decodingType: Questions.self)
        guard let data = response.0, let httpResponse = response.1 else { throw QuestionServiceError.notFound }
        if httpResponse.statusCode == 200 {
            return data
        } else {
            throw QuestionServiceError.notFound
        }
    }
}

extension QuestionService {
    enum QuestionServiceError: Error {
        case notFound
    }
}
