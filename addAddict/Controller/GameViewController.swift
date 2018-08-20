import UIKit
import Foundation

let kNumberOfCards = 20
let kNumberOfPicks = 2
let kBestLevelKey = "BestLevel"
let KBestTimeKey = "BestTime"

class GameViewController: UIViewController {

  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var cardsBaseView: UIView!
  @IBOutlet weak var timerLabel: UILabel!

  let userDefault = UserDefaults.standard
  var seconds = 0
  var randomNumUiform = 10
  var game: Game?
  var timer: Timer?
  var answer = 0
  var guess: [Int] = []
  var isGuessCorrect: Bool {
    guard guess.count == kNumberOfPicks else { return false }
    return guess.reduce(0, +) == answer
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(false)
    initGame()
    runTimer()
  }

  @IBAction func startBtnTapped(_ sender: UIButton) {
    // change to pause the game? done game?
  }

  func initGame() {
    game = Game(numberOfCards: kNumberOfCards, randomNumUiform: randomNumUiform)
    startGame()
    print("randomNumUiform: \(randomNumUiform)")
  }

  func startGame() {
    makeNewAnswer()
    showCards(animated: true)
  }

  private func makeNewAnswer() {
    guard let game = game else { return }

    guess.removeAll()
    answer = 0

    var cards = game.cards.filter { !$0.picked }

    if cards.count > 0 {
      for _ in 0..<kNumberOfPicks {
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

  func endGame() {
    print("success, end game")
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

      let cardButton = CardButton(index: idx, value: card.value, frame: f, delegate: self)
      cardsBaseView.addSubview(cardButton)
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

  func moveTo() {
    guard let game = game else { return }
    let pickedCardsCount = game.cards.filter { $0.picked }.count

    if isGuessCorrect {
      moveToNextAnswer()
      if pickedCardsCount == kNumberOfCards {
        moveToNextLevel(pickedCardsCount: pickedCardsCount)
      }
    }
  }

  func moveToNextAnswer() {
    UIView.animate(withDuration: 0.3, animations: {
      for idx in 0..<self.cardsBaseView.subviews.count {
        guard let card = self.cardsBaseView.subviews[idx] as? CardButton else { continue }
        card.alpha = card.isPicked ? 0 : 1
      }
    }) { _ in
      self.makeNewAnswer()
    }
  }

  func moveToNextLevel(pickedCardsCount: Int) {
    if pickedCardsCount == kNumberOfCards {
      randomNumUiform += 5
      for subview in cardsBaseView.subviews {
        subview.removeFromSuperview()
      }
      initGame()
    }
    print("pickedCards: \(pickedCardsCount)")
  }


  func runTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1,
                                 repeats: true,
                                 block: { _ in
                                  self.seconds += 1
                                  self.timerLabel.text = String(self.seconds)
    })
  }

}

extension GameViewController: CardButtonDelegate {
  func cardButtonTapped(button: CardButton) {
    guard let game = game else { return }

    if !button.isPicked, guess.count < kNumberOfPicks {
      game.cards[button.index].picked = true
      button.isPicked = true
      guess.append(button.value)
    } else {
      game.cards[button.index].picked = false
      button.isPicked = false
      guess = guess.filter { $0 != button.value }
    }
    print("guess: \(guess)")
    moveTo()
  }
}
