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
        
        print(request.url)
        self.sendRequest(request: request){ (resp, err) -> Void in
            if resp != nil {
                if let photos = resp!["photos"] as! [String:Any]? {
                    if let photo = photos["photo"] as! [[String:Any]]?{
                        print("Farm rice")
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
    
}
