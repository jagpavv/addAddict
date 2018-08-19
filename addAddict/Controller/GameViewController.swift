import UIKit

class GameViewController: UIViewController {

  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var cardsBaseView: UIView!

  let numberOfCards = 20
  let numberOfPicks = 2
  var randomNumUiform = 10
  var answer = 0
  var guess: [Int] = []
  var game: Game?
  var isGuessCorrect: Bool {
    guard guess.count == numberOfPicks else { return false }
    return guess.reduce(0, +) == answer
  }
  var cardButton: CardButton?
 
  @IBAction func startBtnTapped(_ sender: UIButton) {
    initGame()
  }

  func initGame() {
    game = Game(numberOfCards: numberOfCards, randomNumUiform: randomNumUiform)
    startGame()
    print("randomNumUiform: \(randomNumUiform)")
  }

  func startGame() {
    makeNewAnswer()
    showCards(animated: true)
  }

  func endGame() {
    print("success, end game")
  }

  private func makeNewAnswer() {
    guard let game = game else { return }

    guess.removeAll()
    answer = 0

    var cards = game.cards.filter { !$0.picked }

    if cards.count > 0 {
      for _ in 0..<numberOfPicks {
        let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
        let ramdomValue = cards[randomIndex].value
        print(ramdomValue)
        answer += ramdomValue
        cards.remove(at: randomIndex)
      }
      answerLabel.text = String(answer)
    } else {
      endGame()
    }
  }

  func showCards(animated: Bool = false) {
    guard let game = game else { return }

    let pad: CGFloat = 10.0
    let totalWidth = cardsBaseView.frame.width
    let totalHeight = cardsBaseView.frame.height
    let cardWidth = (totalWidth - (pad * CGFloat(4 + 1)))  / 4
    let cardHeight = (totalHeight - (pad * CGFloat(5 + 1))) / 5

    for idx in 0..<game.cards.count {
      let card = game.cards[idx]
      let x = animated ? pad : CGFloat(idx % 4) * (cardWidth + pad) + pad
      let y = animated ? pad : CGFloat(idx / 4) * (cardHeight + pad) + pad
      let f = CGRect(x: x, y: y, width: cardWidth, height: cardHeight)

      cardButton = CardButton(index: idx, value: card.value, frame: f, delegate: self)
      cardsBaseView.addSubview(cardButton!)

//      cardButton?.clipsToBounds = true
//      let cardButton = CardButton(index: idx, value: card.value, frame: f, delegate: self)
//      cardButton.clipsToBounds = true
//      cardsBaseView.layer.masksToBounds = true
    }

    if animated {
      UIView.animate(withDuration: 0.5) {
        for idx in 0..<self.cardsBaseView.subviews.count {
          let x = CGFloat(idx % 4) * (cardWidth + pad) + pad
          let y = CGFloat(idx / 4) * (cardHeight + pad) + pad
          let card = self.cardsBaseView.subviews[idx]
          var f = card.frame
          f = CGRect(x: x, y: y, width: cardWidth, height: cardHeight)
          card.frame = f
        }
      }
    }
  }

  func moveToNextAnswer() {
    guard let game = game else { return }
    let pickedCardsCount = game.cards.filter { $0.picked }.count

    if pickedCardsCount == numberOfCards {
      randomNumUiform += 5
      for subview in cardsBaseView.subviews {
        subview.removeFromSuperview()
      }
      initGame()
    }
    print("pickedCards: \(pickedCardsCount)")

    UIView.animate(withDuration: 0.3, animations: {
      for idx in 0..<self.cardsBaseView.subviews.count {
        guard let card = self.cardsBaseView.subviews[idx] as? CardButton else { continue }
        card.alpha = card.isPicked ? 0 : 1
      }
    }) { _ in
      self.makeNewAnswer()
    }
  }
}

extension GameViewController: CardButtonDelegate {
  func cardButtonTapped(button: CardButton) {
    guard let game = game else { return }

    if !button.isPicked, guess.count < numberOfPicks {
      game.cards[button.index].picked = true
      button.isPicked = true
      guess.append(button.value)
    } else {
      game.cards[button.index].picked = false
      button.isPicked = false
      guess = guess.filter { $0 != button.value }
    }
    print("guess: \(guess)")

    if isGuessCorrect {
      moveToNextAnswer()
    }

//    let pickedCardsCount = game.cards.filter { $0.picked }.count
//    if isGuessCorrect {
//      moveToNextAnswer()
//    } else if isGuessCorrect && game.cards.count == pickedCardsCount {
//      endGame()
//      moveToNextStage()
//    }
  }
}
