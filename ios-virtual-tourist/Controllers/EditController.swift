//
//  EditController.swift
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/21/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditController : APIClient {
    
    static let instance = EditController()

    
    override init() {
    }
    
    var key: String = "2eed657f5a7b9a7afc6930f7c89ef7ef"
    var secret: String = "0cd2f2adfbe1c8e3"
    
    var picsForCoorindatesURL : String = "https://api.flickr.com/services/rest/"
    
    var isEditMode : Bool = false
    
    func getResultsForCoordinates(longitude: Double, latitude: Double, page: Int, responseHandler: @escaping (_ imgURLS: [String]?, _ error: String?) -> Void) {
        let params: [String: String] = ["method" : "flickr.photos.search",
                                        "api_key" : key,
                                        "per_page": "21",
                                        "format" : "json",
                                        "lat" : String(latitude),
                                        "lon" : String(longitude),
                                        "page" : String(page),
                                        "nojsoncallback": "1"
                                        ]
        
        var imgURLs = [String]()
        
        let request = self.makeRequest(method: APIClient.Methods(rawValue: "GET")!, url: picsForCoorindatesURL, requestBody: nil, params: params)
        
        //print(request.url)
        self.sendRequest(request: request){ (resp, err) -> Void in
            if resp != nil {
                if let photos = resp!["photos"] as! [String:Any]? {
                    if let photo = photos["photo"] as! [[String:Any]]?{
                        var count = 0
                        for pict in photo {
                            let pic = pict as [String:Any]
                            print("count = \(count)")
                            count += 1

                            let farmInt = pic["farm"] as! Int
                            let farm : String! = String(describing: farmInt)
                            let serverInt = pic["server"] as! String
                            let server : String! = String(describing: serverInt)
                            let idInt = pic["id"] as! String
                            let id : String! = String(describing: idInt)
                            let secretInt = pic["secret"] as! String
                            let secret : String! = String(describing: secretInt)

                            let url = self.makeURL(farm: farm, server:server, id: id, secret: secret)
                            imgURLs.append(url!)
                        }
                        responseHandler(imgURLs, nil)
                    } else {
                        print("No photos")
                    }
                }
                
            } else {
                print("bad")
            }
        }
    }
    
    func makeURL(farm: String, server: String, id: String, secret: String) -> String! {
        let f : String = "\(farm)"
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
    func downloadImage( imagePath:String, completionHandler: @escaping (_ imageData: NSData?, _ errorString: String?) -> Void){
        let session = URLSession.shared
        let imgURL = NSURL(string: imagePath)
        let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
            
            if downloadError != nil {
                completionHandler(nil, "Could not download image \(imagePath)")
            } else {
                
                completionHandler(data as! NSData, nil)
            }
        }
        
        task.resume()
    }
    
    func storeImage(_ imageData: NSData?, imgURL: String?){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "CollectionImage",
                                       in: managedContext)!
        
        let collImg = CollectionImage(entity: entity,
                      insertInto: managedContext)
        
        collImg.setValue(imageData, forKeyPath: "image")
        collImg.setValue(imgURL, forKeyPath: "imgURL")
        collImg.setValue(MapController.instance.currentPin, forKeyPath: "parentPin" )
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func getLocalImages(pin: Pin!) -> [NSData] {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return [NSData]()
        }
        
        var res: [NSData] = [NSData]()
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let pred = NSPredicate(format: "parentPin == %@", pin)
        
        let pinsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CollectionImage")
        pinsFetch.predicate = pred
        
        do {
            if let result = try? managedContext.fetch(pinsFetch) {
                for object in result {
                    
                    res.append(object as! NSData)
                }
            }
            try managedContext.save()
            return res
        } catch {
            fatalError("Failed to fetch employees: \(error)")
            return res
        }
        
    }
}
