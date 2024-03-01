//
//  TaskDetailViewController.swift
//  ScavengerHunt
//
//  Created by Topu Saha on 2/29/24.
//

import UIKit
import PhotosUI

class TaskDetailViewController: UIViewController {
    

    var task: Task!
    
    
    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var taskDescription: UILabel!
    
    @IBOutlet weak var completedSignal: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        taskName.text = task.name
        taskName.numberOfLines = 0
        taskDescription.text = task.description
        taskDescription.numberOfLines = 0
        
    }
    
    
    private func presentGoToSettingsAlert() {
           let alert = UIAlertController(
               title: "Permission Required",
               message: "Please grant access to your photo library in Settings.",
               preferredStyle: .alert
           )

           let goToSettingsAction = UIAlertAction(
               title: "Go to Settings",
               style: .default
           ) { _ in
               if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
               }
           }

           let cancelAction = UIAlertAction(
               title: "Cancel",
               style: .cancel,
               handler: nil
           )

           alert.addAction(goToSettingsAction)
           alert.addAction(cancelAction)

           self.present(alert, animated: true, completion: nil)
       }

    @IBAction func upload(_ sender: Any) {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
            
            // Ask to authorized
            PHPhotoLibrary.requestAuthorization(for: .readWrite) {
                [weak self] status in
                switch status {
                case .authorized:
                            DispatchQueue.main.async {
                                self?.presentImagePicker()
                            }
                default:
                            DispatchQueue.main.async {
                                self?.presentGoToSettingsAlert()
                            }
                        }
            }
            
            
        }
        
        // show picker
        else {
            presentImagePicker()
        }
    }
    
    private func presentImagePicker() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        present(picker, animated: true)

    }
}

extension TaskDetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let result = results.first
        
        guard let assetId = result?.assetIdentifier,
              let location = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).firstObject?.location else {
            return
        }

        print("📍 Image location coordinate: \(location.coordinate)")
        
    }
    
    
    
    
}
