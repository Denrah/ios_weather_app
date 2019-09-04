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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPopup: MapPopup!
    @IBOutlet weak var navbarShadowView: UIView!
    @IBOutlet weak var popupBottomConstraint: NSLayoutConstraint!
    
    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    var viewModel: MapViewModel! {
        didSet {
            self.viewModel.selectedCity.bind = {[weak self] in
                guard let self = self else {return}
                guard let cityName = $0 else {return}
                self.mapPopup.title = cityName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapPopup.onCloseButton = closePopup
        
        configureNavigationBar()
        configureMap()
    }

    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = "Global Weather"
        
        ShadowHelper.setStandartShadow(layer: navbarShadowView.layer)
        
        let searchController =  UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    private func configureMap() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func showPopup() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.popupBottomConstraint.constant = Constants.MapPopupBottomOpenMargin
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func closePopup() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.popupBottomConstraint.constant = Constants.MapPopupBottomCloseMargin
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension MapViewController: UISearchControllerDelegate {
    
}

extension MapViewController: UIGestureRecognizerDelegate {
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
    
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        showPopup()
        
        viewModel.geocodeCityFromCoordinate(coordinate: coordinate)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
}
