//
//  Task.swift
//  ScavengerHunt
//
//  Created by Topu Saha on 2/27/24.
//

import Foundation
import CoreLocation
import PhotosUI

struct Task {
    var name: String?
    var completed: Bool?
    var description: String
    var image: UIImage?
    var location: CLLocationCoordinate2D?
    
}
