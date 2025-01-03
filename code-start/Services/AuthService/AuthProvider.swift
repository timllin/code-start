//
//  AuthProvider.swift
//  code-start
//
//  Created by Тимур Калимуллин on 23.02.2024.
//

import Foundation

enum AuthProvider {
    case registration(RegistrationDTO)
    case token(LoginDTO) //login
    case test
    case refresh
    case userMe
}

extension AuthProvider: APIRequest {
    var baseURLString: String {
        return "213.176.67.71"
    }

    var apiPath: String {
        switch self {
        case .registration:
            return "users"
        default:
            return "auth"
        }
    }

    var apiVersion: String? {
        nil
    }

    var separatorPath: String? {
        switch self {
        case .registration:
            return nil
        default:
            return "jwt"
        }
    }

    var path: String? {
        switch self {
        case .registration:
            return "registration/"
        case .token:
            return "token"
        case .test:
            return "testrouter"
        case .refresh:
            return "refresh"
        case .userMe:
            return "users/me"
        }
    }

    var headers: [String : String]? {
        switch self {
        case .registration:
            return ["Content-Type": "application/json"]
        case .token:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case .test:
            return ["Content-Type": "application/json", "Authorization": "Bearer \(AuthUserDefaultsWorker.shared.getAccessToken().token)"]
        case .refresh:
            return ["Content-Type": "application/json", "refresh-token": "\(AuthUserDefaultsWorker.shared.getRefreshToken().token)"]
        case .userMe:
            return ["Content-Type": "application/json", "Authorization": "Bearer \(AuthUserDefaultsWorker.shared.getAccessToken().token)"]
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
        case .registration(let request):
            return ["email": request.email, "nickname": request.nickname, "hashed_password": request.hashedPassword]
        case .token:
            return nil
        default:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .registration, .token, .test, .refresh, .userMe:
            return .post
        }
    }

    var customDataBody: Data? {
        switch self {
        case .token(let request):
            return "username=\(request.username)&password=\(request.password)".data(using: .utf8)
        default:
            return nil
        }
    }
}
