//
//  MapController.swift
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/17/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MapKit

class MapController {
    
    static let instance = MapController()
    
    var thePin : MKAnnotation?
    
    init() {
        thePin = nil
    }
    
    
    
    func storePinInstance(longitude: Double, latitude: Double) -> Pin? {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Pin",
                                       in: managedContext)!
        
        let pin = Pin(entity: entity,
                                     insertInto: managedContext)
        
        pin.setValue(longitude, forKeyPath: "longitude")
        pin.setValue(latitude, forKeyPath: "latitude")
        
        do {
            try managedContext.save()
            appDelegate.pins.append(pin)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return pin
        
    }
    
    func getAllPins() -> [Pin]? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let pinsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        do {
            let fetchedPins = try managedContext.fetch(pinsFetch) as! [Pin]
            return fetchedPins
        } catch {
            fatalError("Failed to fetch employees: \(error)")
            return nil
        }
    }
    
    func deletePin(annotation: MKAnnotation) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let pred = NSPredicate(format: "%K == %@ AND %K == %@", argumentArray:["longitude", annotation.coordinate.longitude, "latitude", annotation.coordinate.latitude])

        let pinsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        pinsFetch.predicate = pred
        
        do {
            if let result = try? managedContext.fetch(pinsFetch) {
                for object in result {
                    //print((object as! Pin).latitude)
                    managedContext.delete(object as! NSManagedObject)
                }
            }
            try managedContext.save()
            return true
        } catch {
            fatalError("Failed to fetch employees: \(error)")
            return false
        }
    }
}
