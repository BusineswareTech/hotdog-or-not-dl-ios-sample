//
//  AllModelsSettingsViewController.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 10.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Reusable
import RxSwift
import RxSwiftExt

class AllModelsSettingsViewController: UIViewController {
    private let bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel = AllModelsSettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func initSetup() {
        tableView.register(cellType: SettingsModelInfoTableViewCell.self)
        tableView.tableFooterView = UIView()
        
        bindViewModel()
        setupCellTapHandling()
        viewModel.downloadModelsList()
        view.backgroundColor = Colors.gray
    }
    
    private func bindViewModel() {
        viewModel.allModelsList.bind(to: tableView.rx.items) {
            tableView, index, element in
            let indexPath = IndexPath(item: index, section: 0)
            let cell: SettingsModelInfoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.infoVM = SettingsModelInfoVM(dlModelInfo: element)
            cell.delegate = self
            
            return cell
        }.disposed(by: bag)
        
        viewModel.showProgressBar.bind { (showProgressBar) in
            self.activityIndicator.isHidden = !showProgressBar
        }.disposed(by: bag)
    }
    
    private func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(DLModelInfoItem.self)
            .subscribe(onNext: { [unowned self] dlModelInfoItem in
                self.viewModel.applyModel(dlModelInfoItem)
            })
            .disposed(by: bag)
    }
}

extension AllModelsSettingsViewController: SettingsModelInfoTableViewCellDelegate {
    func downloadButtonTapped(modelId: String) {
        viewModel.downloadModel(id: modelId)
    }
}

extension AllModelsSettingsViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
         return IndicatorInfo(title: NSLocalizedString("Settings.AllModelsTab.Text", comment: ""))
    }
}
