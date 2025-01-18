//
//  ForecastViewModelTests.swift
//  AtmosTests
//
//  Created by Michael Amiro on 16/01/2025.
//

import XCTest
@testable import Atmos
import Foundation

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
        sut.fetchCurrentWeather()

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
        sut.get5DayForecast()

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(sut.forecast.count, 4)
        } else {
            XCTFail("Waiter interrupted")
        }
    }

    func testGetFavorites() {
        sut = configureTests(with: [location])
        sut.getFavorites()
        XCTAssertEqual(sut.favorites.count, 1)
    }

    func testAddFavorite() {
        XCTAssertTrue(sut.favorites.isEmpty)
        sut.addFavorite(location: location)
        guard let firstLocation = sut.favorites.first as? Location else {
            XCTFail("Favorites should not be empty")
            return
        }
        XCTAssertEqual(firstLocation, location)
    }

    func testRemoveFavorite() {
        sut = configureTests(with: [location])

        sut.removeFavorite(location)
        XCTAssertEqual(sut.favorites.count, 0)
    }

    private func configureTests(with favorites: [Location] = []) -> ForecastViewModel {
        let networkClient = NetworkClient(stubBehavior: .immediately)
        let weatherService = WeatherService(networkClient: networkClient)
        let favoriteService = MockFavoriteService(with: favorites)

        return ForecastViewModel(weatherService: weatherService, favoriteService: favoriteService)
    }
}
