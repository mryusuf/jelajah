//
//  LocationServices.swift
//  Jelajah
//
//  Created by Indra Permana on 02/07/22.
//

import RxSwift
import CoreLocation
import RxRelay

protocol LocationServiceProtocol: NSObject {
    func getCurrentLatituteLongitude() -> Observable<Center>
}

final class LocationService: NSObject, LocationServiceProtocol {
    
    private let locationManager = CLLocationManager()
    private var locationPublisher: PublishRelay<Center> = .init()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    deinit {
        self.locationManager.stopUpdatingLocation()
    }
    
    func getCurrentLatituteLongitude() -> Observable<Center> {
        locationPublisher.asObservable()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        // Handle changes if location permissions
    }
    

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            locationPublisher.accept(
                Center(latitude: latitude, longitude: longitude)
            )
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Set Singapore location if failure to get a user’s location
        locationPublisher.accept(
            Center(latitude: 1.290270, longitude: 103.851959)
        )
    }
}
