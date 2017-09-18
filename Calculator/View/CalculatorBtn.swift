//
//  CalculatorBtn.swift
//  Calculator
//
//  Created by Malcolm Kumwenda on 2017/09/18.
//  Copyright © 2017 Byte Orbit. All rights reserved.
//

import UIKit

class CalculatorBtn: UIButton {
    
    private var color: UIColor!
    var operation: String!
    var math: MathOp = .nothing 
    
    enum MathOp {
        case plus, minus, divide, cancel, nothing, equal, openBrac, closeBrac
    }
    
    
    func setupView(){
        self.backgroundColor = color
        let text = NSAttributedString(string: operation,
                                      attributes: [NSAttributedStringKey.font :  UIFont(name: "Futura-Medium", size: 40)!,
                                                   NSAttributedStringKey.foregroundColor : UIColor.white ])
        self.setAttributedTitle(text, for: .normal)
    }
    
    required init(op: String, color: UIColor, tag: Int, math: MathOp = .nothing) {
        super.init(frame: .zero)
        self.tag = tag
        self.color = color
        self.operation = op
        self.math = math
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalculatorBtn {
    func zoomIn(duration: TimeInterval = 0.1) {
        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
