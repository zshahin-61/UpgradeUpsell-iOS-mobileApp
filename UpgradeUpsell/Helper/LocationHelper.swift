//
//  LocationHelper.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin 2023-10-14.


import Foundation
import CoreLocation
import Contacts

class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    private let geoCoder = CLGeocoder()
    
    private let locationManager = CLLocationManager()
    @Published var authorizationStatus : CLAuthorizationStatus = .notDetermined
    @Published var currentLocation : CLLocation?
    
    override init(){
        
        super.init()
        
        if (CLLocationManager.locationServicesEnabled()){
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        //check for permissions
        self.checkPermission()
        
        if (CLLocationManager.locationServicesEnabled() && (self.authorizationStatus == .authorizedAlways || self.authorizationStatus == .authorizedWhenInUse)){
            
            self.locationManager.startUpdatingLocation()
        }else{
            self.requestPermission()
        }
    }
    
    func requestPermission(){
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func checkPermission(){
        switch self.locationManager.authorizationStatus{
        case .denied:
            //enable or disable features based on location access
            self.requestPermission()
        case .notDetermined:
            self.requestPermission()
        case .restricted:
            //ask for precide location permission
            self.requestPermission()
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "Authorization Status changed : \(self.locationManager.authorizationStatus)")
        
        self.authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //process received locations
        
        if locations.last != nil{
            //most recent
            print(#function, "most recent location : \(locations.last!)")
            
            self.currentLocation = locations.last!
        }else{
            //oldest known location
            print(#function, "last known location : \(locations.first)")
            
            self.currentLocation = locations.first
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Error while trying to get location updates : \(error)")
    }
    
    deinit{
        self.locationManager.stopUpdatingLocation()
    }
    
    //street address to coordinates
    func doForwardGeocoding(address : String, completionHandler: @escaping(CLLocation?, NSError?) -> Void){
        
        self.geoCoder.geocodeAddressString(address, completionHandler: {
            (placemarks, error) in
            
            if (error != nil){
                print(#function, "Unable to obtain location coordinates for given address string - \(error)")
                
                completionHandler(nil, error as NSError?)
            }else{
                //try to access the first result from placemarks
                
                if let place = placemarks?.first{
                    //try to obtain lat and lng for the same
                    
                    let matchedLocation = place.location!
                    print(#function, "matchedLocation : \(matchedLocation)")
                    
                    //return the call with coordinates
                    completionHandler(matchedLocation, nil)
                    return
                }
                
                completionHandler(nil, error as NSError?)
            }
            
        })
        
    }
    
    //coordinates to street address
    func doReverseGeocoding(location : CLLocation, completionHandler: @escaping(String?, NSError?) -> Void){
        
        self.geoCoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) in
            
            if (error != nil){
                print(#function, "Unable to obtain street address for given coordinates - \(error)")
                
                completionHandler(nil, error as NSError?)
            }else{
                
                if let placemarkList = placemarks, let firstPlace = placemarks?.first{
                    //try to get street address from coordinates
                    
                    let street = firstPlace.thoroughfare ?? "NA"
                    let postalCode = firstPlace.postalCode ?? "NA"
                    let country = firstPlace.country ?? "NA"
                    let province = firstPlace.administrativeArea ?? "NA"
                    
                    print(#function, "\(street), \(postalCode), \(country), \(province)")
                    
                    let address = CNPostalAddressFormatter.string(from: firstPlace.postalAddress!, style: .mailingAddress)
                    
                    completionHandler(address, nil)
                    return
                    
                }
                
                completionHandler(nil, error as NSError?)
            }
        })
    }
}

