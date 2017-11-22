//
//  EditViewController.swift
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/16/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//

import UIKit
import MapKit

class EditViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var editViewMapView: MKMapView!
    
    var annotation : MKAnnotation? = nil
    
    
    var myLocationPointRect: MKMapRect? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        editViewMapView.delegate = self 

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Inside viewWillAppear for editviewcontroller")
        annotation = MapController.instance.thePin!
        myLocationPointRect = MKMapRectMake((annotation?.coordinate.longitude)!, (annotation?.coordinate.latitude)!, 0, 0)
        editViewMapView.showAnnotations([annotation!], animated: true)
        
        loadImages()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImages() {
        let editControllerClient = EditController()
        print("Brucey2")
        let long = (annotation?.coordinate.longitude)!
        let lat = (annotation?.coordinate.latitude)!
        let imgURLs = editControllerClient.getResultsForCoordinates(longitude: long, latitude: lat, page: 1)!
        if imgURLs.count == 0 {
            print("No gppd")
        } else {
            print("Not bad")
            
        }
    }
    
    
    @IBAction func newCollectionClicked(_ sender: Any) {
    }
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        
    }
}
