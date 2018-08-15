import UIKit

class Card {
  let value: Int
  var picked: Bool = false

  init() {
    value = Int(arc4random_uniform(100))
    print("'Card' is being initialized with number: \(value)")
  }
}
