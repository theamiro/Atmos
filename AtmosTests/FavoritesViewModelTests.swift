//
//  FavoritesViewModelTests.swift
//  Atmos
//
//  Created by Michael Amiro on 22/01/2025.
//

import XCTest
@testable import Atmos

final class FavoritesViewModelTests: XCTestCase {
    var sut: FavoritesViewModel!

    override func setUp() {
        super.setUp()

        sut = configureTest()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testAddFavorite() {
        XCTAssertTrue(sut.favorites.isEmpty)
        sut.addFavorite(Location(longitude: -1.0292, latitude: 2.39393))

        let expectation = expectation(description: "Await addition to favorites")
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.2)
        if result == .timedOut {
            XCTAssertEqual(sut.favorites.count, 1)
            XCTAssertEqual(sut.favorites.first?.latitude, 2.39393)
        }
    }

    private func configureTest(with favorites: [Location] = []) -> FavoritesViewModel {
        let networkClient = NetworkClient(stubBehavior: .immediately)
        let favoritesService = MockFavoriteService(with: favorites)
        let placesService = GooglePlacesService(networkClient: networkClient)
        return FavoritesViewModel(favoriteService: favoritesService, placesService: placesService)
    }
}
