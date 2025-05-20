//
//  SettingsViewController.swift
//  TestApp
//
//  Created by Kirill Sysoev on 20.05.2025.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var darkSwitch: UISwitch!
    @IBOutlet weak var systemSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedTheme = UserDefaults.standard.object(forKey: "AppTheme") as? Int {
            changeTheme(theme: UIUserInterfaceStyle(rawValue: savedTheme)!)
        }
        setupMenu()
    }
    
    
    @IBAction func lightSwitchChanged(_ sender: Any) {
        changeTheme(theme: .light)
    }
    
    @IBAction func darkSwitchChanged(_ sender: Any) {
        changeTheme(theme: .dark)
    }
    
    @IBAction func systemSwitchChanged(_ sender: Any) {
        changeTheme(theme: .unspecified)
    }
    
    func changeTheme(theme: UIUserInterfaceStyle) {
        UIApplication.shared.windows.forEach { $0.overrideUserInterfaceStyle = theme }
        
        lightSwitch.setOn(theme == .light, animated: false)
        darkSwitch.setOn(theme == .dark, animated: false)
        systemSwitch.setOn(theme == .unspecified, animated: false)
        
        UserDefaults.standard.set(theme.rawValue, forKey: "AppTheme")
    }
    
    func setupMenu() {
        let russian = UIAction(title: "Русский") {_ in
            self.changeLanguage(code: "ru")
        }
        
        let english = UIAction(title: "English") {_ in
            self.changeLanguage(code: "en")
        }
        
        languageButton.menu = UIMenu(title: "Languages", children: [russian, english])
        
        languageButton.showsMenuAsPrimaryAction = true
    }
    
    func changeLanguage(code: String) {
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        let alert = UIAlertController(title: "Restart required", message: "Language change will take effect after app restart.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Oк", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

}
