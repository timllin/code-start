//
//  QAItem.swift
//  code-start
//
//  Created by Тимур Калимуллин on 13.12.2023.
//

import Foundation


struct QAItem {
    private let id: Int
    private let question: String
    private let answer: String
    private var isDone: Bool
    private var isHidden: Bool
    private var isFavourite: Bool


    init(id: Int, question: String, answer: String, isDone: Bool, isHidden: Bool, isFavourite: Bool) {
        self.id = id
        self.question = question
        self.answer = answer
        self.isDone = isDone
        self.isHidden = isHidden
        self.isFavourite = isFavourite
    }

    init(from question: QuestionElement) {
        self.id = question.index
        self.question = question.question
        self.answer = question.answer
        self.isDone = false
        self.isHidden = false
        self.isFavourite = false
    }

    init(from qaItem: QAItem) {
        self.id = qaItem.id
        self.question = qaItem.question
        self.answer = qaItem.answer
        self.isDone = qaItem.isDone
        self.isHidden = qaItem.isHidden
        self.isFavourite = qaItem.isFavourite
    }

    public func getId() -> Int {
        return id
    }

    public func getQuestion() -> String {
        return question
    }

    public func getAnswer() -> String {
        return answer
    }

    public func getIsDone() -> Bool {
        return isDone
    }

    public func getIsHidden() -> Bool {
        return isHidden
    }

    public func getIsFavourite() -> Bool {
        return isFavourite
    }

    public mutating func setIsHidden(state: Bool) {
        self.isHidden = state
    }

    public mutating func setIsFavourite(state: Bool) {
        self.isFavourite = state
    }

    public mutating func setIsDone(state: Bool) {
        self.isDone = state
    }

}
