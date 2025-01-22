//
//  ForecastViewModelTests.swift
//  AtmosTests
//
//  Created by Michael Amiro on 16/01/2025.
//

import XCTest
@testable import Atmos
import Foundation
import CoreLocation

final class ForecastViewModelTests: XCTestCase {
    private var sut: ForecastViewModel!
    private let location = Location(longitude: 36.817223, latitude: -1.286389)

    override func setUp() {
        super.setUp()
        sut = configureTests()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testGetCurrentWeather() {
        let expectation = expectation(description: "Await fetching of current weather")
        sut.fetchCurrentWeather(location: CLLocationCoordinate2D(latitude: 2.0003, longitude: -3.3994))

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)

        if result == XCTWaiter.Result.timedOut {
            guard let currentWeather = sut.currentWeather else {
                XCTFail("Current Weather cannot be nil")
                return
            }
            XCTAssertEqual(currentWeather.main.minimumTemperature, 283.06)
            XCTAssertEqual(currentWeather.main.maximumTemperature, 286.82)
        } else {
            XCTFail("Waiter interrupted")
        }
    }

    func testGet5DayForecast() {
        let expectation = expectation(description: "Await fetching of forecast")
        sut.get5DayForecast(location: CLLocationCoordinate2D(latitude: 2.0003, longitude: -3.3994))

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(sut.forecast.count, 7)
        } else {
            XCTFail("Waiter interrupted")
        }
    }

    private func configureTests(with favorites: [Location] = []) -> ForecastViewModel {
        let networkClient = NetworkClient(stubBehavior: .immediately)
        let weatherService = WeatherService(networkClient: networkClient)
        let locationService = LocationService()
        return ForecastViewModel(
            weatherService: weatherService,
            locationService: locationService
        )
    }
}
