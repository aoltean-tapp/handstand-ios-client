//
//  HSAddress.swift
//  Handstand
//
//  Created by Fareeth John on 4/12/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation

class HSAddress: NSObject {
    
    var addressLine1 : String = ""
    var addressLine2 : String = ""
    var placeId : String = ""
    var zipCode : String = ""
    var formatedAddress : String = ""
    var location : CLLocation? = nil
    var city : String = ""
    private var predictedResult : GMSAutocompletePrediction? = nil
    private var placeMark : CLPlacemark? = nil
    private var place : GMSPlace? = nil

    init(withPrediction data : GMSAutocompletePrediction) {
        super.init()
        self.predictedResult = data
        self.processAddress()
    }
    
    init(withPlace aPlace : GMSPlace) {
        super.init()
        place = aPlace
        processAddressForPlaceObject()
    }
    
    init(withPlaceMark place : CLPlacemark) {
        super.init()
        placeMark = place
        processAddresForPlaceMark()
    }
    
    init(withFormatedAddress address : String) {
        super.init()
        formatedAddress = address
    }
    
    func processAddresForPlaceMark()  {
        location = placeMark?.location
        if let theCode = placeMark?.postalCode {
            zipCode = theCode
        }
        if let theCity = placeMark?.locality {
            city = theCity
        }
        if let addrList = placeMark?.addressDictionary?["FormattedAddressLines"] as? [String]
        {
            formatedAddress =  addrList.joined(separator: ", ")
        }

    }

    
    func processAddress()  {
        let theAddressString : String = predictedResult!.attributedFullText.string
        var theSplitList = theAddressString.components(separatedBy: ", ")
        
        if theSplitList.count > 0 {
            addressLine1 = theSplitList[0].uppercased()
            theSplitList.remove(at: 0)
            
            if theSplitList.count > 0 {
                addressLine2 = theSplitList.joined(separator: ", ")
            }
        }
        else{
            addressLine1 = theAddressString
        }
        
        placeId = (predictedResult?.placeID)!
        formatedAddress = (predictedResult?.attributedFullText.string)!
    }
    
    func processAddressForPlaceObject()  {
        let theAddressString : String = (place?.formattedAddress)!
        var theSplitList = theAddressString.components(separatedBy: ", ")
        
        if theSplitList.count > 0 {
            addressLine1 = theSplitList[0].uppercased()
            theSplitList.remove(at: 0)
            
            if theSplitList.count > 0 {
                addressLine2 = theSplitList.joined(separator: ", ")
            }
        }
        else{
            addressLine1 = theAddressString
        }
        
        placeId = (place?.placeID)!
        location = CLLocation(latitude: (place?.coordinate.latitude)!, longitude: (place?.coordinate.longitude)!)
        formatedAddress = (place?.formattedAddress)!
        
        for component in (place?.addressComponents)! {
            print(component.name)
            if component.type == "postal_code" {
                zipCode = component.name
            }
            else if component.type == "locality" {
                city = component.name
            }
            else if component.type == "administrative_area_level_3" {
                city = component.name
            }
        }
    }
}
