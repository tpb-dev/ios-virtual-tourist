//
//  EditViewController.swift
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/16/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//

import UIKit
import MapKit
import CoreData

let reuseIdentifier = "EditViewCell";

class EditViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var editViewMapView: MKMapView!
    
    @IBOutlet weak var editViewCollectionView: UICollectionView!
    
    @IBOutlet weak var newCollectionRemoveButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteEditButton: UIBarButtonItem!
    
    var annotation : MKAnnotation? = nil
    
    var pageCounter = 1
    
    
    var myLocationPointRect: MKMapRect? = nil
    
    var imgURLs = [String]()
    
    var imgsLocal: [CollectionImage]? = nil
    
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
    }
    
    func loadImages() {
        
        print("Brucey2")
        let long = (annotation?.coordinate.longitude)!
        let lat = (annotation?.coordinate.latitude)!
        //Here for check images in Local

        let colImgsLocal: [CollectionImage] = EditController.instance.getLocalImages(pin: MapController.instance.currentPin)
        print("imgslocal.count=\(colImgsLocal.count)")
        if colImgsLocal.count <= 0 {
        
            editControllerClient.getResultsForCoordinates(longitude: long, latitude: lat, page: pageCounter) { (response, error) -> Void in
                if error != nil {
                    print("Bad in editviewcontroller")
                } else {
                    print("Count = \(response?.count ?? 0)")
                    self.imgURLs = response!
                    for url in self.imgURLs {
                        self.getImgs(imageUrlString: url)
                    }
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
            pageCounter += 1
        }
        
    }
    
    func getImgs(imageUrlString: String) {
        editControllerClient.downloadImage(imagePath: imageUrlString) { (response, error) -> Void in
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    EditController.instance.storeImage(response, imgURL: imageUrlString)
                }
            }
        }
    }
    
    
    @IBAction func newCollectionRemoveClicked(_ sender: Any) {
        let indexPaths = self.editViewCollectionView!.index
        
        
        imgURLs.removeAll()
        editViewCollectionView.reloadData()
        MapController.instance.deleteImgs(badPin: MapController.instance.currentPin)
        loadImages()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 0;
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgsLocal == nil ? 0 : imgsLocal!.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as UICollectionViewCell
        
        
        
        myCell.backgroundColor = UIColor.green
        
        imgsLocal = EditController.instance.getLocalImages(pin: MapController.instance.currentPin)
                   
        if imgsLocal!.count > 0 {
            print("imgslocal.count \(imgsLocal!.count)")
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    let imageView = UIImageView(frame: CGRect(x:0, y:0, width:myCell.frame.size.width, height:myCell.frame.size.height))
                    let image = UIImage(data: self.imgsLocal![indexPath.row].image! as Data)
                    
                    imageView.image = image
                    imageView.contentMode = UIViewContentMode.scaleAspectFit
                    
                    let theSubviews: Array = (myCell.subviews)
                    for view in theSubviews
                    {
                        view.removeFromSuperview()
                    }
                    
                    myCell.addSubview(imageView)
                }

            }
            return myCell

        } else {
            let imageUrlString = self.imgURLs[indexPath.row]
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
//            print(imageUrl)
            print("imgslocal.count \(imgsLocal?.count)")
            
        }
            
        return myCell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Got herre2")
        if EditController.instance.isEditMode == true {
            print("In edit ")
            imgURLs.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }
    }
    
    @IBAction func deleteEditClicked(_ sender: Any) {
        editControllerClient.isEditMode = !editControllerClient.isEditMode
        if editControllerClient.isEditMode == true {
            deleteEditButton.title = "Edit"
        } else {
            deleteEditButton.title = "Delete"
        }
    }

    
    
}
