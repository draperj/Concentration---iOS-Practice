//
//  ViewController.swift
//  Concentration
//
//  Created by Josh Draper on 3/8/18.
//  Copyright © 2018 JoshuaDraper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //does not initialize until called
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    var emojiChoicesStore  = ["👻", "🎃", "🧟‍♂️", "🤖", "☠️", "👾", "👹", "🧙🏼‍♂️"]
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        emojiChoices = emojiChoicesStore
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
        flipCount = 0
    }
    
    func updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor=UIColor.white
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? UIColor.clear : UIColor.orange
            }
        }
    }
    
    lazy var emojiChoices: [String] = { self.emojiChoicesStore }()
    
    var emoji = [Int:String]()
    
    func emoji(for card:Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0{
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
}

