//
//  CalculatorVC.swift
//  Calculator
//
//  Created by Malcolm Kumwenda on 2017/09/18.
//  Copyright © 2017 Byte Orbit. All rights reserved.
//

import UIKit
import SnapKit

class CalculatorVC: UIViewController {

    private lazy var topView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var bottomView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var resultView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    private lazy var operationView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        return v
    }()
    
    private lazy var resultLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Futura-Bold", size: 40)
        l.textColor = .white
        l.textAlignment = .right
        return l
    }()
    
    var currentText = "0" {
        didSet {
           resultLabel.text = currentText
        }
    }
    fileprivate var safeArea: UILayoutGuide!
    fileprivate let standardPadding = UIEdgeInsetsMake(8, 8, 8, 8)
    
    let cancelBtn = CalculatorBtn(op: "C", color: Theme.red.color, tag: -1, math: .cancel)
    let decimalBtn = CalculatorBtn(op: ".", color: Theme.light.color, tag: -1)
    let equalBtn = CalculatorBtn(op: "=", color: Theme.teal.color, tag: -1, math: .equal)
    let openBracBtn = CalculatorBtn(op: "(", color: Theme.light.color, tag: -1, math: .openBrac)
    let closeBracBtn = CalculatorBtn(op: ")", color: Theme.light.color, tag: -1, math: .closeBrac)
    let zeroBtn = CalculatorBtn(op: "0", color: Theme.btn.color, tag: 0)
    let plusBtn = CalculatorBtn(op: "+", color: Theme.blue.color, tag: -1, math: .plus)
    let minusBtn = CalculatorBtn(op: "-", color: Theme.orange.color, tag: -1, math: .minus)
    let divideBtn = CalculatorBtn(op: "/", color: Theme.purple.color, tag: -1, math: .divide)
    lazy var numberBtns: [CalculatorBtn] = {
        let buttons = self.createNumberButtons(numbers: [1,2,3,4,5,6,7,8,9])
        return buttons
    }()
    
    lazy var allCalculatorButtons: [CalculatorBtn] = {
        var buttons = [self.cancelBtn,
                       self.decimalBtn,
                       self.equalBtn,
                       self.openBracBtn,
                       self.closeBracBtn,
                       self.zeroBtn,
                       self.plusBtn,
                       self.minusBtn,
                       self.divideBtn
                        ]
        for btn in self.numberBtns {
            buttons.append(btn)
        }
        return buttons
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.safeAreaLayoutGuide
        configureView()
        setupSelectors()
        setupResultLabel()
    }
    
    func configureView(){
        view.backgroundColor = Theme.grey.color
        
        view.addSubview(topView)
        topView.snp.makeConstraints{ make in
            make.top.equalTo(safeArea.snp.top)
            make.width.equalTo(safeArea.snp.width)
            make.height.equalTo(safeArea.snp.height).multipliedBy(0.40)
        }
        
        topView.addSubview(resultView)
        resultView.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().offset(-16)
            make.centerX.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        topView.addSubview(operationView)
        operationView.snp.makeConstraints{ make in
            make.bottom.equalTo(resultView.snp.top)
            make.top.equalTo(safeArea.snp.top)
            make.width.equalToSuperview()
        }
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints{ make in
            make.bottom.equalTo(safeArea.snp.bottom)
            make.width.equalTo(safeArea.snp.width)
            make.height.equalTo(safeArea.snp.height).multipliedBy(0.60)
        }
    
        setupButtons()
    }
    
    func updateResultText(){
        
    }
    
    func setupButtons(){
        
        bottomView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.bottom)
            make.left.equalTo(bottomView.snp.left)
            make.width.equalTo(bottomView.snp.width).multipliedBy(0.25)
            make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
        }
        
        bottomView.addSubview(decimalBtn)
        decimalBtn.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.left.equalTo(cancelBtn.snp.right).offset(3)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
        }
        
        bottomView.addSubview(equalBtn)
        equalBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(bottomView.snp.bottom)
            make.left.equalTo(decimalBtn.snp.right).offset(3)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
        }

        bottomView.addSubview(zeroBtn)
        zeroBtn.snp.makeConstraints { make in
            make.bottom.equalTo(cancelBtn.snp.top).offset(-3)
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
        }

        bottomView.addSubview(openBracBtn)
        openBracBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(zeroBtn)
            make.left.equalTo(zeroBtn.snp.right).offset(3)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
        }

        bottomView.addSubview(closeBracBtn)
        closeBracBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(zeroBtn)
            make.left.equalTo(openBracBtn.snp.right).offset(3)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
        }

        layoutNumbers()
        
        bottomView.addSubview(plusBtn)
        plusBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(closeBracBtn.snp.bottom)
            make.top.equalTo(numberBtns[2].snp.top)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.left.equalTo(closeBracBtn.snp.right).offset(3)
        }
        
        bottomView.addSubview(minusBtn)
        minusBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(plusBtn.snp.top).offset(-3)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.left.equalTo(numberBtns[5].snp.right).offset(3)
        }
        
        bottomView.addSubview(divideBtn)
        divideBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(minusBtn.snp.top).offset(-3)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.left.equalTo(numberBtns[5].snp.right).offset(3)
        }
    }
    
    func createNumberButtons(numbers: [Int]) -> [CalculatorBtn] {
        var buttons = [CalculatorBtn]()
        for number in numbers {
            buttons.append(CalculatorBtn(op: "\(number)", color: Theme.btn.color, tag: number))
        }
        return buttons
    }
    
    func layoutNumbers(){
        // display numbers
        for (index, btn) in numberBtns.enumerated() {
            // FIX-ME: This could be done much better with some maths and cool loops but not in the mood to crack my mind
            bottomView.addSubview(btn)
            switch btn.tag {
            case 1:
                btn.snp.makeConstraints{ make in
                    make.left.equalTo(cancelBtn)
                    make.bottom.equalTo(zeroBtn.snp.top).offset(-3)
                    make.width.equalToSuperview().multipliedBy(0.25)
                    make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
                }
            case 2:
                btn.snp.makeConstraints{ make in
                    make.centerX.equalTo(openBracBtn)
                    make.bottom.equalTo(zeroBtn.snp.top).offset(-3)
                    make.width.equalToSuperview().multipliedBy(0.25)
                    make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
                }
            case 3:
                btn.snp.makeConstraints{ make in
                    make.centerX.equalTo(closeBracBtn)
                    make.bottom.equalTo(zeroBtn.snp.top).offset(-3)
                    make.width.equalToSuperview().multipliedBy(0.25)
                    make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
                }
            case 4:
                btn.snp.makeConstraints{ make in
                    make.centerX.equalTo(cancelBtn)
                    make.bottom.equalTo(numberBtns[0].snp.top).offset(-3)
                    make.width.equalToSuperview().multipliedBy(0.25)
                    make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
                }
            case 5:
                btn.snp.makeConstraints{ make in
                    make.centerX.equalTo(openBracBtn)
                    make.centerY.equalTo(numberBtns[index-1])
                    make.width.equalToSuperview().multipliedBy(0.25)
                    make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
                }
            case 6:
                btn.snp.makeConstraints{ make in
                    make.centerX.equalTo(closeBracBtn)
                    make.centerY.equalTo(numberBtns[index-1])
                    make.width.equalToSuperview().multipliedBy(0.25)
                    make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
                }
            case 7:
                btn.snp.makeConstraints{ make in
                    make.centerX.equalTo(cancelBtn)
                    make.bottom.equalTo(numberBtns[4].snp.top).offset(-3)
                    make.width.equalToSuperview().multipliedBy(0.25)
                    make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
                }
            case 8:
                btn.snp.makeConstraints{ make in
                    make.centerX.equalTo(closeBracBtn)
                    make.centerY.equalTo(numberBtns[index-1])
                    make.width.equalToSuperview().multipliedBy(0.25)
                    make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
                }
            case 9:
                btn.snp.makeConstraints{ make in
                    make.centerX.equalTo(openBracBtn)
                    make.centerY.equalTo(numberBtns[index-1])
                    make.width.equalToSuperview().multipliedBy(0.25)
                    make.height.equalTo(bottomView.snp.height).multipliedBy(0.2)
                }
            default:
                return
            }
        }
    }

    func setupSelectors(){
        for btn in allCalculatorButtons {
            btn.addTarget(self, action: #selector(performOperation(_:)), for: .touchUpInside)
        }
    }
    
    func setupResultLabel(){
        resultView.addSubview(resultLabel)
        resultLabel.snp.makeConstraints{ make in
            make.edges.equalToSuperview().inset(4)
        }

        resultLabel.text = currentText
    }
    
    @objc func performOperation(_ sender: CalculatorBtn){
        sender.zoomIn()
        switch sender.math {
        case .nothing:
            if currentText == "0" {
                currentText = "\(sender.tag)"
            }else {
                let text = currentText
                currentText = text.appending("\(sender.tag)")
            }
        case .plus:
            print("plus:", sender.math)
        case .minus:
            print("minus:", sender.math)
        case .divide:
            print("divide:", sender.math)
        case .openBrac:
            print("open:", sender.tag)
        case .closeBrac:
            print("close:", sender.tag)
        case .cancel:
            currentText = "0"
        case .equal:
            print("equal:", sender.tag)
        default:
            if currentText == "0" {
                currentText = "\(sender.tag)"
            }else {
                let text = currentText
                currentText = text.appending("\(sender.tag)")
            }
        }
    }
}
















