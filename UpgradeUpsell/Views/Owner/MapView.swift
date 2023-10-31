//
//  MapView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-31.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let latitude: Double
    let longitude: Double
    
//    @State var evntList:[Event] = []

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        
//        // Set the region of the map to center around the specified coordinates
//        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        uiView.setRegion(region, animated: true)
//        
//        // Optionally, add an annotation to mark the specified location
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
//        uiView.addAnnotation(annotation)
//    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        var coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if latitude == 0.0 && longitude == 0.0 {
            // If no user-provided coordinates, set the default region to Ontario
            coordinate = CLLocationCoordinate2D(latitude: 51.2538, longitude: -85.3232) // Ontario's approximate center coordinates
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        uiView.addAnnotation(annotation)
    }
}

