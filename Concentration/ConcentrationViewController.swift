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
        let attributeString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact ? "Flips - \(flipCount)" : "Flips: \(flipCount)",
            attributes: attributes
        )
        flipCountLabel.attributedText = attributeString
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
    }
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = visibleCardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        emojiChoices = emojiChoicesStore
        game = Concentration(numberOfPairsOfCards: (visibleCardButtons.count + 1) / 2)
        updateViewFromModel()
        flipCount = 0
    }
    
    private func updateViewFromModel(){
        if visibleCardButtons != nil {
            for index in visibleCardButtons.indices {
                let button = visibleCardButtons[index]
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


