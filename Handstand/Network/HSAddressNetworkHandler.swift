//
//  HSAddressNetworkHandler.swift
//  Handstand
//
//  Created by Fareeth John on 4/12/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class HSAddressNetworkHandler: NSObject {
    
    func searchLocationForText(_ text : String, onComplete completionHandler: @escaping (Array<HSAddress>?, HSError?) -> ())  {
        if text.characters.count > 0 {
            
            let filter = GMSAutocompleteFilter()
            filter.type = .noFilter
            
            var bounds: GMSCoordinateBounds? = nil
            var previousLocation : CLLocation! = nil
            if let thePreviousLocation = YMLocationManager.shared().lastUpdatedLocation {
                previousLocation = thePreviousLocation
            }
            else if let thePreviousLocation = HSLocationHelper.getUserDefaultLocation() {
                previousLocation = thePreviousLocation
            }
            if previousLocation != nil {
                let  northEast : CLLocationCoordinate2D = CLLocationCoordinate2DMake(previousLocation.coordinate.latitude + 0.15, previousLocation.coordinate.longitude + 0.15);
                let  southWest : CLLocationCoordinate2D = CLLocationCoordinate2DMake(previousLocation.coordinate.latitude - 0.15, previousLocation.coordinate.longitude - 0.15);
                bounds =  GMSCoordinateBounds.init(coordinate: northEast, coordinate: southWest)
            }
            
            GMSPlacesClient.shared().autocompleteQuery(text, bounds: bounds, filter: filter, callback: { (results, error) -> Void in
                if error == nil{
                    var addressArr : Array<HSAddress>? = []
                    for theData in results! {
                        let theAddr = HSAddress(withPrediction: theData)
                        addressArr?.append(theAddr)
                    }
                    completionHandler(addressArr, nil)
                }
                else{
                    let theErr = HSError()
                    theErr.message = error?.localizedDescription
                    completionHandler(nil, theErr)
                }
            })
        }
    }
    
    func getAddressForPlaceID(placeID: String, onComplete completionHandler: @escaping (HSAddress?, HSError?) -> ()){
        GMSPlacesClient.shared().lookUpPlaceID(placeID) { (place,  error) in
            if error == nil {
                let theAddr = HSAddress(withPlace: place!)
                completionHandler(theAddr, nil)
            }
            else{
                let theErr = HSError()
                theErr.message = error?.localizedDescription
                completionHandler(nil, theErr)
            }
        }
    }
    
    func getGeoLocationForZipCode(zipcode : String, onComplete completionHandler: @escaping (HSAddress?, HSError?) -> ()){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString("USA " + zipcode, completionHandler: { (placemarks, error)  in
            if error == nil {
                if (placemarks?.count)! > 0{
                    let theAddr = HSAddress(withPlaceMark: (placemarks?[0])!)
                    completionHandler(theAddr, nil)
                }
            }
            else{
                let theErr = HSError()
                theErr.message = error?.localizedDescription
                completionHandler(nil, theErr)
            }
        })
    }
    
    func getGeoLocationFromLocation(_ location : CLLocationCoordinate2D, onComplete completionHandler: @escaping (HSAddress?, HSError?) -> ()){
        let geoCoder = CLGeocoder()
        let geoLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(geoLocation, completionHandler: { (placemarks, error)  in
            if error == nil {
                if (placemarks?.count)! > 0{
                    let theAddr = HSAddress(withPlaceMark: (placemarks?[0])!)
                    completionHandler(theAddr, nil)
                }
            }
            else{
                let theErr = HSError()
                theErr.message = error?.localizedDescription
                completionHandler(nil, theErr)
            }
        })
//        geoCoder.reverseGeocodeCoordinate(location, completionHandler: {(response, error) in
//            if error == nil {
//                let theAddr = response?.firstResult()
//                print(theAddr?.lines)
//            }
//            else{
//                let theErr = HSError()
//                theErr.message = error?.localizedDescription
//                completionHandler(nil, theErr)
//            }
//        })
    }
    
}
