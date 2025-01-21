//
//  LocationService.swift
//  Atmos
//
//  Created by Michael Amiro on 21/01/2025.
//

import Combine
import Foundation
import CoreLocation

protocol LocationServiceDelegate: CLLocationManagerDelegate {
    var currentLocation: CurrentValueSubject<CLLocationCoordinate2D?, Error> { get }
    func requestForInUseAuthorization()
}

final class LocationService: NSObject, LocationServiceDelegate {
    private let locationManager = CLLocationManager()
    private var lastKnownLocation: CLLocationCoordinate2D?

    var currentLocation = CurrentValueSubject<CLLocationCoordinate2D?, Error>(nil)

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestForInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async { [weak self] in
            self?.currentLocation.send(location.coordinate)
        }
    }
}

enum LocationError: LocalizedError {
    case authStatusNotDetermined
    case unknownAuthStatus
    case restricted
    case denied
    case invalid
}
