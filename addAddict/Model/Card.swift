import UIKit

class Card {
  let value: Int
  var picked: Bool = false

  init(randomNumUiform: Int) {
    value = Int(arc4random_uniform(UInt32(randomNumUiform)))
    print("'Card' is being initialized with number: \(value)")
  }
}
