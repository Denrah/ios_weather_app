//
//  MapViewController.swift
//  ios_weather_app
//
//  Created by iOS Intern on 03/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPopup: MapPopup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureMap()
    }

    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = "Global Weather"
        
        /*self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 16.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.31
        self.navigationController?.navigationBar.layer.masksToBounds = false*/
        
        /*let navigationBarTitleView = MapNavigationBarTitle(frame: CGRect(x: 0, y: 0, width: 200, height: 96))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationBarTitleView)*/
        
        let searchController =  UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    private func configureMap() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
}

extension MapViewController: UISearchControllerDelegate {
    
}

extension MapViewController: UIGestureRecognizerDelegate {
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
    
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (placemarks, error) in
            guard error == nil else {
                return
            }
            
            self.mapPopup.city = placemarks?.first?.locality ?? ""
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
}
