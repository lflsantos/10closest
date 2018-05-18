//
//  LocationPresenterTest.swift
//  10ClosestTests
//
//  Created by Lucas Santos on 18/05/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import XCTest
@testable import TenClosest
import CoreLocation

class LocationPresenterTest: XCTestCase {
    var locationView = LocationViewMock()
    
    let defaultLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override func setUp() {
        super.setUp()
        locationView = LocationViewMock()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSetEmptyLocations(){
        let locationServiceMock = LocationServiceMock(locations: [LocationModel](), response: 200)
        let locationPresenter = LocationPresenter(service: locationServiceMock)
        locationPresenter.attachView(locationView)
        
        locationPresenter.requestLocations("", coordinates: defaultLocation)
        
        XCTAssertTrue(locationView.noLocationFoundCalled)
        XCTAssertTrue(locationView.startLoadingCalled)
        XCTAssertTrue(locationView.finishLoadingCalled)
    }
    
    func testSetTenLocations(){
        var locations = [LocationModel]()
        for _ in 0..<10{
            locations.append(LocationModel(name: "name", geometry: Geometry(location: LocationCoordinates(lat: 0.0, lng: 0.0)), icon: nil, open: nil, types: nil, photos: nil, price_level: nil, formatted_address: nil, rating: nil, permanently_closed: nil))
        }
        let locationServiceMock = LocationServiceMock(locations: locations, response: 200)
        let locationPresenter = LocationPresenter(service: locationServiceMock)
        locationPresenter.attachView(locationView)
        
        locationPresenter.requestLocations("", coordinates: defaultLocation)
        
        XCTAssertTrue(locationView.setLocationsCalled)
        XCTAssertTrue(locationView.locationsCount == 10)
        XCTAssertTrue(locationView.startLoadingCalled)
        XCTAssertTrue(locationView.finishLoadingCalled)
    }
    
    func testMoreThanTenLocations(){
        var locations = [LocationModel]()
        for _ in 0..<15{
            locations.append(LocationModel(name: "name", geometry: Geometry(location: LocationCoordinates(lat: 0.0, lng: 0.0)), icon: nil, open: nil, types: nil, photos: nil, price_level: nil, formatted_address: nil, rating: nil, permanently_closed: nil))
        }
        let locationServiceMock = LocationServiceMock(locations: locations, response: 200)
        let locationPresenter = LocationPresenter(service: locationServiceMock)
        locationPresenter.attachView(locationView)
        
        locationPresenter.requestLocations("", coordinates: defaultLocation)
        
        XCTAssertTrue(locationView.setLocationsCalled)
        XCTAssertTrue(locationView.locationsCount == 10)
        XCTAssertTrue(locationView.startLoadingCalled)
        XCTAssertTrue(locationView.finishLoadingCalled)
    }
    
    func testSetLessThanTenLocations(){
        let numberOfModels = 5
        var locations = [LocationModel]()
        for _ in 0..<numberOfModels{
            locations.append(LocationModel(name: "name", geometry: Geometry(location: LocationCoordinates(lat: 0.0, lng: 0.0)), icon: nil, open: nil, types: nil, photos: nil, price_level: nil, formatted_address: nil, rating: nil, permanently_closed: nil))
        }
        let locationServiceMock = LocationServiceMock(locations: locations, response: 200)
        let locationPresenter = LocationPresenter(service: locationServiceMock)
        locationPresenter.attachView(locationView)
        
        locationPresenter.requestLocations("", coordinates: defaultLocation)
        
        XCTAssertTrue(locationView.setLocationsCalled)
        XCTAssertTrue(locationView.locationsCount == numberOfModels)
        XCTAssertTrue(locationView.startLoadingCalled)
        XCTAssertTrue(locationView.finishLoadingCalled)
    }
    
    func testError(){
        let locationServiceMock = LocationServiceMock(locations: [LocationModel](), response: -1)
        let locationPresenter = LocationPresenter(service: locationServiceMock)
        locationPresenter.attachView(locationView)
        
        locationPresenter.requestLocations("", coordinates: defaultLocation)
        
        XCTAssertTrue(locationView.onErrorCalled)
        XCTAssertTrue(locationView.startLoadingCalled)
        XCTAssertTrue(locationView.finishLoadingCalled)
    }
    
}

class LocationServiceMock : LocationService {
    private let locations : [LocationModel]
    private let response : Int
    
    init(locations: [LocationModel], response: Int){
        self.locations = locations
        self.response = response
    }
    override func searchLocations(request: LocationRequestModel, callBack: @escaping ([LocationModel], Int) -> Void) {
        callBack(locations, response)
    }
}

class LocationViewMock : LocationViewProtocol {
    var startLoadingCalled = false
    var finishLoadingCalled = false
    var setLocationsCalled = false
    var onErrorCalled = false
    var noLocationFoundCalled = false
    var locationsCount = -1
    
    func startLoading() {
        startLoadingCalled = true
    }
    
    func finishLoading() {
        finishLoadingCalled = true
    }
    
    func setLocations(_ locationModels: [LocationModel]) {
        setLocationsCalled = true
        locationsCount = locationModels.count
    }
    
    func onErrorFindingLocations(){
        onErrorCalled = true
    }
    
    func noLocationFound() {
        noLocationFoundCalled = true
    }
    
}
