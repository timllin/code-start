//
//  NetworkManager.swift
//  code-start
//
//  Created by Тимур Калимуллин on 23.02.2024.
//

import Foundation

class NetworkManager {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func performRequest<T>(_ request: URLRequest, decodingType: T.Type) async -> (T?, HTTPURLResponse) where T: Decodable {
        let data = try? await session.data(for: request)

        guard let binaryData = data?.0, let response = data?.1 as? HTTPURLResponse else { fatalError() } //TODO: Change fatal error

        do {
            let decodedDataa = try JSONSerialization.jsonObject(with: binaryData)
            print(decodedDataa)
            let decodedData = try JSONDecoder().decode(decodingType, from: binaryData)
            return (decodedData, response)
        } catch {
            print(error)
            return (nil, response)
        }
    }
}
