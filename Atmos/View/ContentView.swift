//
//  ContentView.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var forecastViewModel = ForecastViewModel(weatherService: WeatherService(networkClient: NetworkClient(stubBehavior: .never)),
                                                                   favoriteService: CoreDataFavoriteService())
    var body: some View {
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
        .task {
            forecastViewModel.fetchCurrentWeather()
            forecastViewModel.get5DayForecast()
        }
    }
}

#Preview {
    ContentView()
}
