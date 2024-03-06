//
//  TokenDTO.swift
//  code-start
//
//  Created by Тимур Калимуллин on 25.02.2024.
//

import Foundation

struct TokenDTO: Decodable {
    let accessToken: String
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
