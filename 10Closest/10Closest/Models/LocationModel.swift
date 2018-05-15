//
//  LocationModel.swift
//  10Closest
//
//  Created by Lucas Santos on 13/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationModel : Decodable{
    let name : String
    let location : String
    let icon : URL?
    let open : Bool?
    let types : [String]?
    let photos : [PhotoModel]?
    let price_level : Int?
    let formatted_address : String?
    let rating : Float?
    let permanently_closed : Bool?
    
    //custom decoder to exclude unwanted fields
}

struct LocationsModel : Decodable{
    let results : [LocationModel]
    let status : String
}

struct LocationOpeningModel : Decodable{
    let opening_hours : LocationOpenNowModel?
}

struct LocationOpenNowModel : Decodable{
    let open_now : Bool?
}

struct PhotoModel : Decodable{
    let width : Int
    let height : Int
    let photo_reference : String
}

struct LocationRequestModel {
    let keyword : String
    let location : String
    let radius : Int
    let language : String //https://developers.google.com/maps/faq#languagesupport
    let rankBy = "distance"
    let type : String?
}



enum PriceLevel : Int{
    case Free = 0
    case Inexpensive = 1
    case Moderate = 2
    case Expensive = 3
}
