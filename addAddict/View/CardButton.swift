import UIKit

protocol CardButtonDelegate: class {
  func cardButtonTapped(button: CardButton)
}

enum CardType {
  case card
  case answer
  case guess
}

class CardButton: UIButton {
  static let unusedIndex = -1
  static let unusedValue = -1

  let type: CardType
  var value: Int
  var index: Int
  var isPicked: Bool = false {
    didSet {
      self.backgroundColor = isPicked ? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) : #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
      self.setTitleColor(isPicked ? #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) , for: .disabled)
    }
  }
  weak var delegate: CardButtonDelegate?

  init(index: Int, value: Int, frame: CGRect, delegate: CardButtonDelegate? = nil) {
    self.type = .card
    self.value = value
    self.index = index
    self.delegate = delegate
    self.isPicked = false
    super.init(frame: frame)
    setupUI()
  }

  init(type: CardType, frame: CGRect, value: Int = CardButton.unusedValue) {
    self.type = type
    self.value = value
    self.index = CardButton.unusedIndex
    super.init(frame: frame)
    setupUI()
  }

  func setupUI() {
    self.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
    self.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
    self.titleLabel?.font = UIFont.boldSystemFont(ofSize: type == .card ? 40 : 50 )
    self.addTarget(self, action: #selector(cardBtnTapped), for: .touchUpInside)
    self.layer.cornerRadius = self.frame.width / 6
    self.isUserInteractionEnabled = type == .card

    var title = String(value)
    if type == .guess, value == CardButton.unusedValue {
      title = ""
      self.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    self.setTitle(title, for: .normal)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func cardBtnTapped(sender: UIButton) {
    delegate?.cardButtonTapped(button: self)
  }
}
