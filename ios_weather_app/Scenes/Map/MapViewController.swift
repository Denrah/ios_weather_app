//
//  MapViewController.swift
//  ios_weather_app
//
//  Created by iOS Intern on 03/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD

class MapViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var mapPopup: MapPopup!
    @IBOutlet private weak var navbarShadowView: UIView!
    @IBOutlet private weak var popupBottomConstraint: NSLayoutConstraint!
    
    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    var viewModel: MapViewModel! {
        didSet {
            self.viewModel.selectedCity.bind = {[weak self] in
                guard let self = self else {return}
                guard let cityName = $0 else {
                    self.closePopup()
                    return
                }
                self.mapPopup.title = cityName
                self.showPopup()
            }
            
            self.viewModel.geocodingInProgress.bind = {
                guard let value = $0 else {return}
                if value {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            }
            
            self.viewModel.selectedCoordinate.bind = {[weak self] in
                guard let self = self else {return}
                guard let coordinate = $0 else {return}
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotation(annotation)
                self.mapView.setCenter(coordinate, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setDefaultMaskType(.black)
        
        mapPopup.onCloseButton = closePopup
        
        configureNavigationBar()
        configureMap()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = "Global Weather"
        
        ShadowHelper.setStandartShadow(layer: navbarShadowView.layer)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func configureMap() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.setCenter(Constants.MapInitialCoordinate, animated: false)
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

extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        guard !text.isEmpty else {return}
        
        viewModel.geocodeCoordinateFromCity(city: text)
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
    
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        mapPopup.subtitle = coordinate.dmsCoordinate ?? "-"
        
        viewModel.updateCoordinate(coordinate: coordinate)
        viewModel.geocodeCityFromCoordinate(coordinate: coordinate)
    }
}
