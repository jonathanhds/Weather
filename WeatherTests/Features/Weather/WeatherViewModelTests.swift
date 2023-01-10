import XCTest
@testable import Weather

final class WeatherViewModelTests: XCTestCase {

    var weatherAPI: MockWeatherAPI!
    var viewModel: WeatherViewModel!

    override func setUp() async throws {
        weatherAPI = MockWeatherAPI()
        viewModel = await WeatherViewModel(weatherAPI: weatherAPI)
    }

    override func tearDown() async throws {
        viewModel = nil
        weatherAPI = nil
    }

    func test_shouldCallAPI() async throws {
        // Given
        await viewModel.fetchCurrentWeather()

        // When
        let fetchCurrentWeatherCalled = weatherAPI.fetchCurrentWeatherCalled

        // Then
        XCTAssertTrue(fetchCurrentWeatherCalled, "Expected 'fetchCurrentWeather' function to be called.")
    }

    func test_initialState_stateShouldBeLoading() async throws {
        // Given

        // When
        let state = await viewModel.state

        // Then
        switch state {
        case .loading:
            break
        default:
            XCTFail("Expected state to be loading. Got \(state).")
        }
    }

    func test_successAPICall_stateShouldBeData() async throws {
        // Given
        await viewModel.fetchCurrentWeather()

        // When
        let state = await viewModel.state

        // Then
        switch state {
        case .data:
            break
        default:
            XCTFail("Expected state to be data. Got \(state).")
        }
    }

    func test_failedAPICall_stateShouldBeError() async throws {
        // Given
        weatherAPI.shouldThrowError = true
        await viewModel.fetchCurrentWeather()

        // When
        let state = await viewModel.state

        // Then
        switch state {
        case .error:
            break
        default:
            XCTFail("Expected state to be error. Got \(state).")
        }
    }
}
