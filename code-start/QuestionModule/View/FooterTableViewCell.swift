//
//  FooterTableViewCell.swift
//  code-start
//
//  Created by Тимур Калимуллин on 04.01.2025.
//

import UIKit

class FooterTableViewCell: UITableViewCell {
    static let identifier = "FooterCell"

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        label.numberOfLines = -1
        label.textAlignment = .center
        label.text = "Looks like you've made it"
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

}
