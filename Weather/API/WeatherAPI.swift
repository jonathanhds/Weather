import Foundation

protocol WeatherAPI {
    func fetchCurrentWeather() async throws -> Weather
}
