//
//  ForecastView.swift
//  Atmos
//
//  Created by Michael Amiro on 20/01/2025.
//

import SwiftUI
import CoreData

struct ForecastView: View {
    @StateObject private var forecastViewModel = ForecastViewModel(
        weatherService: WeatherService(),
        favoriteService: CoreDataFavoriteService(),
        locationService: LocationService(),
        placesService: GooglePlacesService())
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        Image(forecastViewModel.currentWeather?.weather.first?.main.background ?? .seaCloudy)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        VStack {
                            Text(String(format: "%.0fº", forecastViewModel.currentWeather?.main.temperature ?? 0.0))
                                .font(.system(size: 64))
                            Text(forecastViewModel.currentWeather?.weather.first?.main.title.uppercased() ?? "Unknown")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                    }
                    HorizontalGrid(forecastViewModel.currentWeather?.main)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(forecastViewModel.currentWeather?.weather.first?.main.backgroundColor ??
                                    Color.cloudy)
                        .foregroundStyle(Color.white)
                    Divider()
                        .frame(height: 1.6)
                        .background(Color.white)
                }
                VStack(spacing: 0) {
                    ForEach(forecastViewModel.forecast, id: \.date) { forecast in
                        DayWeatherView(forecast)
                    }
                }
                .background(forecastViewModel.currentWeather?.weather.first?.main.backgroundColor ??
                            Color.cloudy)
                .foregroundStyle(Color.white)
            }
            .background(forecastViewModel.currentWeather?.weather.first?.main.backgroundColor ??
                        Color.cloudy)
            .scrollBounceBehavior(.basedOnSize)
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        forecastViewModel.addFavorite()
                    } label: {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .fontWeight(.semibold)
                            .frame(width: 24)
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 16)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        FavoritesView()
                    } label: {
                        Image(systemName: "bookmark.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .fontWeight(.semibold)
                            .frame(width: 16)
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
        }
    }
}

#Preview {
    ForecastView()
}
