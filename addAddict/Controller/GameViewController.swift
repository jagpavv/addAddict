import UIKit
import Foundation

let kNumberOfCards = 20
let kNumberOfPicks = 2
let kHightLevelKey = "HightLevel"
let KBestTimeKey = "BestTime"

class GameViewController: UIViewController {

  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var cardsBaseView: UIView!
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var timerLabel: UILabel!

  let userDefault = UserDefaults.standard
  var level = 1
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
  var timerIsOn = false

  override func viewDidLoad() {
    super.viewDidLoad()
    runTimer()
    timerIsOn = true
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    initGame()

//    for btn in cardsBaseView.subviews {
//      btn.layer.cornerRadius = btn.frame.width / 2
//    }

//    cardButton.layer.cornerRadius = cardButton.frame.height / 2

  }

  @IBAction func startPauseBtnTapped(_ sender: UIButton) {
    if timerIsOn {
      timerIsOn = false
      timer?.invalidate()

      sender.setTitle("▶︎", for: .normal)
      sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    } else {
      runTimer()

      sender.setTitle("||", for: .normal)
    }
  }

  func initGame() {
    game = Game(numberOfCards: kNumberOfCards, randomNumUiform: randomNumUiform)
    startGame()
    print("randomNumUiform: \(randomNumUiform)")
  }

  func startGame() {
    makeNewAnswer()
    showCards(animated: true)

    print("userDefault Level: \(userDefault.integer(forKey: kHightLevelKey))")
    print("current Level: \(level)")

    print("userDefault time: \(userDefault.integer(forKey: KBestTimeKey))")
    print("current time: \(seconds)")
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
      level += 1
      randomNumUiform += 5
      print("level: \(level)")


      // userDefault Level
      let storedLevel = userDefault.integer(forKey: kHightLevelKey)
      let highestLevel = level > storedLevel ? level : storedLevel
      userDefault.set(highestLevel, forKey: kHightLevelKey)
      userDefault.synchronize()

      // userDefault time
      if userDefault.integer(forKey: KBestTimeKey) == 0 {
        userDefault.set(seconds, forKey: KBestTimeKey)
      } else {
      let storedTime = userDefault.integer(forKey: KBestTimeKey)
      let shortestTime = seconds < storedTime ? seconds : storedTime
      userDefault.set(shortestTime, forKey: KBestTimeKey)
      userDefault.synchronize()
      }

      for subview in cardsBaseView.subviews {
        subview.removeFromSuperview()
      }
      startGame()
    }
    print("pickedCards: \(pickedCardsCount)")
  }

  func endGame() {
    print("success, end game")
  }

  func runTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1,
                                 repeats: true,
                                 block: { _ in
                                  self.seconds += 1

                                  let min = (self.seconds / 60) % 60
                                  let sec = self.seconds % 60

                                  let minSec = String(format: "%0.2d : %0.2d", min, sec)
                                  self.timerLabel.text = minSec
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
