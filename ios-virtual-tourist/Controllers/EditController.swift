//
//  EditController.swift
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/21/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//

import Foundation

class EditController : APIClient {
    
    var key: String = "2eed657f5a7b9a7afc6930f7c89ef7ef"
    var secret: String = "0cd2f2adfbe1c8e3"
    
    var picsForCoorindatesURL : String = "https://api.flickr.com/services/rest/"
    
    func getResultsForCoordinates(longitude: Double, latitude: Double, page: Int) -> [String]? {
        let params: [String: String] = ["method" : "flickr.photos.search",
                                        "api_key" : key,
                                        "per_page": "21",
                                        "format" : "json",
                                        "lat" : String(latitude),
                                        "lon" : String(longitude),
                                        "page" : String(page),
                                        "nojsoncallback": "!"
                                        ]
        
        var imgURLs = [String]()
        
        let request = self.makeRequest(method: APIClient.Methods(rawValue: "GET")!, url: picsForCoorindatesURL, requestBody: nil, params: params)
        
        print(request.url)
        self.sendRequest(request: request){ (resp, err) -> Void in
            if resp != nil {
                if let photos = resp!["photos"] as! [String:Any]? {
                    if let photo = photos["photo"] as! [[String:Any]]?{
                        print("Farm rice")
                        for pic in photo {
                            let url = self.makeURL(farm: String(describing: pic["farm"]), server: String(describing: pic["server"]), id: String(describing: pic["id"]), secret: String(describing: pic["secret"]))
                            imgURLs.append(url)
                        }
                    } else {
                        print("No photos")
                    }
                }
                
            } else {
                print("bad")
            }
        }
        return imgURLs
    }
    
    /*
    func searchPlaces(placeID: String!) {
        let params: [String: String] = ["method" : "flickr.photos.search",
                                        "api_key" : key,
                                        "per_page": "21",
                                        "format" : "json",
                                        "nojsoncallback" : "1",
                                        "lat" : String(latitude),
                                        "lon" : String(longitude)
        ]
     
     if let places = resp!["places"] as! [String: Any]?{
     print("The name of the airport is")
     if let place = places["place"] as! [[String:Any]]? {
     print("The name of the airport is")
     if place.count > 0 {
     print("Yes, place id = \(place[0]["place_id"] ?? "NONE")")
     placeID = place[0]["place_id"] as! String
     } else {
     print("That airport is not in the airports dictionary.")
     placeID = ""
     }
     } else {
     print("That airport is not in the airports dictionary.")
     }
     } else {
     print("No places")
     }
     
     
     
     
    } */
    
    func makeURL(farm: String, server: String, id: String, secret: String) -> String {
        return "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + ".jpg"
    }
    
}
