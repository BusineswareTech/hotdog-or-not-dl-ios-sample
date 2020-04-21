//
//  RoundedButton.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 21.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
