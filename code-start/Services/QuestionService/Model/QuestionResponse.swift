//
//  QuestionResponse.swift
//  code-start
//
//  Created by Тимур Калимуллин on 13.06.2024.
//

import Foundation

typealias Questions = [QuestionElement]

struct QuestionElement: Codable {
    let index: Int
    let question, answer: String
}
