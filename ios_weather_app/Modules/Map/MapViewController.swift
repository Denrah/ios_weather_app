//
//  MapViewController.swift
//  ios_weather_app
//

import UIKit
import MapKit
import SVProgressHUD

class MapViewController: UIViewController {
  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var mapPopup: MapPopupView!
  @IBOutlet private weak var navbarShadowView: UIView!
  @IBOutlet private weak var popupBottomConstraint: NSLayoutConstraint!
  
  // MARK: - Class constants
  
  private enum MapConstants {
    static let mapPopupBottomOpenMargin: CGFloat = 16
    static let mapPopupBottomCloseMargin: CGFloat = -200
    static let appName = "Global Weather"
  }
  
  let viewModel: MapViewModel
  
  init(viewModel: MapViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Scene configuration
  
  private func bindToViewModel() {
    self.viewModel.selectedCity.bind = {[weak self] in
      guard let self = self else {return}
      guard let cityName = $0 else {
        self.closePopup()
        return
      }
      
      self.mapPopup.viewModel?.title.value = cityName
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
    
    self.viewModel.popupIsOpened.bind = {
      guard let isOpened = $0 else {return}
      
      if isOpened {
        self.showPopup()
      } else {
        self.closePopup()
      }
    }
    
    self.viewModel.selectedCoordinate.bind = {[weak self] in
      guard let self = self else {return}
      guard let coordinate = $0 else {return}
      
      self.mapPopup.viewModel?.subtitle.value = coordinate.dmsCoordinate ?? "-"
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      self.mapView.removeAnnotations(self.mapView.annotations)
      self.mapView.addAnnotation(annotation)
      self.mapView.setCenter(coordinate, animated: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindToViewModel()
    
    SVProgressHUD.setDefaultMaskType(.black)

    let popupViewModel = MapPopupViewModel(delegate: viewModel)
    mapPopup.setup(with: popupViewModel)
    
    configureNavigationBar()
    configureMap()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationItem.largeTitleDisplayMode = .never
  }
  
  private func configureNavigationBar() {
    navigationController?.navigationBar.barTintColor = UIColor.white
    navigationItem.title = MapConstants.appName
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: nil, action: nil)
    
    navbarShadowView.layer.setStandartShadow()
    
    let searchController = UISearchController(searchResultsController: nil)
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
  }
  
  private func configureMap() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureReconizer:)))
    gestureRecognizer.delegate = self
    mapView.addGestureRecognizer(gestureRecognizer)
    mapView.setCenter(Constants.mapInitialCoordinate, animated: false)
  }
  
  // MARK: - Popup actions
  
  private func showPopup() {
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
      self.popupBottomConstraint.constant = MapConstants.mapPopupBottomOpenMargin
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
  private func closePopup() {
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
      self.popupBottomConstraint.constant = MapConstants.mapPopupBottomCloseMargin
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
}

// MARK: - Search handler

extension MapViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else {return}
    guard !text.isEmpty else {return}
    self.viewModel.geocodeCoordinateFromCity(city: text)
  }
}

// MARK: - Tap handler

extension MapViewController: UIGestureRecognizerDelegate {
  @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
    
    let location = gestureReconizer.location(in: mapView)
    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
    
    viewModel.updateCoordinate(coordinate: coordinate)
    viewModel.geocodeCityFromCoordinate(coordinate: coordinate)
  }
}
