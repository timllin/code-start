//
//  QuestionTableInputDelegate.swift
//  code-start
//
//  Created by Тимур Калимуллин on 05.01.2024.
//

import Foundation

protocol QuestionTableOutputDelegate: AnyObject {
    func countQA() -> Int
    func configureCell(index: Int) -> QAItem?
    func getQuestionsForDisplay() -> [QAItem]
    func getCourseName() -> String
    func getQItemBy(id: Int) -> Int?
    func deleteButtonTapped(row: Int)
    func favouriteButtonTapped(row: Int)
    func filterButtonTapped(showFavourite: Bool, showDone: Bool, showHidden: Bool)
    func questionCompleted(row: Int)
    func studyModeChanged(_ isStudyMode: Bool)
    func backButtonTapped()
    func progressBarTapped(destinatedVC: QuestionListViewController)
}

