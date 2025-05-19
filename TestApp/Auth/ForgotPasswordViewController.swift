//
//  ForgotPasswordViewController.swift
//  TestApp
//
//  Created by Kirill Sysoev on 19.05.2025.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var incorrectEmailLabel: UILabel!
    @IBOutlet weak var sendEmailButton: UIButton!
    
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrectEmailLabel.isHidden = true
        
        emailTextField.text = email

        emailTextField.delegate = self
        
        sendEmailButton.addTarget(self, action: #selector(sendEmailButtonTapped), for: .touchUpInside)
    }
    
    @objc func sendEmailButtonTapped() {
        guard let email = emailTextField.text else { return }
        if validateEmail(email) {
            incorrectEmailLabel.isHidden = true
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print("Ошибка при отправке письма: \(error.localizedDescription)")
                    return
                }
                let alert = UIAlertController(title: "Успешно!", message: "На вашу электронную почту была отправлена ссылка для сброса пароля.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in
                    self.dismiss(animated: true)
                })
                self.present(alert, animated: true)
            }
        } else {
            incorrectEmailLabel.isHidden = false
        }
    }
    

    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}


extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
