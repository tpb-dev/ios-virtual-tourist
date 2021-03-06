//
//  MapViewController
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/14/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//

//https://code.tutsplus.com/tutorials/core-data-and-swift-relationships-and-more-fetching--cms-25070
//https://stackoverflow.com/questions/30858360/adding-a-pin-annotation-to-a-map-view-on-a-long-press-in-swift

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var mapViewController: UIView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    var isEditState = false
    
    var button : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Inside viewWillAppear for mapviewcontroller")
        mapView.isHidden = false
        let pins = MapController.instance.getAllPins()!
        for pin in pins {
            addPinToMap(pin: pin)
        }
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func editClicked(_ sender: Any) {
        if isEditState == false {
            print("Edit clicked")
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            if button == nil {
                button = UIButton(frame: CGRect(x: 0, y: screenHeight - 44, width: screenWidth, height: 50))
                button.backgroundColor = .green
                button.setTitle("Tap pins to delete", for: .normal)
            } else {
                button.isHidden = false
            }
            editButton.title = "Done"
            self.view.addSubview(button)
            
        } else {
            button.isHidden = true
             editButton.title = "Edit"
        }
        isEditState = !isEditState
    }
    
    func addPinToMap(pin: Pin) {
        
        let annotation = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: pin.value(forKey: "latitude") as! CLLocationDegrees, longitude:pin.value(forKey: "longitude") as! CLLocationDegrees)
        annotation.coordinate = coordinates
        
        mapView.addAnnotation(annotation)
    }
    
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
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        
        print("Brucey")
        if isEditState == true {
            print("Brucey2222")
            let annotation = view.annotation as? MKPointAnnotation
            mapView.removeAnnotation(annotation!)
            MapController.instance.deletePin(annotation: annotation!)
        } else {
            print("Brucey3333")
            let pen = MapController.instance.isPinAlreadyThere(longitude: (view.annotation?.coordinate.longitude)!, latitude: (view.annotation?.coordinate.latitude)!)
            if pen != nil {
                MapController.instance.currentPin = pen
                MapController.instance.thePin = view.annotation!
                let storyboard = self.storyboard
                let editViewController = storyboard?.instantiateViewController(withIdentifier: "EditViewController")
                
                self.present(editViewController!, animated: true, completion: nil)
            }
            
            print("didSelect but pin doesn't exist")

            
        }
    }
    
    @IBAction func handleGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        var pin = MapController.instance.isPinAlreadyThere(longitude: locationCoordinate.longitude, latitude: locationCoordinate.latitude)
        
        if pin != nil {
            print("pin is not nil")
            MapController.instance.currentPin = pin
        } else {
            print("pin is nil")

            pin = MapController.instance.storePinInstance(longitude: locationCoordinate.longitude, latitude: locationCoordinate.latitude)
            MapController.instance.currentPin = pin
            addPinToMap(pin: pin!)
        }
    }
}

