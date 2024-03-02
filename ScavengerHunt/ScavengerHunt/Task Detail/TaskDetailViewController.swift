//
//  TaskDetailViewController.swift
//  ScavengerHunt
//
//  Created by Topu Saha on 2/29/24.
//

import UIKit
import PhotosUI
import MapKit

class TaskDetailViewController: UIViewController {
    

    @IBOutlet weak var detailedCompletedImage: UIImageView!
    
    var task: Task!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var taskDescription: UILabel!
    
    @IBOutlet weak var completedSignal: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        


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
    private func showAlert(for error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateUI() {
        
        let image = UIImage(systemName: task.completed! ? "circle.inset.filled" : "circle")
        detailedCompletedImage.image = image?.withRenderingMode(.alwaysTemplate)
        let color: UIColor = task.completed! ? .systemBlue : .tertiaryLabel
        
        detailedCompletedImage.tintColor = color
        taskName.textColor = color
        taskDescription.textColor = color
        
        print("Image Loaded: \(image != nil)")
        print("ImageView Image Set")


        
        
    }
    
    private func updateMapView() {
        guard let coordinates = self.task.location else {return}
        
        
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        map.addAnnotation(annotation)
        
        map.register(TaskAnnotationView.self, forAnnotationViewWithReuseIdentifier: TaskAnnotationView.identifier)

    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let result = results.first
        
        guard let assetId = result?.assetIdentifier,
              let location = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).firstObject?.location else {
            return
        }

        print("📍 Image location coordinate: \(location.coordinate)")

        
        
        guard let provider = result?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {return}
        
        self.task.completed = true
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            
            if let error = error {
                DispatchQueue.main.async { [weak self] in self?.showAlert(for:error) }
            }
            
            guard let image = object as? UIImage else { return }

            print("🌉 We have an image!")
            
            DispatchQueue.main.async { [weak self] in

                    // Set the picked image and location on the task
                    self?.task.image = image
                    self?.task.location = location.coordinate

                    // Update the UI since we've updated the task
                    self?.updateUI()

                    // Update the map view since we now have an image an location
                    self?.updateMapView()
                }
        }
    }
}

extension TaskDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

       
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: TaskAnnotationView.identifier, for: annotation) as? TaskAnnotationView else {
            fatalError("Unable to dequeue TaskAnnotationView")
        }

        annotationView.configure(with: task.image)
        return annotationView
    }
    
}


