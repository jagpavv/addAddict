import Foundation

class Game {
  var cards: [Card]
  
  init(numberOfCards: Int = 4) {
    print("'Game' model init")
    print("'Game' model is making cards: START")

    cards = []

    for _ in 0..<numberOfCards {
      let card = Card()
      cards.append(card)
      print("card is added to cards[]")
    }

    print("'Game' model is making cards: END")
  }
}
