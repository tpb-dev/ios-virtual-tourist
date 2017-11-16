//
//  MapViewController
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/14/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var mapViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
       // var c = PinModel(latitude:26.4, longitude:22.3)
        //c.tryme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Inside viewWillAppear for mapviewcontroller")
        mapView.isHidden = false
        //deleteButton.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func editClicked(_ sender: Any) {
        print("Edit clicked")
    }
    /*
    func addPinToMap(pins: PinModel) {
        
        let annotation = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: pins.latitude, longitude:pins.longitude)
        annotation.coordinate = coordinates
        
        mapView.addAnnotation(annotation)
    } */
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation else { return nil }
        let identifier = "pin-marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    
    
}

