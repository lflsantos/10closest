//
//  LocationSearchProtocol.swift
//  10Closest
//
//  Created by Lucas Santos on 13/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import Foundation

protocol LocationViewProtocol : class {
    func startLoading()
    func finishLoading()
    func setLocations(_ locationModels:[LocationModel])
    func noLocationFound();
    func onErrorFindingLocations();
}

protocol LocationServiceProtocol {
    func searchLocations(request: LocationRequestModel, callBack: @escaping ([LocationModel], Int) -> Void)
}
