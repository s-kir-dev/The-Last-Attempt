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
        
        UserDefaults.standard.set(theme.rawValue, forKey: "AppTheme")
        
        lightSwitch.setOn(theme == .light, animated: true)
        darkSwitch.setOn(theme == .dark, animated: true)
        systemSwitch.setOn(theme == .unspecified, animated: true)
    }
    
    func setupMenu() {
        let russianLanguage = UIAction(title: "Русский") { _ in
            self.changeLanguage("ru")
        }
        
        let englishLanguage = UIAction(title: "English") { _ in
            self.changeLanguage("en")
        }
        
        let menu = UIMenu(title: "Languages", children: [russianLanguage, englishLanguage])
        
        languageButton.menu = menu
        languageButton.showsMenuAsPrimaryAction = true
    }
    
    func changeLanguage(_ code: String) {
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        let alert = UIAlertController(title: code == "en" ? "Successfully!" : "Успешно!", message: code == "en" ? "Language changes saved. To apply them, the application needs to be restarted." : "Изменения языка сохранились, для их применения приложение необходимо перезапустить.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Oк", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
