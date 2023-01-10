import Foundation
@testable import Weather

final class MockWeatherAPI: WeatherAPI {

    var fetchCurrentWeatherCalled = false

    func fetchCurrentWeather() async throws -> Weather {
        fetchCurrentWeatherCalled = true
        return Weather(temperature: Measurement(value: 27, unit: .celsius),
                       min: Measurement(value: 13, unit: .celsius),
                       max: Measurement(value: 22, unit: .celsius),
                       state: .showers)
    }
}
