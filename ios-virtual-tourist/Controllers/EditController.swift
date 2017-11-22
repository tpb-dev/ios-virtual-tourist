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
    
    var picsForCoorindatesURL : String = "https://api.flickr.com/services/rest/?method=flickr.photos.findByLatLon&api_key=ca370d51a054836007519a00ff4ce59e&per_page=21&format=json&nojsoncallback=1"
    
    func getPicsForCoordinates(longitude: Double, latitude: Double, handler: @escaping (_ result: [String: Any]?, _ error: String?) -> Void) -> Void {
        let request = self.makeRequest(method: APIClient.Methods(rawValue: "GET")!, url: picsForCoorindatesURL + key, requestBody: nil, params: [:])
        self.sendRequest(request: request, isUdacity: true){ (resp, err) -> Void in
            if resp != nil {
                print("hi")
                handler(resp, nil)
            } else {
                print("bad")
                handler(resp, nil)
            }
        }
        
    }
    
}
