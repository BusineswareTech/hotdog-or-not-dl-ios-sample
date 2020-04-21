//
//  DLModelUploadingViewController.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 18.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import UIKit
import MobileCoreServices
import RxSwift

protocol DLModelUploadingViewControllerDelegate {
    func cancelTapped()
    func modelUploaded(completion: (() -> Void)?)
}

class DLModelUploadingViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var uploadImageComponentView: ProgressableImageView!
    @IBOutlet weak var uploadModelImageView: ProgressableImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    private let viewModel = DLModelUploadingViewModel()
    private let interactor = DI.getDLModelsInteractor()
    private let bag = DisposeBag()
    
    var delegate: DLModelUploadingViewControllerDelegate?
    
    var uploadCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSetup()
    }
    
    override func viewDidLayoutSubviews() {
        let buttonHeight = cancelButton.frame.size.height
        
        cancelButton.layer.cornerRadius = buttonHeight / 2
        uploadButton.layer.cornerRadius = buttonHeight / 2
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("Cancel all tapped")
        delegate?.cancelTapped()
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        print("Upload all tapped")
        viewModel.uploadTapped()
    }
    
    private func initSetup() {
        infoView.layer.cornerRadius = 10
        
        setupBlur()
        setupTextField()
        setupUploadImageComponent()
        setupUploadModelImageComponent()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        textField.rx.text
            .orEmpty
            .bind(to: viewModel.name)
            .disposed(by: bag)
        
        viewModel.modelProgress.bind { [weak self] (progress) in
            self?.uploadModelImageView.progressValue = progress
        }.disposed(by: bag)
        
        viewModel.imageProgress.bind { [weak self] (progress) in
            self?.uploadImageComponentView.progressValue = progress
        }.disposed(by: bag)
        
        viewModel.isModelUploaded.bind { [weak self] value in
            if value {
                self?.delegate?.modelUploaded(completion: self?.uploadCompletion)
            }
        }.disposed(by: bag)
        
        viewModel.errorMessage.asObservable()
        .map { [weak self] error in
            let alertController = UIAlertController()
            alertController.message = error
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alertController, animated: true, completion: nil)
        }
        .subscribe()
        .disposed(by: bag)
    }
    
    private func setupTextField() {
        textField.layer.cornerRadius = textField.frame.size.height / 2
        textField.clipsToBounds = true
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("ModelUploading.TextField.Placeholder", comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    private func setupBlur() {
        let blurView = UIVisualEffectView()
        blurView.frame = backgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 0.8
        blurView.clipsToBounds = true
        backgroundView.addSubview(blurView)
    }
    
    private func setupUploadImageComponent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleUploadImageTapped(_:)))

        uploadImageComponentView.addGestureRecognizer(tap)
        uploadImageComponentView.isUserInteractionEnabled = true
        
        uploadImageComponentView.image = UIImage(named: "NonActiveImageIcon.png")
        uploadImageComponentView.text = NSLocalizedString("UploadingScreen.ImagePicker.Text", comment: "")
        uploadImageComponentView.progressValue = 0
    }
    
    @objc func handleUploadImageTapped(_ sender: UITapGestureRecognizer) {
        print("Upload image tapped")
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen

        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func setupUploadModelImageComponent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleUploadModelTapped(_:)))

        uploadModelImageView.addGestureRecognizer(tap)
        uploadModelImageView.isUserInteractionEnabled = true
        
        uploadModelImageView.image = UIImage(named: "ActiveImageIcon.png")
        uploadModelImageView.text = NSLocalizedString("UploadingScreen.ModelPicker.Text", comment: "")
        uploadModelImageView.progressValue = 0
    }
    
    @objc func handleUploadModelTapped(_ sender: UITapGestureRecognizer) {
        print("Upload model tapped")
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.onnx", "public.mlmodel", "public.pt", String(kUTTypeContent), String(kUTTypeItem)], in: UIDocumentPickerMode.import)

        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen

        self.present(documentPicker, animated: true, completion: nil)
    }
}

extension DLModelUploadingViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        viewModel.fileChosen(url: urls.first?.absoluteString)
//        uploadModelImageView.image = UIImage(named: "CheckboxIcon.png")
        uploadModelImageView.isChosen = true
    }
}

extension DLModelUploadingViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImageComponentView.image = pickedImage
            uploadImageComponentView.isChosen = true
        }
        
        if let imgURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            viewModel.imgChosen(url: imgURL)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension DLModelUploadingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
