import UIKit

protocol CardButtonDelegate: class {
  func cardButtonTapped(button: CardButton)
}

class CardButton: UIButton {
  var value: Int
  var index: Int
  var isPicked: Bool = false {
    didSet {
      self.backgroundColor = isPicked ? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      self.setTitleColor(isPicked ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) , for: .disabled)
    }
  }
  weak var delegate: CardButtonDelegate?

  init(index: Int, value: Int, frame: CGRect, delegate: CardButtonDelegate? = nil) {
    self.value = value
    self.index = index
    self.delegate = delegate
    self.isPicked = false
    super.init(frame: frame)

    self.setTitle(String(value), for: .normal)
    self.setTitleColor(.black, for: .normal)
    self.backgroundColor = .white
    self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
    self.addTarget(self, action: #selector(cardBtnTapped), for: .touchUpInside)
    self.layer.cornerRadius = self.frame.width / 6

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func cardBtnTapped(sender: UIButton) {
    delegate?.cardButtonTapped(button: self)
  }

}
