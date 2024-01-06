//
//  QuestionViewController.swift
//  code-start
//
//  Created by Тимур Калимуллин on 05.01.2024.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {
    let tableView = QuestionTableView()
    let presenter = QuestionViewPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        let vv = UIView(frame: .init(x: 50, y: 50, width: 50, height: 50))
        vv.backgroundColor = .yellow
        view.addSubview(vv)
        view.addSubview(tableView)
        view.layoutSubviews()
        view.backgroundColor = .red
        //view.backgroundColor = .yellow
        self.tableView.delegate = presenter
        self.becomeFirstResponder()
    }
}
