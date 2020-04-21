//
//  Tutorial1ViewController.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 25.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import UIKit

protocol TutorialViewControllerDelegate: AnyObject {
    func nextButtonTapped()
}

class TutorialViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var delegate: TutorialViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSetup()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        UserManager.shared.setTutorialShown(true)
        delegate?.nextButtonTapped()
    }
    
    
    private func initSetup() {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        label1.text = NSLocalizedString("Tutorial.Label1.Text", comment: "")
        label2.text = NSLocalizedString("Tutorial.Label2.Text", comment: "")
        nextButton.titleLabel?.text = NSLocalizedString("Tutorial.NextButton.Text", comment: "")
    }
}
