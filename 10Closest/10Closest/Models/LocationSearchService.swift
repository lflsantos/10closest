//
//  LocationSearchService.swift
//  10Closest
//
//  Created by Lucas Santos on 13/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import Foundation
import CoreLocation


class LocationSearchService {
    
    
    func searchLocations(request: LocationRequestModel, callBack: @escaping ([LocationModel]) -> Void){

        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(request.location)&keyword=\(request.keyword.replaceSpacesWithPlusChar())&language=pt-BR&rankby=distance&key=\(Constants.GOOGLE_API_KEY)"
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let locations = self.parseJSON(data: data!) {
                callBack(locations.results)
            } else {
                print("ERROR. Could not fetch JSON from URL")
            }
        }
        
        task.resume()
    }

    func parseJSON(data: Data) -> LocationsModel?{
        do{
            return try JSONDecoder().decode(LocationsModel.self, from: data)
        } catch let jsonError{
            print("ERROR. Could not parse json. \(jsonError)")
            return nil
        }
    }
}



extension String {
    func replaceSpacesWithPlusChar() -> String{
        return self.replacingOccurrences(of: " ", with: "+")
    }
}



