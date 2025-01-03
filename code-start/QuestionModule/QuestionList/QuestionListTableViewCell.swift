//
//  QuestionListTableViewCell.swift
//  code-start
//
//  Created by Тимур Калимуллин on 03.01.2025.
//

import UIKit

class QuestionListTableViewCell: UITableViewCell {
    static let identifier = "QuestionListTableViewCell"

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    private lazy var hiddenStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.black
        button.layer.opacity = 1
        return button
    }()

    private lazy var favStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.setImage(UIImage(systemName: "bookmark.circle"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.1370271122, green: 0.8109224439, blue: 0.9838314652, alpha: 1)
        button.backgroundColor = UIColor.black
        button.layer.opacity = 1
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = UIColor.black
        addSubview(questionLabel)
        addSubview(favStatusButton)
        addSubview(hiddenStatusButton)

        NSLayoutConstraint.activate([
            questionLabel.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),

            favStatusButton.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor),
            favStatusButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            hiddenStatusButton.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor),
            hiddenStatusButton.trailingAnchor.constraint(equalTo: favStatusButton.leadingAnchor, constant: -12)
        ])
    }

    public func configure(with item: QAItem) {
        questionLabel.text = item.getQuestion()
        if item.getIsHidden() {
            hiddenStatusButton.layer.opacity = 1
        } else {
            hiddenStatusButton.layer.opacity = 0
        }

        if item.getIsFavourite() {
            favStatusButton.layer.opacity = 1
        } else {
            favStatusButton.layer.opacity = 0
        }

        if !item.getIsDone() {
            questionLabel.textColor = UIColor.gray
            hiddenStatusButton.layer.opacity = 0
            favStatusButton.layer.opacity = 0
            favStatusButton.layer.opacity = 0
        }

    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
