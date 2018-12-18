//
//  CalculatorBtn.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 01/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit

class CalculatorBtn: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
  /*
    private var color: UIColor!
    var operation: String!
    
    
    
    func setupView(){
        self.backgroundColor = color
        let symbols = ["X","-","+","/","=","%"]
       
    
        if operation == "mike"{
            self.titleLabel?.textColor = .clear
            self.setImage(UIImage(named: "mike"), for: .normal)
        }else if operation == "C"{
            self.titleLabel?.textColor = .clear
            self.setImage(UIImage(named: "voice"), for: .normal)
        }else if operation == "AC" {
            self.titleLabel?.textColor = .clear
            self.setImage(UIImage(named: "clear"), for: .normal)
        }else{
            self.titleLabel?.textColor = .black
            
            // self.setAttributedTitle(text, for: .normal)
        }
        
        if symbols.contains(operation){
            
            if operation == "-"{
                self.setAttributedTitle(nil, for: .normal)
                self.setImage(UIImage(named:"-"), for: .normal)
            }else if operation == "+"{
                self.setAttributedTitle(nil, for: .normal)
                self.setImage(UIImage(named:"+"), for: .normal)
            }else if operation == "X"{
                self.setAttributedTitle(nil, for: .normal)
                self.setImage(UIImage(named:"X"), for: .normal)
            }else if operation == "/"{
                self.setAttributedTitle(nil, for: .normal)
                self.setImage(UIImage(named:"divide"), for: .normal)
            }else{
                self.setAttributedTitle(nil, for: .normal)
                self.setImage(UIImage(named: operation!), for: .normal)
            }
        }else{
            self.backgroundColor = UIColor.clear
            if operation == "."{
                self.setAttributedTitle(nil, for: .normal)
                self.setImage(UIImage(named: "dot"), for: .normal)
            }
            
            let numbersRange = operation.rangeOfCharacter(from: .decimalDigits)
            if (numbersRange != nil){
                //  self.setAttributedTitle(text, for: .normal)
                // self.setImage(UIImage(named: "\(operation!)"), for: .normal)
                
                
                if let op =  operation  {
                    let img = UIImage(named:op)
                    self.setImage(img, for: .normal)
                }
                
            }
        }
        
        
        
        
        
        
        self.layer.cornerRadius = 2
    }
    
    required init(op: String, color: UIColor = Theme.white.color, tag: Int) {
        super.init(frame: .zero)
        self.color = color
        self.operation = op
        self.tag = tag
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
}


extension CalculatorBtn {
    func zoomIn(duration: TimeInterval = 0.1) {
        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
