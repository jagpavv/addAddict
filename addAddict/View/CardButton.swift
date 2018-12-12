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

  // MARK: - Properties
  static let unusedIndex = -1
  static let unusedValue = -1

  let type: CardType
  var value: Int {
    didSet {
      setupUI()
    }
  }
  var index: Int
  var isPicked: Bool = false {
    didSet {
      self.backgroundColor = isPicked ? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) : #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
      self.setTitleColor(isPicked ? #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) , for: .disabled)
    }
  }
  weak var delegate: CardButtonDelegate?

  // MARK: - Initializers
  init(index: Int, value: Int, frame: CGRect, delegate: CardButtonDelegate? = nil) {
    self.type = .card
    self.index = index
    self.delegate = delegate
    self.isPicked = false
    self.value = value
    super.init(frame: frame)
    setupUI()
  }

  init(type: CardType, frame: CGRect, value: Int = CardButton.unusedValue) {
    self.type = type
    self.index = CardButton.unusedIndex
    self.value = value
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods
  // MARK: Custom Method
  func setupUI() {
    self.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
    self.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
    var fontSize: CGFloat = 40
    switch type {
    case .card:
      fontSize = 40
    case .answer:
      fontSize = 50
    case .guess:
      fontSize = 30
    }
    self.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize )
    self.addTarget(self, action: #selector(cardBtnTapped), for: .touchUpInside)
    self.layer.cornerRadius = self.frame.width / 6
    self.isUserInteractionEnabled = type == .card

    var title = String(value)
    if type == .guess, value == CardButton.unusedValue {
      title = ""
      self.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    } else {
      self.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
    }
    self.setTitle(title, for: .normal)
  }

  @objc func cardBtnTapped(sender: UIButton) {
    delegate?.cardButtonTapped(button: self)
  }
}
