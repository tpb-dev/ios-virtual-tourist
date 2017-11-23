//
//  EditViewController.swift
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/16/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//

import UIKit
import MapKit

let reuseIdentifier = "EditViewCell";

class EditViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MKMapViewDelegate {
    
    @IBOutlet weak var editViewMapView: MKMapView!
    
    @IBOutlet weak var editViewCollectionView: UICollectionView!
    
    @IBOutlet weak var newCollectionRemoveButton: UIBarButtonItem!
    
    var annotation : MKAnnotation? = nil
    
    
    var myLocationPointRect: MKMapRect? = nil
    
    var imgURLs = [String]()
    
    let editControllerClient = EditController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        editViewMapView.delegate = self
        title = "Collection View"

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
        
        print("Brucey2")
        let long = (annotation?.coordinate.longitude)!
        let lat = (annotation?.coordinate.latitude)!
        editControllerClient.getResultsForCoordinates(longitude: long, latitude: lat, page: 1) { (response, error) -> Void in
            if error != nil {
                print("Bad in editviewcontroller")
            } else {
                print("Count = \(response?.count ?? 0)")
                self.imgURLs = response!
                DispatchQueue.main.async {
                    self.editViewCollectionView.reloadData()
                }
            }
        }
        
        if imgURLs.count == 0 {
            print("No gppd")
        } else {
            print("Not bad")
            
        }
    }
    
    
    @IBAction func newCollectionRemoveClicked(_ sender: Any) {
        if editControllerClient.isEditMode == true {
            let indexPaths = self.editViewCollectionView!.indexPathsForSelectedItems!
            for indexPath in indexPaths {
                self.editViewCollectionView.performBatchUpdates({
                    self.editViewCollectionView.deleteItems(at: [indexPath])
                }) { (finished) in
                    self.editViewCollectionView.reloadItems(at: self.editViewCollectionView.indexPathsForVisibleItems)
                }
            }
        } else {
            
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        
    }
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 0;
    }
    
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as UICollectionViewCell
        
        myCell.backgroundColor = UIColor.black
        
        //        let imageDictionary = self.images[indexPath.row] as! NSDictionary
        let imageUrlString = self.imgURLs[indexPath.row]
        let imageUrl:NSURL = NSURL(string: imageUrlString)!
        print(imageUrl)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            let imageView = UIImageView(frame: CGRect(x:0, y:0, width:myCell.frame.size.width, height:myCell.frame.size.height))
            
            DispatchQueue.main.async {
                
                let image = UIImage(data: imageData as Data)
                imageView.image = image
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                
                myCell.addSubview(imageView)
            }
        }
        
        return myCell
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAt indexPath: NSIndexPath) -> Bool {
        if collectionView.indexPathsForSelectedItems?.count == 0 {
            
        } else {
            
        }
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath as IndexPath) {
                collectionView.deselectItem(at: indexPath as IndexPath, animated: true)
                return false
            }
        }
        return true
    }
}
