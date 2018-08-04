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

    print(indexArray)
    print(picked)


    

//    for i in 1...2 {
//      let randomIndices = Int(arc4random_uniform(UInt32(indicesArray.count)))
//      a = operandNums[i]
//      print("\(a)")
//      print("randomindice \(randomIndices)")
//      let removeIndices = indicesArray.remove(at: randomIndices)
//      print("remove: \(removeIndices)")
//    }



    // 랜덤 넘버가 중복 되면 안됨. one & only
    // 랜덤 넘버 생성 갯수는 2개 for _ in 1...2
    // 랜덤 넘버 생성 레인지는 operandNums index 안에서


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

  @IBAction func numberBtnTapped(_ sender: UIButton) {
      tappedNums.append(operandNums[sender.tag])
    print("tappedNums: \(tappedNums)")
  }

//  func enableBtns(_ enabled: Bool  ) {
//    for btn in numberBtns {
//      btn.isEnabled = enabled
//    }
//  }









}

