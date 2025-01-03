//
//  QuestionCell.swift
//  code-start
//
//  Created by Тимур Калимуллин on 05.01.2024.
//

import Foundation
import UIKit

protocol QuestionCellDelegate: AnyObject {
    func deleteButtonTapped(row: Int)
    func favouriteButtonTapped(row: Int)
}

class QuestionCell: UITableViewCell {
    static let identifier = "QuestionCell"
    weak var delegate: QuestionCellDelegate?

    var hintViewWidthConstraint: NSLayoutConstraint?
    var hintViewHeightConstraint: NSLayoutConstraint?
    var hintViewYCenterConstraint: NSLayoutConstraint!
    var hintViewTopConstraint: NSLayoutConstraint!
    var hintViewBottomConstraint: NSLayoutConstraint!
    var hintViewLeadingConstraint: NSLayoutConstraint!
    var hintViewTrailingConstraint: NSLayoutConstraint!
    var isCirleHint: Bool = true

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupRefToContraints()
        setup()
        setupActions()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupActions()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        answerButton.layer.cornerRadius = answerButton.frame.width/2
        isCirleHint ? (hintView.layer.cornerRadius = hintView.frame.width/2) : (hintView.layer.cornerRadius = 0)
    }

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Constants().qFontSize)
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        label.numberOfLines = -1
        label.textAlignment = .center
        return label
    }()

    private lazy var hintView: HintView = {
        let hintView = HintView()
        hintView.translatesAutoresizingMaskIntoConstraints = false
        //hintView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        hintViewHeightConstraint = hintView.heightAnchor.constraint(equalToConstant: 27)
        hintViewWidthConstraint = hintView.widthAnchor.constraint(equalToConstant: 27)
        hintViewHeightConstraint?.isActive = true
        hintViewWidthConstraint?.isActive = true
        hintView.isHidden = true
        hintView.layer.cornerRadius = hintView.frame.width/2
        return hintView
    }()

    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalToConstant: 28).isActive = true
        stack.axis = .horizontal
        //stack.spacing = 20
        stack.distribution = .equalCentering
        stack.alignment = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 35)
        return stack
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.gray
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.isUserInteractionEnabled = true
        return button
    }()

    private lazy var answerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.setImage(UIImage(systemName: "lightbulb"), for: .normal)
        button.tintColor = UIColor.gray
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        return button
    }()

    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()

    private func setup() {
        clipsToBounds = true
        buttonsStack.addArrangedSubview(deleteButton)
        buttonsStack.addArrangedSubview(answerButton)
        buttonsStack.addArrangedSubview(favouriteButton)


        addSubview(questionLabel)
        addSubview(hintView)
        contentView.addSubview(buttonsStack)

        NSLayoutConstraint.activate([
            questionLabel.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
            questionLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),

            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            buttonsStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            buttonsStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),

            hintViewYCenterConstraint,
            hintView.centerXAnchor.constraint(equalTo: answerButton.centerXAnchor),
        ])
    }

    private func setupActions() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        answerButton.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(answerButtonTapped))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
    }

    private func setupRefToContraints() {
        hintViewYCenterConstraint = hintView.centerYAnchor.constraint(equalTo: answerButton.centerYAnchor)
        hintViewTopConstraint = hintView.topAnchor.constraint(equalTo: topAnchor)
        hintViewBottomConstraint = hintView.bottomAnchor.constraint(equalTo: bottomAnchor)
        hintViewLeadingConstraint = hintView.leadingAnchor.constraint(equalTo: leadingAnchor)
        hintViewTrailingConstraint = hintView.trailingAnchor.constraint(equalTo: trailingAnchor)
    }

    public func configure(_ item: QAItem, _ row: Int) {
        questionLabel.text = item.getQuestion()
        hintView.setText(questiontext: item.getQuestion(), answerText: item.getAnswer())

        deleteButton.tag = row
        favouriteButton.tag = row

        if item.getIsFavourite() {
            favouriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            favouriteButton.tintColor = UIColor.red
        } else {
            favouriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            favouriteButton.tintColor = UIColor.gray
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hintView.isHidden = true
        answerButton.setImage(UIImage(systemName: "lightbulb"), for: .normal)
        answerButton.tintColor = .systemGray
    }

    @objc func deleteButtonTapped() {
        delegate?.deleteButtonTapped(row: deleteButton.tag)
    }

    @objc func answerButtonTapped() {
        if !hintView.isHidden {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.answerButton.setImage(UIImage(systemName: "lightbulb"), for: .normal)
                self.answerButton.tintColor = .systemGray
                self.hintView.hideText()})
            rollHintView()
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.answerButton.setImage(UIImage(systemName: "lightbulb.fill"), for: .normal)
                self.answerButton.tintColor = .black })
            self.hintView.isHidden = false
            unrollHintView()
        }
    }

    @objc func favouriteButtonTapped() {
        delegate?.favouriteButtonTapped(row: favouriteButton.tag)
    }
    

    private func unrollHintView() {
        hintViewHeightConstraint?.constant = self.frame.height * 2
        hintViewWidthConstraint?.constant = self.frame.height * 2
        UIView.animate(withDuration: 1, animations: {
            self.layoutIfNeeded()
        }) { _ in
            self.isCirleHint = false
            self.hintViewHeightConstraint?.isActive = false
            self.hintViewWidthConstraint?.isActive = false
            self.hintViewYCenterConstraint?.isActive = false
            NSLayoutConstraint.activate([
                self.hintViewTopConstraint,
                self.hintViewBottomConstraint,
                self.hintViewLeadingConstraint,
                self.hintViewTrailingConstraint
            ])
            self.hintView.showText()
        }
    }

    private func rollHintView() {
        NSLayoutConstraint.deactivate([
            self.hintViewTopConstraint,
            self.hintViewBottomConstraint,
            self.hintViewLeadingConstraint,
            self.hintViewTrailingConstraint
        ])
        isCirleHint = true
        hintViewHeightConstraint?.isActive = true
        hintViewWidthConstraint?.isActive = true
        hintViewYCenterConstraint.isActive = true
        layoutSubviews()
        hintView.layer.cornerRadius = hintView.frame.width/2
        hintViewHeightConstraint?.constant = 28
        hintViewWidthConstraint?.constant = 28

        UIView.animate(withDuration: 1, animations: {
            self.layoutIfNeeded()
        }) { _ in
            self.hintView.isHidden = true
        }
    }
}

extension QuestionCell {
    private struct Constants {
        let qFontSize: CGFloat = 38
        let aFontSize: CGFloat = 25
    }
}
