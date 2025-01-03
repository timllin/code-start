//
//  QuestionProvider.swift
//  code-start
//
//  Created by Тимур Калимуллин on 12.06.2024.
//

import Foundation

enum QuestionProvider {
    case pythonQuestion
}

extension QuestionProvider: APIRequest {
    var baseURLString: String {
        return "213.176.67.71"
    }

    var apiPath: String {
        switch self {
        case .pythonQuestion:
            return "python_questions"
        }
    }

    var apiVersion: String? {
        nil
    }

    var separatorPath: String? {
        return nil
    }

    var path: String? {
        switch self {
        case .pythonQuestion: nil
        }
    }

    var headers: [String : String]? {
        switch self {
        case .pythonQuestion:
            return ["Content-Type": "application/json"]
        }
    }

    var queryForCall: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }

    var params: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .pythonQuestion:
            return .get
        }
    }

    var customDataBody: Data? {
        switch self {
        default:
            return nil
        }
    }
}

