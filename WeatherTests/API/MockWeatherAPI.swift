@testable import Weather

final class MockWeatherAPI: WeatherAPI {

    var fetchCurrentWeatherCalled = false

    func fetchCurrentWeather() async throws -> Weather {
        fetchCurrentWeatherCalled = true
        return Weather(temperature: 27, min: 13, max: 22, state: .showers)
    }
}
