//
//  QuestionTableView.swift
//  code-start
//
//  Created by Тимур Калимуллин on 05.01.2024.
//

import Foundation
import UIKit

class QuestionTableView: UIView {
    weak var delegate: QuestionTableOutputDelegate?
    
    let tableView = UITableView(frame: .zero, style: .plain)
    private var maskLayer: CAShapeLayer?

    private var showFavourite: Bool = true
    private var showDone: Bool = false
    private var showHidden: Bool = false

    private var isStudyMode: Bool = true

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "adasdsadsad"
        label.font = UIFont.systemFont(ofSize: 17)
        label.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return label
    }()
    
    private lazy var progressView: TappableProgressView = {
        let progressView = TappableProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        //progressView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = #colorLiteral(red: 0.1370271122, green: 0.8109224439, blue: 0.9838314652, alpha: 1)
        progressView.progress = 0.0
        progressView.tapAreaInsets = UIEdgeInsets(top: -12, left: 0, bottom: -12, right: 0)
        return progressView
    }()

    private lazy var modeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.setImage(UIImage(systemName: "circle.hexagongrid.fill"), for: .normal)
        button.tintColor = UIColor.black
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor.black
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        button.tintColor = UIColor.black
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.menu = createFilterMenu()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private func createFilterMenu() -> UIMenu {
        let resetAction = UIAction(title: "Reset", image: UIImage(systemName: "goforward"), attributes: .destructive, handler: { _ in
            self.showFavourite = true
            self.showDone = false
            self.showHidden = false
            self.filterButton.menu = self.createFilterMenu()
            self.delegate?.filterButtonTapped(showFavourite: self.showFavourite, showDone: self.showDone, showHidden: self.showHidden)
        })
        let menu = UIMenu(title: "", options: [.displayInline], children: filterMenuItems)
        let submenu = UIMenu(title: "", options: [.displayInline], children: [resetAction])
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [menu, submenu])
    }
    private var filterMenuItems: [UIAction] {
        return [
            UIAction(title: "Bookmarked", image: UIImage(systemName: "bookmark.circle"), state: showFavourite ? .on : .off, handler: { _ in
                self.showFavourite = !self.showFavourite
                self.filterButton.menu = self.createFilterMenu()
                self.delegate?.filterButtonTapped(showFavourite: self.showFavourite, showDone: self.showDone, showHidden: self.showHidden)
            }),
            UIAction(title: "Done", image: UIImage(systemName: "checkmark.circle"), state: showDone ? .on : .off, handler: { _ in
                self.showDone = !self.showDone
                self.filterButton.menu = self.createFilterMenu()
                self.delegate?.filterButtonTapped(showFavourite: self.showFavourite, showDone: self.showDone, showHidden: self.showHidden)
            }),
            UIAction(title: "Hidden", image: UIImage(systemName: "x.circle"), state: showHidden ? .on: .off, handler: { _ in
                self.showHidden = !self.showHidden
                self.filterButton.menu = self.createFilterMenu()
                self.delegate?.filterButtonTapped(showFavourite: self.showFavourite, showDone: self.showDone, showHidden: self.showHidden)
            })
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupConstraints()
        setupTargets()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
        setupConstraints()
        setupTargets()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backButton.layer.cornerRadius = backButton.frame.size.width / 2
        modeButton.layer.cornerRadius = modeButton.frame.size.width / 2
        filterButton.layer.cornerRadius = filterButton.frame.size.width / 2
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let window = self.window else { return }
        questionListDismissAnimation(window: window)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuestionCell.self, forCellReuseIdentifier: QuestionCell.identifier)
        tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: FooterTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isPagingEnabled = true
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.contentInset = UIEdgeInsets.zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UIScreen.main.bounds.height
        tableView.estimatedRowHeight = UIScreen.main.bounds.height
        tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true

    }

    private func setupConstraints() {
        //translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubview(tableView)
        addSubview(progressView)
        addSubview(backButton)
        addSubview(modeButton)
        addSubview(filterButton)

        NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo: topAnchor),
           tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
           tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
           tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

           backButton.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
           backButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),

           modeButton.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
           modeButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
           filterButton.topAnchor.constraint(equalTo: self.modeButton.bottomAnchor, constant: 15),
           filterButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
           
           progressView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 14),
           progressView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 32),
           progressView.trailingAnchor.constraint(equalTo: modeButton.leadingAnchor, constant: -32),
        ])
    }

    private func setupTargets() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        modeButton.addTarget(self, action: #selector(modeButtonTapped), for: .touchUpInside)

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(progressViewTapped))
        progressView.addGestureRecognizer(tap)
    }
}

extension QuestionTableView {
    @objc private func backButtonTapped() {
        delegate?.backButtonTapped()
    }

