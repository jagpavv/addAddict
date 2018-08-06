/*
1. show all btn's random number & answer
 1) generate random number (overlap is okay) for displying btns

 2) generate random number only & once for two for making answer
 3) choose and add two numbers from btn's ramdom array.

 2. gather btn inupt
  1) gather user inupt tapBtn 1
    1-1) changed Btn background color
  2) gather user input tapbtn 2
    2-1) changed Btn background color
  3) make btn input disabled

 3. add
  1) add tapBtn1 + tapbtn2
  2) make btn input disabled


 4. compare
   4)compare answer with add(tapBtn1&tapBtn2) result
      4-1) if match, the two numbers & answer are dispear
                     start new game with rest of the random number
      4-2) if not, return original color of the btn
                    reset two btn input
 */




import UIKit



class ViewController: UIViewController {

  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet var numberBtns: [UIButton]!

  let pickNumbers = 2
  var operandNums: [Int] = []
  var tappedNums: [Int] = []
  var answer: Int = Int()


  override func viewDidLoad() {
    super.viewDidLoad()
    generateRandomNum()
    generateAnswer()
    print("\(operandNums)")
  }

  func generateRandomNum(){
    let i = numberBtns.count
    for _ in 1...i {
      operandNums.append(Int(arc4random_uniform(100)))
    }
  }

  func generateAnswer() {

    var indexArray = Array(0..<operandNums.count)
    var picked: [Int] = []

    for _ in 0..<pickNumbers where !indexArray.isEmpty {
      let randIdx = Int(arc4random_uniform(UInt32(indexArray.count)))
      let randVal = indexArray.remove(at: randIdx)
      picked.append(randVal)
    }

    if picked.count == pickNumbers {
      if let first = picked.first,
        let second = picked.last {
        answer = operandNums[first] + operandNums[second]
      }
    }
    print("answer: \(answer)")
    print("indexArray: \(indexArray)")
    print("picked index: \(picked)")
  }


  @IBAction func startBtnTapped(_ sender: UIButton) {
    tappedNums.removeAll()
    showNums()
  }

  func showNums() {
    for btn in numberBtns {
      btn.setTitle(String(operandNums[btn.tag]), for: .normal)
    }

    answerLabel.text = String(answer)
  }


  @IBAction func btnDown(_ sender: UIButton) {
    guard pickNumbers > tappedNums.count else {
      sender.isEnabled = false
      return
    }

    if pickNumbers >= tappedNums.count {
      tappedNums.append(operandNums[sender.tag])
      sender.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
      sender.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
  }

  @IBAction func btnUp(_ sender: UIButton) {
    sender.isEnabled = false
  }




//  func flipCard(withNum num: Int, on button: UIButton) {
//    if button.currentTitle == String(num) {
//      button.setTitle("", for: UIControlState.disabled)
//      button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//    } else {
//      button.setTitle(String(num), for: UIControlState.normal)
//      button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//    }

//
//    func flipcard(withEmoji emoji: String, on button: UIButton) {
//      if button.currentTitle == emoji {
//        button.setTitle("", for: UIControlState.normal)
//        button.backgroundColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
//      } else {
//        button.setTitle(emoji, for: UIControlState.normal)
//        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//      }
//    }
  }

//  func enableBtns(_ enabled: Bool  ) {
//    for btn in numberBtns {
//      btn.isEnabled = enabled
//    }
//  }











