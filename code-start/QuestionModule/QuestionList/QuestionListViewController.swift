//
//  QuestionListViewController.swift
//  code-start
//
//  Created by Тимур Калимуллин on 03.01.2025.
//

import UIKit

class QuestionListViewController: UIViewController {
    let courseName: String
    let questionArray: [QAItem]

    weak var delegate: QuestionTableInputDelegate?

    init(courseName: String, questionArray: [QAItem]) {
        self.courseName = courseName
        self.questionArray = questionArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var courseNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .white
        label.text = courseName
        label.alpha = 0
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor.black
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.alpha = 0
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuestionListTableViewCell.self, forCellReuseIdentifier: QuestionListTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.black
        tableView.alpha = 0
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupTargets()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.layer.cornerRadius = backButton.frame.size.width / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customPresentationAnimation(alpha: 1)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        customPresentationAnimation(alpha: 0)
    }

    private func setupConstraints() {
        view.addSubview(backButton)
        view.addSubview(courseNameLabel)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            courseNameLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            courseNameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }

    private func setupTargets() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
}

extension QuestionListViewController {
    @objc private func backButtonTapped() {
        self.dismiss(animated: false)
    }

    public func customPresentationAnimation(alpha: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.courseNameLabel.alpha = alpha
            self.backButton.alpha = alpha
            self.tableView.alpha = alpha
        })
    }
}

extension QuestionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionListTableViewCell.identifier, for: indexPath) as? QuestionListTableViewCell else { fatalError() }
        cell.configure(with: questionArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(questionArray[indexPath.row])
        if questionArray[indexPath.row].getIsDone() && !questionArray[indexPath.row].getIsHidden(){
            self.dismiss(animated: false)
            delegate?.dismissQuestionList(id: questionArray[indexPath.row].getId())
        }
    }

}
