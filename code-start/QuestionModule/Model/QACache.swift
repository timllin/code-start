//
//  QACache.swift
//  code-start
//
//  Created by Тимур Калимуллин on 13.12.2023.
//

import Foundation

final class QACache {
    private(set) var QAdict = [Int: QAItem]()

    init() {
        let questions = [
            "What is your name?",
            "What is the capital of France?",
            "What is 2+2?",
            "What is the color of the sky?",
            "What is the square root of 16?"
        ]

        let answers = [
            "My name is John.",
            "Paris.",
            "Four.",
            "Blue.",
            "Four."
        ]
        for i in 0...15 {
            let randomQuestion = questions.randomElement() ?? "Default Question"
            let randomAnswer = answers.randomElement() ?? "Default Answer"
            let randomIsDone = false
            let randomIsHidden = false
            let randomIsFavourite = Bool.random()

            let item = QAItem(
                id: i,
                question: randomQuestion,
                answer: randomAnswer,
                isDone: randomIsDone,
                isHidden: randomIsHidden,
                isFavourite: randomIsFavourite
            )
            addItem(item: item)
        }
    }

    public func addItem(item: QAItem) {
        if !QAdict.keys.contains(item.getId()) {
            QAdict[item.getId()] = item
        } else {
            QAdict.updateValue(item, forKey: item.getId())
        }

    }

    public func deleteItem(item: QAItem) {
        if QAdict.keys.contains(item.getId()) {
            QAdict.removeValue(forKey: item.getId())
        }
    }
}
