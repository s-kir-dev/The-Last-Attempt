//
//  AuthViewController.swift
//  TestApp
//
//  Created by Kirill Sysoev on 19.05.2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var incorrectEmailLabel: UILabel!
    @IBOutlet weak var incorrectPasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var changeAuth: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    
    var signUp: Bool = false {
        didSet {
            incorrectEmailLabel.isHidden = true
            incorrectPasswordLabel.isHidden = true
            
            authButton.setTitle(signUp ? "Sign up" : "Login", for: .normal)
            accountLabel.text = signUp ? "Already have an account?" : "Don't have an account?"
            changeAuth.setTitle(signUp ? "Login" : "Sign Up", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        incorrectEmailLabel.isHidden = true
        incorrectPasswordLabel.isHidden = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        authButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        changeAuth.addTarget(self, action: #selector(changeAuthButtonTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func authButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        if validateEmail(email) && validatePassword(password) {
            if signUp {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    
                    if let result = result {
                        db.child("users").child(result.user.uid).setValue([
                            "name": "name",
                            "email": email
                        ])
                    }
                    
                    if let _ = error {
                        self.showAlert("Ошибка!", "Аккаунт с такой эл. почтой уже есть, проверьте правильность пароля")
                    }
                }
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let _ = result {
                        //загружать фавориты итд
                        
                    }
                    
                    if let _ = error {
                        self.showAlert("Ошибка!", "Такого пользователя или нет, или пароль неверный!")
                    }
                }
            }
        }
        
        if !validateEmail(email) {
            incorrectEmailLabel.isHidden = false
        } else {
            incorrectEmailLabel.isHidden = true
        }
        
        if !validatePassword(password) {
            incorrectPasswordLabel.isHidden = false
        } else {
            incorrectPasswordLabel.isHidden = true
        }
    }
    
    @objc func changeAuthButtonTapped() {
        signUp.toggle()
    }
    
    @objc func forgotPasswordButtonTapped() {
        performSegue(withIdentifier: "forgotVC", sender: self)
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forgotVC" {
            guard let destinationVC = segue.destination as? ForgotPasswordViewController, let email = emailTextField.text else { return }
            destinationVC.email = email
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