    @objc private func modeButtonTapped() {
        isStudyMode = !isStudyMode
        let newImage = isStudyMode ? UIImage(systemName: "circle.hexagongrid.fill") : UIImage(systemName: "bolt.fill")
        let newTintColor = isStudyMode ? UIColor.black : #colorLiteral(red: 0.1370271122, green: 0.8109224439, blue: 0.9838314652, alpha: 1)
        modeButton.layer.shadowOpacity = 0

        UIView.transition(with: modeButton, duration: 0.5, options: .transitionFlipFromLeft) {
            self.modeButton.setImage(newImage, for: .normal)
            self.modeButton.tintColor = newTintColor
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.modeButton.layer.shadowOpacity = 0.5
                self.studyModeHasChanged()
            } completion: { _ in
                self.studyModeEndChanged()
            }
        }
    }

    private func studyModeHasChanged() {
        progressView.alpha = isStudyMode ? 1 : 0
        filterButton.alpha = isStudyMode  ? 1 : 0
    }

    private func studyModeEndChanged() {
        delegate?.studyModeChanged(isStudyMode)
    }

    @objc private func progressViewTapped() {
        guard let window = self.window else { return }

        let startFrame = progressView.convert(progressView.bounds, to: window)
        let startCenter = CGPoint(x: startFrame.midX, y: startFrame.midY)
        // Create a circular mask layer
        let maskLayer = CAShapeLayer()
        // Start path: small circle at the center of the tapped view
        let startRadius: CGFloat = 1
        let startPath = UIBezierPath(arcCenter: startCenter, radius: startRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        // End path: large circle that covers the whole screen
        let finalRadius = max(window.bounds.width, window.bounds.height) * 1.5
        let endPath = UIBezierPath(arcCenter: startCenter, radius: finalRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        // Configure the mask layer
        maskLayer.path = endPath.cgPath
        maskLayer.fillColor = UIColor.black.cgColor
        self.layer.addSublayer(maskLayer)
        self.maskLayer = maskLayer

        // Animation
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.duration = 1.25
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        maskLayer.add(animation, forKey: "pathAnimation")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            guard let questionArray = self.delegate?.getQuestionsForDisplay(),
                  let courseName = self.delegate?.getCourseName() else { return }
            let questionListViewController = QuestionListViewController(courseName: courseName, questionArray: questionArray)
            questionListViewController.delegate = self
            questionListViewController.modalPresentationStyle = .fullScreen
            questionListViewController.view.backgroundColor = .black
            self.delegate?.progressBarTapped(destinatedVC: questionListViewController)
        }

    }

    func questionListDismissAnimation(window: UIWindow) {
        guard let maskLayer = self.maskLayer else { return }
        
        let endFrame = progressView.convert(progressView.bounds, to: window)
        let endCenter = CGPoint(x: endFrame.midX, y: endFrame.midY)
        // Start path: big circle
        let startRadius: CGFloat = max(window.bounds.width, window.bounds.height) * 1.5
        let startPath = UIBezierPath(arcCenter: endCenter, radius: startRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        // End path: small circle
        let finalRadius: CGFloat = 1
        let endPath = UIBezierPath(arcCenter: endCenter, radius: finalRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        // Configure the mask layer
        maskLayer.path = endPath.cgPath
        maskLayer.fillColor = UIColor.black.cgColor


        // Animation
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.duration = 1.25
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        maskLayer.add(animation, forKey: "pathAnimation")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            maskLayer.removeFromSuperlayer()
            self.maskLayer = nil
        }
    }

}

extension QuestionTableView: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (delegate?.countQA() ?? 1) - 1 {
            return configureFooterCell(cellForRowAt: indexPath)
        } else {
            return configureQACells(cellForRowAt: indexPath)
        }

    }

    private func configureQACells(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifier, for: indexPath) as? QuestionCell else { fatalError() }
        if let item = delegate?.configureCell(index: indexPath.row) {
            cell.configure(item, indexPath.row)
            cell.delegate = self
        }

        return cell
    }

    private func configureFooterCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.identifier, for: indexPath) as? FooterTableViewCell else { fatalError() }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(delegate?.countQA())
        return delegate?.countQA() ?? 1
    }

    //func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //    let footerView = UIView()
    //    footerView.backgroundColor = .systemGray5

        //let footerLabel = UILabel()
        //footerLabel.text = "Looks like there are no more questions "
        //footerLabel.textColor = .darkGray
        //footerLabel.frame = CGRect(x: 16, y: 0, width: tableView.frame.size.width - 32, height: 40)
        //footerView.addSubview(footerLabel)
    //    return footerView
    //}

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows, let visibleIndex = visibleIndexPaths.map({ $0.row }).last, isStudyMode {
                delegate?.questionCompleted(row: visibleIndex)
        }
    }


    //func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //    return 50
    //}
}

extension QuestionTableView: QuestionCellDelegate {
    public func deleteButtonTapped(row: Int) {
        delegate?.deleteButtonTapped(row: row)
    }

    public func favouriteButtonTapped(row: Int) {
        delegate?.favouriteButtonTapped(row: row)
    }
}

extension QuestionTableView: QuestionTableInputDelegate { 
    public func deleteRow(row: Int) {
        tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
        tableView.reloadData()
    }

    public func reconfigureRow(row: Int) {
        tableView.reconfigureRows(at: [IndexPath(row: row, section: 0)])
    }

    public func reloadTable() {
        tableView.reloadData()
    }

    public func updateProgressBar(withValue: Float) {
        let newProgress = min(progressView.progress + withValue, 1.0)
        progressView.setProgress(newProgress, animated: true)
    }

    public func dismissQuestionList(id: Int) {
        guard let index = delegate?.getQItemBy(id: id) else { return }
        tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
    }
}


