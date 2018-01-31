//
//  HSHomeMapView.swift
//  Handstand
//
//  Created by Fareeth John on 4/13/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import MapKit

protocol HSHomeMapViewDelegate:class {
    func didLocationDisabled()
    func didLocationEnabled()
    func didClickedOnMyLocation()
    func didChangeLocation(_ mapView : HSHomeMapView, _ state: locationChangeState)
}

class HSHomeMapView: UIView, MKMapViewDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet var mapView: MKMapView!{didSet{
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(moveMap(_:)))
        panGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
        }}
    public weak var delegate : HSHomeMapViewDelegate? = nil
    public weak var locationPin : HSHomeLocationPin? = nil
    let mapZoomSize = 500
    let locationPinIdentifier = "CustomAnnotation"
    var state:locationChangeState = .auto

    override func awakeFromNib() {
        super.awakeFromNib()
        //Safely clearing out the last user.location
//        if UserDefaults.standard.value(forKey: userDefaultLocation) != nil {
//            UserDefaults.standard.removeObject(forKey: userDefaultLocation)
//        }
    }
    @objc func moveMap(_ sender:UIPanGestureRecognizer) {
        state = .user
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func setMyLocation()  {
        if YMLocationManager.shared().isLocationServiceAvailable() == true{
            YMLocationManager.shared().reInitialiseLocationManager()
            YMLocationManager.shared().checkLocationStatusAndAlertUser()
            YMLocationManager.shared().refreshLocation { (aLat, aLong, err) in
                if err == nil{
                    let center = CLLocationCoordinate2D(latitude: Double(aLat), longitude: Double(aLong))
                    self.showLocation(center)
                    self.delegate?.didLocationEnabled()
                }
                else{
                    self.delegate?.didLocationDisabled()
                }
            }
        }
//        else if let userLocation = HSLocationHelper.getUserDefaultLocation(){
//            self.showLocation(userLocation.coordinate)
//        }
        else{
            self.delegate?.didLocationDisabled()
        }
    }
    
    func showLocation(_ location : CLLocationCoordinate2D)  {
        let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(self.mapZoomSize), CLLocationDistance(self.mapZoomSize))
        self.mapView.setRegion(region, animated: true)
    }
    
    func showLocationWithoutDelegate(_ location : CLLocationCoordinate2D)  {
        self.mapView.delegate = nil
        let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(self.mapZoomSize), CLLocationDistance(self.mapZoomSize))
        self.mapView.setRegion(region, animated: true)
        self.perform(#selector(self.enableDelegate), with: nil, afterDelay: 0.6)
    }
    
    func enableDelegate()  {
        self.mapView.delegate = self
    }
    
    func showPinAtLocation(_ location : CLLocationCoordinate2D)  {
        if let pin = locationPin {
            mapView.removeAnnotation(pin)
            locationPin = HSHomeLocationPin(coordinate: location, title: "", subtitle: "")
            mapView.addAnnotation(pin)
            locationPin?.coordinate = location
        }
    }
    
    func centerCoordinate() -> CLLocationCoordinate2D {
        return mapView.centerCoordinate
    }
    
    //MARK:- Button Action
    @IBAction func onMyLocationAction(_ sender: UIButton) {
        self.delegate?.didClickedOnMyLocation()
    }

    //MARK:- Mapview delegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        //delegate?.didChangeLocation(self)
        delegate?.didChangeLocation(self, state)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if (annotation is MKUserLocation) {
            return nil
        }
        else{
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: locationPinIdentifier) as! HSHomeLocationAnnotationView!
            if (annotationView == nil) {
                annotationView = HSHomeLocationAnnotationView(annotation: annotation, reuseIdentifier: locationPinIdentifier)
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    }


}
