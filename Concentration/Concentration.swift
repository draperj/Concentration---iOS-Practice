//
//  Concentration.swift
//  Concentration
//
//  Created by Joshua Draper on 3/12/18.
//  Copyright © 2018 JoshuaDraper. All rights reserved.
//

import Foundation

class Concentration
{
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        //        if cards[index].isFaceUp{
        //            cards[index].isFaceUp = false
        //        } else  {
        //            cards[index].isFaceUp = true
        //        }
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        shuffleCards()
    }
    
    func shuffleCards() {
        var last = self.cards.count - 1
        
        while(last > 0)
        {
            let rand = Int(arc4random_uniform(UInt32(last)))
            
            cards.swapAt(last, rand)
            
            last -= 1
        }
    }
}


