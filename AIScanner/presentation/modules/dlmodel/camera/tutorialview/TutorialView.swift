//
//  TutorialView.swift
//  AIScanner
//
//  Created by Alexandr Mikhailov on 03.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import UIKit
import Reusable

final class TutorialView: UIView, NibOwnerLoadable {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
    override func awakeFromNib() {
        setupLabels()
        setupBlur()
    }
    
    override func layoutSubviews() {
        let minPointSize = min(label1.font.pointSize, label2.font.pointSize)
        label1.font.withSize(minPointSize)
        label2.font.withSize(minPointSize)
    }
    
    private func setupBlur() {
        let blurView = UIVisualEffectView()
        blurView.frame = backgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 0.7
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        backgroundView.addSubview(blurView)
    }
    
    func setupLabels() {
        label1.text = NSLocalizedString("Tutorial.Label1.Text", comment: "")
        label2.text = NSLocalizedString("Tutorial.Label2.Text", comment: "")
        
    }
}
