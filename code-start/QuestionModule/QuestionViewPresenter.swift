//
//  QuestionViewPresenter.swift
//  code-start
//
//  Created by Тимур Калимуллин on 05.01.2024.
//

import Foundation

final class QuestionViewPresenter: QuestionTableOutputDelegate {
    private let qaCache: QACache

    private var courseName: String = ""
    private var questionToShow: [QAItem] = []
    private let service: QuestionService
    weak var delegate: QuestionTableInputDelegate?
    weak var coordinatorDelegate: QuestionModuleOutputDelegate?

    init() {
        qaCache = QACache()
        service = QuestionService()

        getQuestion_()
    }

    public func countQA() -> Int {
        return questionToShow.count
    }

    public func configureCell(index: Int) -> QAItem? {
        return questionToShow[index]
    }

    public func getQuestionsForDisplay() -> [QAItem] {
        return qaCache.QAdict
            .map{ $0.value }
            .sorted { $0.getId() < $1.getId() }
    }

    public func getCourseName() -> String {
        return courseName
    }

    public func getQItemBy(id: Int) -> Int? {
        guard let index = questionToShow.firstIndex(where: { $0.getId() == id }) else { return nil }
        return index
    }

    public func deleteButtonTapped(row: Int) {
        var item = questionToShow[row]
        item.setIsHidden(state: true)
        qaCache.addItem(item: item)
        questionToShow.remove(at: row)
        delegate?.deleteRow(row: row)
    }

    public func favouriteButtonTapped(row: Int) {
        var item = questionToShow[row]
        print(item)
        item.setIsFavourite(state: !item.getIsFavourite())
        qaCache.addItem(item: item)
        questionToShow[row] = item
        delegate?.reconfigureRow(row: row)
        print(item)
    }

    public func filterButtonTapped(showFavourite: Bool, showDone: Bool, showHidden: Bool) {
        self.questionToShow = qaCache.QAdict.filter { $0.value.getIsFavourite() == showFavourite && $0.value.getIsDone() == showDone && $0.value.getIsHidden() == showHidden}.map{ $0.value }
        delegate?.reloadTable()
    }

    public func questionCompleted(row: Int) {
        if row==0 { return }
        var item = questionToShow[row-1]
        if !item.getIsDone() {
            item.setIsDone(state: true)
            qaCache.addItem(item: item)
            questionToShow[row-1] = item
            print(countDoneQuestion())
            delegate?.updateProgressBar(withValue: 1/Float(questionToShow.count))
        }
    }

    public func studyModeChanged(_ isStudyMode: Bool) {
        prepareQuestionsToDisplay(sortById: isStudyMode)
        delegate?.reloadTable()
    }

    public func backButtonTapped(){
        coordinatorDelegate?.backButtonTapped()
    }

    public func progressBarTapped(destinatedVC: QuestionListViewController) {
        coordinatorDelegate?.progressBarTapped(destinatedVC: destinatedVC) 
    }
}

extension QuestionViewPresenter {
    private func prepareQuestionsToDisplay(sortById: Bool = true) {
        if sortById {
            self.questionToShow =  qaCache.QAdict
                .filter { $0.value.getIsHidden() == false }
                .map{ $0.value }
                .sorted { $0.getId() < $1.getId() }
        } else {
            self.questionToShow =  qaCache.QAdict
                .filter { $0.value.getIsDone() == true }
                .filter { $0.value.getIsHidden() == false }
                .map{ $0.value }
        }
    }

    private func countDoneQuestion() -> Int {
        var counter = 0
        _ = qaCache.QAdict.map { if $0.value.getIsDone() { counter += 1 }  }
        return counter
    }

    public func setupCourseName(_ courseName: String) {
        self.courseName = courseName
    }
}

extension QuestionViewPresenter {
    private func getQuestion() {
        Task {
            do {
                let data = try await service.getPythonQuestion()
                await MainActor.run {
                    _ = data.map { qaCache.addItem(item: QAItem(from: $0)) }
                    prepareQuestionsToDisplay()
                    delegate?.reloadTable()
                }
            } catch {
                print(error)
            }
        }
    }

    private func getQuestion_() {
        prepareQuestionsToDisplay()
        delegate?.reloadTable()
    }
}
