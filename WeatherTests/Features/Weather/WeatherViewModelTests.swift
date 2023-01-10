import XCTest
@testable import Weather

final class WeatherViewModelTests: XCTestCase {

    func test_shouldCallAPI() async throws {
        // Given
        let weatherAPI = MockWeatherAPI()
        let viewModel = await WeatherViewModel(weatherAPI: weatherAPI)

        // When
        await viewModel.fetchCurrentWeather()

        // Then
        XCTAssertTrue(weatherAPI.fetchCurrentWeatherCalled)
    }
}
