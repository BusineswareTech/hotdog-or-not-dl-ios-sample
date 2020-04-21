//
//  SettingsViewController.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 25.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import UIKit
import XLPagerTabStrip



class SettingsViewController: ButtonBarPagerTabStripViewController {
    
    var navigationDelegate: SettingsScreenDelegate?

    override func viewDidLoad() {
        configureButtonBar()
        super.viewDidLoad()

        view.backgroundColor = Colors.gray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

         let child1 = UIStoryboard.init(name: "Model", bundle: nil).instantiateViewController(withIdentifier: "AllModelsSettingsViewController") as! AllModelsSettingsViewController

         let child2 = UIStoryboard.init(name: "Model", bundle: nil).instantiateViewController(withIdentifier: "UserModelsSettingsViewController") as! UserModelsSettingsViewController
        
        child2.delegate = navigationDelegate

         return [child1, child2]
    }
    
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        navigationController?.navigationBar.topItem?.title = ""
        
        title = NSLocalizedString("Settings.NavBar.Text", comment: "")
    }
    
    private func configureButtonBar() {
         // Sets the background colour of the pager strip and the pager strip item
        settings.style.buttonBarBackgroundColor = Colors.gray
        settings.style.buttonBarItemBackgroundColor = Colors.gray

         // Sets the pager strip item font and font color
         settings.style.buttonBarItemFont = UIFont(name: "Helvetica", size: 16.0)!
        settings.style.buttonBarItemTitleColor = .white

         // Sets the pager strip item offsets
        settings.style.buttonBarMinimumLineSpacing = 5
        settings.style.buttonBarMinimumInteritemSpacing = 5
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 5
        settings.style.buttonBarRightContentInset = 5
        

         // Sets the height and colour of the slider bar of the selected pager tab
        settings.style.selectedBarHeight = 3.0
        settings.style.selectedBarBackgroundColor = .yellow

         // Changing item text color on swipe
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.alpha = 0.45
            newCell?.label.alpha = 1
        }
    }

}
