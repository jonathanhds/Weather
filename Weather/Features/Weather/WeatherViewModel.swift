import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {

    enum State {
        case loading
        case error(Error)
        case data(Weather)
    }

    let title = "Toronto"

    @Published
    private(set) var state: State = .loading

    private let weatherAPI: WeatherAPI

    init(weatherAPI: WeatherAPI = RealWeatherAPI()) {
        self.weatherAPI = weatherAPI
    }

    func fetchCurrentWeather() async {
        state = .loading

        do {
            let weather = try await weatherAPI.fetchCurrentWeather()
            state = .data(weather)
        } catch {
            state = .error(error)
        }
    }
}
