import UIKit

class GameViewController: UIViewController {

  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var cardsBaseView: UIView!

  let numberOfCards = 20
  let numberOfPicks = 2
  var answer = 0
  var game: Game?
 
  @IBAction func startBtnTapped(_ sender: UIButton) {
    game = Game(numberOfCards: numberOfCards)
    startGame()
  }

  func startGame() {
    makeAnswer()
    showAnswer()
    showCards(animated: true)
  }

  func endGame() {

  }

  func checkAnswer() {

  }

  private func makeAnswer() {
    guard let game = game else { return }

    print("makeAnswer")
    answer = 0
    var cards = Array(game.cards)
    for _ in 0..<numberOfPicks {
      let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
      let ramdomValue = cards[randomIndex].value
      print(ramdomValue)
      answer += ramdomValue
      cards.remove(at: randomIndex)
    }
  }

  func showAnswer() {
    print("printAnswer: \(answer)")
    answerLabel.text = String(answer)
  }

  func showCards(animated: Bool = false) {
    guard let game = game else { return }

    let padding: CGFloat = 10.0
    let totalWidth = cardsBaseView.frame.width
    let totalHeight = cardsBaseView.frame.height
    let cardWidth = (totalWidth - (padding * CGFloat(4 + 1)))  / 4
    let cardHeight = (totalHeight - (padding * CGFloat(5 + 1))) / 5
    for idx in 0..<game.cards.count {
      let card = game.cards[idx]
      let x = animated ? padding : CGFloat(idx % 4) * (cardWidth + padding) + padding
      let y = animated ? padding : CGFloat(idx / 4) * (cardHeight + padding) + padding
      let cardButton = UIButton(frame: CGRect(x: x, y: y, width: cardWidth, height: cardHeight))
      cardButton.setTitle(String(card.value), for: .normal)
      cardButton.setTitleColor(.black, for: .normal)
      cardButton.backgroundColor = .white
      cardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
      cardsBaseView.addSubview(cardButton)
    }

    if animated {
      UIView.animate(withDuration: 0.5) {
        for idx in 0..<self.cardsBaseView.subviews.count {
          let x = CGFloat(idx % 4) * (cardWidth + padding) + padding
          let y = CGFloat(idx / 4) * (cardHeight + padding) + padding
          let card = self.cardsBaseView.subviews[idx]
          var f = card.frame
          f = CGRect(x: x, y: y, width: cardWidth, height: cardHeight)
          card.frame = f
        }
      }
    }
  }
}
