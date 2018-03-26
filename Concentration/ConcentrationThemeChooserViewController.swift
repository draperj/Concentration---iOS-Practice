//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Joshua Draper on 3/23/18.
//  Copyright © 2018 JoshuaDraper. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {
    
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
        "Animals": "🐶🐔🦊🐼🦀🐪🐓🐋🐙🦄🐵",
        "Faces": "😬😂😎😩😰😴🙄🤔😘😷"
    ]
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitviewDetilConcetrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitviewDetilConcetrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController{
                    cvc.theme=theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}
