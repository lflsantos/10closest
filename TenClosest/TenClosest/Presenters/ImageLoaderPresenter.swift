//
//  ImagePresenter.swift
//  TenClosest
//
//  Created by Lucas Santos on 20/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import Foundation
import UIKit

class ImageLoaderPresenter {
    private weak var imageLoaderView: ImageLoaderViewProtocol!
    private let imageLoaderService: ImageLoaderService
    
    init(service: ImageLoaderService){
        self.imageLoaderService = service
    }
    
    func attachView(_ view: ImageLoaderViewProtocol){
        self.imageLoaderView = view
    }
    
    func fetchImage(photoModel: PhotoModel){
        imageLoaderService.downloadImage(photoModel) { data in
            guard let data = data else {
                return
            }
            guard let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.imageLoaderView.showImage(image)
            }
        }
    }
}
