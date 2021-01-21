//
//  SettingsViewController.swift
//  PixabayApp
//
//  Created by Клим on 17.01.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var trafficSwitch: UISwitch!
    
    @IBOutlet weak var cachingSwitch: UISwitch!
    
    @IBOutlet weak var themePicker: UIPickerView!
    
    weak var parentVC: SearchViewController!
    private var themePicked: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        setupView()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupView(){
        themePicker.delegate = self
        themePicker.dataSource = self
    }
    
    private func loadSettings(){
        CacheManager.shared.getSettings { (settings) in
            if !settings!.ecoModeEnabled{
                self.trafficSwitch.isOn = false
            }
            if !settings!.cachingEnabled{
                self.cachingSwitch.isOn = false
            }
            
            self.themePicked = settings!.themePicked
            if settings!.themePicked == 0{
                self.themePicker.selectRow(0, inComponent: 0, animated: false)
            }
            else if settings!.themePicked == 1{
                self.themePicker.selectRow(1, inComponent: 0, animated: false)
            }
            else{
                self.themePicker.selectRow(2, inComponent: 0, animated: false)
            }
        }
        
    }
    
    @IBAction func savingPressed(_ sender: Any) {
        var flag1 = false
        var flag2 = false
        
        if trafficSwitch.isOn{
            flag1 = true
        }
        
        if cachingSwitch.isOn{
            flag2 = true
        }
        
        let settings = AppSettings(cachingEnabled: flag2, ecoModeEnabled: flag1, themePicked: 1)
        CacheManager.shared.cacheSettings(settings)
        
        let alert = UIAlertController(title: "Please, reload the app", message: nil, preferredStyle: .alert)
        let button = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(button)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func clearCachePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to delete all cached images?", message: "This action cannot be undone", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Yes", style: .default){ (action) in
            _ = CacheManager.shared.tryClearCache()
        }
        let cancelButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(confirmButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clearSearchPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to clear recent searches?", message: "This action cannot be undone", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Yes", style: .default){ (action) in
            self.parentVC.saveRecentSearch(query: "")
        }
        let cancelButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(confirmButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            return "White theme"
        }
        else if row == 1{
            return "Black theme"
        }
        else{
            return "Auto-choice"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0{
            overrideUserInterfaceStyle = .light
        }
        else if row == 1{
            overrideUserInterfaceStyle = .dark
        }
        else{
            overrideUserInterfaceStyle = .unspecified
        }
    }
    
}

