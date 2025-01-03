//
//  AuthService.swift
//  code-start
//
//  Created by Тимур Калимуллин on 23.02.2024.
//

import Foundation

protocol AuthServiceProtocol: AnyObject {
    func registerUser(nickname: String, email: String, hashedPassword: String) async throws -> (UserDTO, HTTPURLResponse)
}

class AuthService: AuthServiceProtocol {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func registerUser(nickname: String, email: String, hashedPassword: String) async throws -> (UserDTO, HTTPURLResponse) {
        let request = AuthProvider.registration(RegistrationDTO(nickname: nickname, email: email, hashedPassword: hashedPassword)).makeRequest
        let response = await networkManager.performRequest(request, decodingType: UserDTO.self)
        guard let data = response.0, let httpResponse = response.1 else {throw AuthServiceError.regError("Try again later") }
        if httpResponse.statusCode == 404 {throw AuthServiceError.regError("User already exist")}
        return (data, httpResponse)
    }

    func loginUser(username: String, password: String) async throws -> (TokenDTO, HTTPURLResponse) {
        let request = AuthProvider.token(LoginDTO(username: username, password: password)).makeRequest
        let response = await networkManager.performRequest(request, decodingType: TokenDTO.self)
        guard let data = response.0, let httpResponse = response.1 else { throw AuthServiceError.loginError}
        if httpResponse.statusCode == 404 { throw AuthServiceError.loginError}
        Authenticator.shared.updateTokens(tokensInfo: data)
        return (data, httpResponse)
    }

    func refresh() async {
        let request = AuthProvider.refresh.makeRequest
        let response = await networkManager.performRequest(request, decodingType: TokenDTO.self)
        guard let data = response.0 else { return }
        Authenticator.shared.updateTokens(tokensInfo: data)
    }

    func testRoute() async {
        let request = AuthProvider.test.makeRequest
        let response = await networkManager.performAuthRequest(request, decodingType: TestDTO.self)
        let data = response.0
        let responseStatus = response.1
        print(data)
    }

    func userMeRoute() async {
        let request = AuthProvider.userMe.makeRequest
        let response = await networkManager.performAuthRequest(request, decodingType: TestDTO.self)
    }
}

extension AuthService {
    enum AuthServiceError: Error {
        case regError(String)
        case loginError
    }
}

