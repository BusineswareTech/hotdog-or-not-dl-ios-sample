//
//  SettingsModelInfoTableViewCell.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 11.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

protocol SettingsModelInfoTableViewCellDelegate: class {
    func downloadButtonTapped(modelId: String)
}

class SettingsModelInfoTableViewCell: UITableViewCell, NibReusable {
    var infoVM: SettingsModelInfoVM? {
        didSet {
            updateUI()
        }
    }
    
    weak var delegate: SettingsModelInfoTableViewCellDelegate?
        
    @IBOutlet weak var modelImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var successIconImageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var progressBar: CircularProgressView!
    @IBOutlet weak var activeIndicatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressBar.trackClr = .clear
        progressBar.progressClr = Colors.appGreen
        updateUI()
    }
    
    private func updateUI() {
        modelImageView.image = UIImage(named: "DefaultIndicatorIcon.png")
        guard let infoVM = infoVM else {
            return
        }
        modelImageView.kf.setImage(with: URL(string: infoVM.imgURL ?? ""))
        nameLabel.text = infoVM.name
        activeIndicatorImageView.isHidden = !infoVM.isActive
        
        if infoVM.isActive {
            backgroundColor = UIColor.gray
        } else {
            backgroundColor = UIColor.clear
        }
        
        setActiveButton()
    }
    
    private func setActiveButton() {
        guard let infoVM = self.infoVM else { return }
        
        switch infoVM.downloadingStatus {
        case .downloaded:
            self.downloadButton.isHidden = true
            self.progressBar.isHidden = true
        case .downloading:
            self.downloadButton.isHidden = true
            self.progressBar.isHidden = false
            self.progressBar.setProgressWithAnimation(duration: 0.1, value: Float(infoVM.progress!))
        case .notDownloaded:
            self.downloadButton.isHidden = false
            self.progressBar.isHidden = true
        }
    }
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        if let infoVM = self.infoVM, let id = infoVM.id {
            delegate?.downloadButtonTapped(modelId: id)
        }
    }
}
