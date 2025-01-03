//
//  RegistrationViewController.swift
//  code-start
//
//  Created by Тимур Калимуллин on 09.04.2024.
//

import UIKit

class RegistrationViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    private let service: AuthService = AuthService()
    private var username: String? = nil
    private var password: String? = nil
    private var email: String? = nil

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 25
        return stack
    }()


    private lazy var forgotButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        //button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        //button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        return button
    }()

    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        button.isEnabled = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.imageView?.tintColor = .lightGray
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.hideButtons()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.showButtons()
    }

    private func setupView() {
        view.backgroundColor =  .white.withAlphaComponent(0.9)
        view.addSubview(stackView)
        view.addSubview(signInButton)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            signInButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            signInButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            closeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        ])
        self.setupStackView()
        self.setupTargets()
    }

    private func setupStackView() {
        for attribute in RegAttributes.allCases {
            let view: UITextField = {
                let view = UITextField()
                view.placeholder = attribute.rawValue
                view.translatesAutoresizingMaskIntoConstraints = false
                view.heightAnchor.constraint(equalToConstant: 32).isActive = true
                view.font = UIFont.systemFont(ofSize: 20)
                view.layer.cornerRadius = 12
                view.layer.name = attribute.rawValue
                view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
                view.leftView = paddingView
                view.leftViewMode = .always
                return view
            }()

            stackView.addArrangedSubview(view)
        }
    }

    private func setupTargets() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        signInButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let attribute =  textField.layer.name,
        let data = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        switch RegAttributes(rawValue: attribute) {
        case .nickname:
            username = data
            asciiOnly(username, lengthRange: 3...) ? disableFieldWarning(type: .nickname) : enableFieldWarning(type: .nickname)
        case .password:
            password = data
            asciiOnly(password, lengthRange: 3...) ? disableFieldWarning(type: .password) : enableFieldWarning(type: .password)
        case .email:
            email = data
            isValidEmail(email) ? disableFieldWarning(type: .email) : enableFieldWarning(type: .email)
        default:
            break
        }

        if let username = username, let password = password, let email = email {
            if username.isEmpty || password.isEmpty || email.isEmpty {
                disableButton()
            } else {
                enableButton()
            }
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func signUpTapped() {
        guard let username = username, let password = password, let email = email else { return }
        Task {
            do {
                let (data, response) = try await service.registerUser(nickname: username, email: email, hashedPassword: password)
                if response.statusCode == 200 {
                    let (logData, logResponse) = try await service.loginUser(username: data.nickname, password: password)
                    if logResponse.statusCode == 200 {
                        await MainActor.run {
                            self.dismiss(animated: true)
                            delegate?.successfullLoginPipeline()
                        }
                    } else {
                        allert()
                    }
                }
            } catch {
                allert()
            }
        }
        //self.dismiss(animated: true)
        //delegate?.successfullLoginPipeline()

    }

    @objc func closeTapped() {
        self.dismiss(animated: true)
    }
}

extension RegistrationViewController {
    private func enableButton() {
        signInButton.setTitleColor(#colorLiteral(red: 0.1370271122, green: 0.8109224439, blue: 0.9838314652, alpha: 1), for: .normal)
        signInButton.isEnabled = true
    }

    private func disableButton() {
        signInButton.isEnabled = false
        signInButton.setTitleColor(.gray, for: .normal)
    }

    private func asciiOnly<R: RangeExpression>(_ name: String?, lengthRange: R) -> Bool where R.Bound == Int {
        guard  let name = name, lengthRange ~= name.count , name.first!.isLetter else { return false }
        return name.allSatisfy{ $0.isASCII }
    }

    private func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func enableFieldWarning(type: RegAttributes) {
        if signInButton.isEnabled { disableButton() }
        for view in stackView.subviews {
            if view.layer.name == type.rawValue {
                view.layer.borderWidth = 1
                view.layer.borderColor = UIColor.red.cgColor
            }
        }
        switch type {
        case .nickname:
            username = nil
        case .email:
            email = nil
        case .password:
            password = nil
        }
    }

    private func disableFieldWarning(type: RegAttributes) {
        for view in stackView.arrangedSubviews {
            if view.layer.name == type.rawValue {
                view.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    private func allert() {
        let alert = UIAlertController(title: "Registration Error", message: "Try again later", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
