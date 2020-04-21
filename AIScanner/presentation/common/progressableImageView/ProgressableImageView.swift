//
//  ProgressableImageView.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 21.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import UIKit
import Reusable

class ProgressableImageView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var progressBar: CircularProgressView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var innerArea: UIView!
    @IBOutlet weak var isChosenImageView: UIImageView!
    
    var progressValue: Double = 0.0 {
        didSet {
            progressBar.setProgressWithAnimation(duration: 0.1, value: Float(progressValue))
            successImageView.isHidden = Int(progressValue) != 1
        }
    }
    
    var isChosen: Bool = false {
        didSet {
            isChosenImageView.isHidden = !isChosen
        }
    }
    
    var imageURL: String = "" {
        didSet {
            imageIcon.image = UIImage(named: imageURL)
        }
    }
    
    var image: UIImage? {
        didSet {
            imageIcon.image = image
        }
    }
    
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    override func layoutSubviews() {
        innerArea.layer.cornerRadius = innerArea.frame.size.width / 2
        innerArea.clipsToBounds = true
        
        let halfWidth = progressBar.frame.size.width / 2
               
        let positionX = halfWidth * (1 + sin(.pi / 4))
        let positionY = halfWidth * (1 - sin(.pi / 4))

        successImageView.center = CGPoint(x: positionX, y: positionY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
        setupProgressBar()
    }
    
    func setupProgressBar() {
        progressBar.trackClr = .lightGray
        progressBar.lineWidth = 2
        progressBar.progressClr = Colors.appGreen
        isChosenImageView.isHidden = true
    }
}
