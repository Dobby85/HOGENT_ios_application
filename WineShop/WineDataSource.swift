//
//  WineDataSource.swift
//  WineShop
//
//  Created by Maxime Magné on 26/11/2019.
//  Copyright © 2019 Maxime Magné. All rights reserved.
//

import UIKit

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
        DispatchQueue.global().async {
            let urlString = "http://192.168.0.201:8080/product"
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
                    print("Hello")
                    DispatchQueue.main.sync {
                        self.delegate?.finishedLoadWines()
                    }
                } catch {
                    print(error)
                }
            }).resume()
        }
    }
}
