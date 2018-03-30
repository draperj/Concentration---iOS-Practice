//
//  ViewController.swift
//  Concentration
//
//  Created by Josh Draper on 3/8/18.
//  Copyright © 2018 JoshuaDraper. All rights reserved.
//

import UIKit

class ConcentrationViewController: VCLLoggingViewController {
    
    override var vclLoggingName: String {
        return "Game"
    }
    
    //does not initialize until called
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        get {
            return (cardButtons.count + 1) / 2
        }
    }
    
    
    var theme: String? {
        didSet{
            emojiChoicesStore  = theme ?? ""
            emojiChoices = emojiChoicesStore
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var emojiChoicesStore  = "👻🎃🧟‍♂️🤖☠️👾👹🧙🏼‍♂️"
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
        ]
        let attributeString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributeString
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        emojiChoices = emojiChoicesStore
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
        flipCount = 0
    }
    
    private func updateViewFromModel(){
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
                }
            }
        }
    }
    
    
    
    private lazy var emojiChoices: String = { self.emojiChoicesStore }()
    
    private var emoji = [Card:String]()
    
    private func emoji(for card:Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0{
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}


