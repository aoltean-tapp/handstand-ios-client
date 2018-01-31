//
//  HSHomeLocationAnnotationView.swift
//  Handstand
//
//  Created by Fareeth John on 4/18/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import MapKit

class HSHomeLocationAnnotationView: MKAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let pinImage = UIImage(named: kHomeLocationPinImage)
        self.image = pinImage?.render(at: CGSize(width: (pinImage?.size.width)!/5, height: (pinImage?.size.height)!/5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
