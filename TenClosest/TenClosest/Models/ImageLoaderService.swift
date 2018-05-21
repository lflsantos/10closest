//
//  ImageService.swift
//  TenClosest
//
//  Created by Lucas Santos on 20/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import Foundation

class ImageLoaderService: ImageLoaderServiceProtocol{
    let baseUrl = "https://maps.googleapis.com/maps/api/place/photo?"
    
    func downloadImage(_ photoModel: PhotoModel, callback: @escaping (Data?) -> Void) {
        
        let maxWidth = "maxwidth=\(photoModel.width)"
        let maxHeight = "maxheight=\(photoModel.height)"
        let photoReference = "photoreference=\(photoModel.photo_reference)"
        let key = "key=\(Constants.GOOGLE_API_KEY)"
        if let url = URL(string:"\(baseUrl)\(maxWidth)&\(maxHeight)&\(photoReference)&\(key)"){
            URLSession.shared.dataTask(with: url) { data, response, error in
            callback(data)
            }.resume()
        }
    }
    
}
