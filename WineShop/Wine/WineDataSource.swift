//
//  WineDataSource.swift
//  WineShop
//
//  Created by Maxime Magné on 26/11/2019.
//  Copyright © 2019 Maxime Magné. All rights reserved.
//

import UIKit
import CoreData

struct WineResponse:Decodable {
    var message: String
    var data: [WineModel]
    var success: Bool
}

class WineDataSource : NSObject {
    weak var delegate: WineTableViewController?
    private var wines = [WineModel]()
    
    func getWines() -> [WineModel] {
        return self.wines
    }
    
    func fetchWines () {
        if CheckInternet.isConnected() {
            DispatchQueue.global().async {
                let urlString = "http://172.20.10.2:8080/product"
                let session = URLSession.shared
                let url = URL(string: urlString)!
                var request = URLRequest(url: url)
                request.setValue("1000", forHTTPHeaderField: "idsite")
                
                session.dataTask(with: request, completionHandler: { data, _, _ in
                    guard let jsonData = data else {
                        print("Error with json data")
                        return
                    }

                    do{
                        let decoder = JSONDecoder()
                        let wineResponse = try decoder.decode(WineResponse.self, from: jsonData)
                        self.wines = wineResponse.data
                        DispatchQueue.main.sync {
                            self.saveWines(wineList: self.wines)
                            self.delegate?.finishedLoadWines()
                        }
                    } catch {
                        print(error)
                    }
                }).resume()
            }
        } else {
            self.fetchLocalWines()
        }
    }
    
    func fetchLocalWines () {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Wine")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            self.wines = self.convertToWineModel(resultList: result)
            self.delegate?.finishedLoadWines()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func convertToWineModel (resultList: [NSManagedObject]) -> [WineModel] {
        var finalList = [WineModel]()
        
        for wineObj in resultList {
            let subType = wineObj.value(forKey: "subType") as! SubType
            
            let subTypeModel = SubTypeModel(
                id: subType.value(forKey: "id") as! Int,
                label: subType.value(forKey: "label") as! String,
                description: subType.value(forKey: "desc") as! String
            )
            let wineModel = WineModel(
                id: wineObj.value(forKey: "id") as! Int,
                name: wineObj.value(forKey: "name") as! String,
                description: wineObj.value(forKey: "desc") as! String,
                image: wineObj.value(forKey: "image") as! String,
                year: wineObj.value(forKey: "year") as! Int,
                price: wineObj.value(forKey: "price") as! Float,
                subtype: subTypeModel
            )
            
            finalList.append(wineModel)
        }
        
        return finalList
    }
    
    func saveWines(wineList: [WineModel]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        guard let wineEntity = NSEntityDescription.entity(forEntityName: "Wine", in: managedContext) else { return }
        guard let subtypeEntity = NSEntityDescription.entity(forEntityName: "SubType", in: managedContext) else { return }
        
        self.deleteAllData("Wine")
        for wine in wineList {
            let wineCD = NSManagedObject(entity: wineEntity, insertInto: managedContext)
            let subTypeCD = NSManagedObject(entity: subtypeEntity, insertInto: managedContext)
            subTypeCD.setValue(wine.subtype.id, forKeyPath: "id")
            subTypeCD.setValue(wine.subtype.label, forKeyPath: "label")
            subTypeCD.setValue(wine.subtype.description, forKeyPath: "desc")
            wineCD.setValue(wine.id, forKeyPath: "id")
            wineCD.setValue(wine.name, forKeyPath: "name")
            wineCD.setValue(wine.description, forKeyPath: "desc")
            wineCD.setValue(wine.image, forKeyPath: "image")
            wineCD.setValue(wine.year, forKeyPath: "year")
            wineCD.setValue(wine.price, forKeyPath: "price")
            wineCD.setValue(wine.name, forKeyPath: "name")
            wineCD.setValue(subTypeCD, forKeyPath: "subType")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error while saving data")
                print(error)
            }
        }
        
        self.fetchLocalWines()
    }
    
    func deleteAllData (_ entity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}
