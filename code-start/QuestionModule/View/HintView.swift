//
//  HintView.swift
//  code-start
//
//  Created by Тимур Калимуллин on 13.06.2024.
//

import Foundation
import UIKit

class HintView: UIView {
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = -1
        label.textAlignment = .left
        label.textColor = .white
        label.layer.opacity = 0
        return label
    }()

    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = -1
        label.textAlignment = .left
        label.textColor = .white
        label.layer.opacity = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .black
        addSubview(questionLabel)
        addSubview(answerLabel)
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 72),
            questionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            questionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12),

            answerLabel.topAnchor.constraint(equalTo: self.questionLabel.bottomAnchor, constant: 4),
            answerLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            answerLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12)
        ])
    }

    public func setText(questiontext: String, answerText: String) {
        questionLabel.text = questiontext
        answerLabel.text = answerText
    }

    public func showText() {
        UIView.animate(withDuration: 0.25, animations: {
            self.questionLabel.layer.opacity = 1
            self.answerLabel.layer.opacity = 1
        })
    }

    public func hideText() {
        UIView.animate(withDuration: 0.25, animations: {
            self.questionLabel.layer.opacity = 0
            self.answerLabel.layer.opacity = 0
        })
    }

}
