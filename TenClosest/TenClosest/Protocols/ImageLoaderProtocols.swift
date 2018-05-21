//
//  ImageProtocols.swift
//  TenClosest
//
//  Created by Lucas Santos on 20/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import Foundation
import UIKit



protocol ImageLoaderViewProtocol: class{
    func showImage(_ image: UIImage)
}

protocol ImageLoaderServiceProtocol {
    func downloadImage(_ photoModel: PhotoModel, callback: @escaping (Data?) -> Void)
}
