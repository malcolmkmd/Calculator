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
    
    fileprivate enum OperatorType {
        case equal, clear, cancel, function
        
        var action: Int {
            switch self {
            case .equal: return -2
            case .clear: return -3
            case .cancel: return -4
            case .function: return -1
            }
        }
    }
    
    fileprivate var isOperationLocked = false
    fileprivate var operations = [String]() {
        didSet {
            operations.reverse()
            self.tableView.reloadData()
        }
    }
    
    fileprivate lazy var topView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    fileprivate lazy var bottomView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    fileprivate lazy var resultView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    fileprivate lazy var resultLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Futura-Bold", size: 40)
        l.textColor = .white
        l.textAlignment = .right
        return l
    }()
    
    fileprivate lazy var equalLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Futura-Bold", size: 40)
        l.textColor = Theme.white.color
        l.textAlignment = .center
        l.text = "="
        return l
    }()
    
    fileprivate var currentText = "0.0" {
        didSet {
            resultLabel.text = currentText
        
            if currentText.isEmpty {
                resultLabel.text = "0.0"
                currentText = "0.0"
            }
        }
    }
    
    fileprivate var safeArea: UILayoutGuide!
    
    fileprivate let tableView = UITableView()
    
    fileprivate let zeroBtn = CalculatorBtn(op: "0", tag: 0)
    fileprivate let equalBtn = CalculatorBtn(op: "=", color: Theme.red.color, tag: OperatorType.equal.action)
    fileprivate let cancelBtn = CalculatorBtn(op: "AC", color: Theme.blue.color, tag: OperatorType.clear.action)
    fileprivate let percentBtn = CalculatorBtn(op: "C", color: Theme.blue.color, tag: OperatorType.cancel.action)
    fileprivate let decimalBtn = CalculatorBtn(op: ".", tag: -1)
    fileprivate let multiplyBtn = CalculatorBtn(op: "*", color: Theme.blue.color, tag: -1)
    fileprivate let plusBtn = CalculatorBtn(op: "+", color: Theme.blue.color, tag: -1)
    fileprivate let minusBtn = CalculatorBtn(op: "-", color: Theme.blue.color, tag: -1)
    fileprivate let divideBtn = CalculatorBtn(op: "/", color: Theme.blue.color, tag: -1)
    fileprivate lazy var numberBtns: [CalculatorBtn] = {
        let buttons = self.createNumberButtons(numbers: [1,2,3,4,5,6,7,8,9])
        return buttons
    }()
    fileprivate lazy var allCalculatorButtons: [CalculatorBtn] = {
        var buttons = [self.cancelBtn,
                       self.decimalBtn,
                       self.equalBtn,
                       self.multiplyBtn,
                       self.percentBtn,
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
    
    fileprivate let lockOperations = [".", "*", "+", "-", "/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func createNumberButtons(numbers: [Int]) -> [CalculatorBtn] {
        var buttons = [CalculatorBtn]()
        for number in numbers {
            buttons.append(CalculatorBtn(op: "\(number)", tag: number))
        }
        return buttons
    }
    
    func configureView(){
        safeArea = view.safeAreaLayoutGuide
        setupViews()
        setupButtons()
        setupResultLabel()
        setupOperationsTableView()
        setupSelectors()
    }
    
    func setupViews(){
        view.backgroundColor = Theme.bg.color
        
        view.addSubview(topView)
        topView.snp.makeConstraints{ make in
            make.top.equalTo(safeArea.snp.top)
            make.left.right.equalTo(safeArea)
            make.height.equalTo(safeArea).multipliedBy(0.4)
        }
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints{ make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalTo(safeArea)
            make.height.equalTo(safeArea).multipliedBy(0.6)
        }
        
        addGradientMask(to: self.view)
    }
    
    func addGradientMask(to view: UIView){
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.07)
        
        view.layer.mask = gradient
    }
    
    func setupButtons(){
        bottomView.addSubview(zeroBtn)
        zeroBtn.snp.makeConstraints{ make in
            make.left.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        bottomView.addSubview(decimalBtn)
        decimalBtn.snp.makeConstraints{ make in
            make.left.equalTo(zeroBtn.snp.right).offset(2)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(zeroBtn)
        }
        
        bottomView.addSubview(equalBtn)
        equalBtn.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.left.equalTo(decimalBtn.snp.right).offset(2)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        // Column 4
        bottomView.addSubview(plusBtn)
        plusBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(equalBtn.snp.top).offset(-2)
            make.left.equalTo(decimalBtn.snp.right).offset(2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        bottomView.addSubview(minusBtn)
        minusBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(plusBtn.snp.top).offset(-2)
            make.left.equalTo(decimalBtn.snp.right).offset(2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        bottomView.addSubview(divideBtn)
        divideBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(minusBtn.snp.top).offset(-2)
            make.left.equalTo(decimalBtn.snp.right).offset(2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        bottomView.addSubview(multiplyBtn)
        multiplyBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(divideBtn.snp.top).offset(-2)
            make.left.equalTo(decimalBtn.snp.right).offset(2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        
        // Column Three
        bottomView.addSubview(numberBtns[2])
        numberBtns[2].snp.makeConstraints{ make in
            make.left.equalTo(zeroBtn.snp.right).offset(2)
            make.bottom.equalTo(decimalBtn.snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        bottomView.addSubview(numberBtns[5])
        numberBtns[5].snp.makeConstraints{ make in
            make.left.equalTo(zeroBtn.snp.right).offset(2)
            make.bottom.equalTo(numberBtns[2].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        bottomView.addSubview(numberBtns[8])
        numberBtns[8].snp.makeConstraints{ make in
            make.left.equalTo(zeroBtn.snp.right).offset(2)
            make.bottom.equalTo(numberBtns[5].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        bottomView.addSubview(percentBtn)
        percentBtn.snp.makeConstraints{ make in
            make.left.equalTo(zeroBtn.snp.right).offset(2)
            make.bottom.equalTo(numberBtns[8].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        // Column One
        bottomView.addSubview(numberBtns[0])
        numberBtns[0].snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.bottom.equalTo(decimalBtn.snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        bottomView.addSubview(numberBtns[3])
        numberBtns[3].snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.bottom.equalTo(numberBtns[0].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        bottomView.addSubview(numberBtns[6])
        numberBtns[6].snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.bottom.equalTo(numberBtns[3].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        bottomView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.bottom.equalTo(numberBtns[6].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        // Column Two
        bottomView.addSubview(numberBtns[1])
        numberBtns[1].snp.makeConstraints{ make in
            make.right.equalTo(zeroBtn.snp.right)
            make.bottom.equalTo(decimalBtn.snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25).offset(-2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        bottomView.addSubview(numberBtns[4])
        numberBtns[4].snp.makeConstraints{ make in
            make.right.equalTo(zeroBtn.snp.right)
            make.bottom.equalTo(numberBtns[1].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25).offset(-2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        bottomView.addSubview(numberBtns[7])
        numberBtns[7].snp.makeConstraints{ make in
            make.right.equalTo(zeroBtn.snp.right)
            make.bottom.equalTo(numberBtns[4].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25).offset(-2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
    }
    
    func setupOperationsTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OperationTableViewCell.self)
        topView.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(resultLabel.snp.top).offset(4)
        }
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi));
        tableView.backgroundColor = Theme.bg.color
    }
    
    func setupResultLabel(){
        topView.addSubview(equalLabel)
        equalLabel.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.bottom.equalToSuperview()
        }
        
        topView.addSubview(resultLabel)
        resultLabel.snp.makeConstraints{ make in
            make.right.equalToSuperview().inset(4)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.bottom.equalToSuperview()
            make.left.equalTo(equalLabel.snp.right)
        }
        resultLabel.text = currentText
    }
}


extension CalculatorVC {
    @objc func performOperation(_ sender: CalculatorBtn){
        sender.zoomIn()
        
        if currentText.characters.count == 10 {
            currentText = "0.0"
        }
        equalLabel.isHidden = true
        if sender.tag == OperatorType.equal.action {
            doMath()
        }else if sender.tag == OperatorType.clear.action {
            if currentText == "0.0" { operations.removeAll() }
            currentText = "0.0"
        }else if sender.tag == OperatorType.cancel.action {
            currentText = "\(currentText.dropLast())"
        }else if lockOperations.contains((currentText.characters.last?.description)!) && sender.tag == -1 {
            return
        }else if sender.tag == -1 && currentText == "0.0" {
            return
        } else if sender.tag >= -1 {
            if currentText == "0.0" && !equalBtn.isHidden {
                currentText = sender.operation
            }else {
                currentText = currentText.appending(sender.operation)
            }
        }
        
        tableView.scrollsToTop = true
    }
    
    func setupSelectors(){
        for btn in allCalculatorButtons {
            btn.addTarget(self, action: #selector(performOperation(_:)), for: .touchUpInside)
        }
    }
    
    func doMath(){
        equalLabel.isHidden = !equalLabel.isHidden
        guard currentText != "0.0" else { return }
        operations.append(currentText)
        let expression = NSExpression(format: currentText)
        guard let mathValue = expression.expressionValue(with: nil, context: nil) as? Double else { return }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        guard let value = formatter.string(from: NSNumber(value: mathValue)) else { return }
        currentText = value 
    }
}

extension CalculatorVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as OperationTableViewCell
        cell.label.text = operations[indexPath.row]
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi));
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? OperationTableViewCell,
            let operation = cell.label.text else { return }
        currentText = operation
    }
   
}














