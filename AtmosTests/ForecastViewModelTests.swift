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

    }

    func testGet5DayForecast() {

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
