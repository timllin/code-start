//
//  QuestionTableView.swift
//  code-start
//
//  Created by Тимур Калимуллин on 05.01.2024.
//

import Foundation
import UIKit

class QuestionTableView: UIView {
    weak var delegate: QuestionTableInputDelegate?
    
    let tableView = UITableView()

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "adasdsadsad"
        label.font = UIFont.systemFont(ofSize: 17)
        label.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
        setupConstraints()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuestionCell.self, forCellReuseIdentifier: QuestionCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isPagingEnabled = true
        tableView.separatorStyle = .none
        tableView.bounces = false
        //tableView.allowsSelection = false
        //tableView.rowHeight = self.bounds.size.height //UIScreen.main.bounds.height
        //tableView.estimatedRowHeight = self.bounds.size.height //UIScreen.main.bounds.height
        tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        //tableView.heightAnchor.constraint(equalToConstant: 400).isActive = true

    }

    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.borderWidth = 5
        addSubview(tableView)

        NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo: topAnchor),
           tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
           tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
           tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

    }
}

extension QuestionTableView: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifier, for: indexPath) as? QuestionCell else { fatalError() }
        //cell.backgroundColor = .blue

        if let item = delegate?.configureCell(index: indexPath.row) {
            cell.configure(item)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.countQA() ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.safeAreaLayoutGuide.layoutFrame.size.height

    }

}


