//
//  DocumentManager.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 18.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class DocumentManager: NSObject, UIDocumentPickerDelegate {
    var vc: UIViewController?
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("Picker")
        guard let myURL = urls.first else {
           return
        }
        print("import result : \(myURL)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        
    }
    
    func startFilePicking(viewController: UIViewController) {
        vc = viewController
        
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.onnx", "public.mlmodel", "public.pt", String(kUTTypeContent), String(kUTTypeItem)], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        vc?.present(documentPicker, animated: true, completion: nil)
    }
}
