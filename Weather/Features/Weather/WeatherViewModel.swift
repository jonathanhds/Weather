import Foundation

enum State {
    case loading
    case error(Error)
    case data(Weather)
}

@MainActor
final class WeatherViewModel: ObservableObject {

    let title = "Toronto"

    private let weatherAPI: WeatherAPI

    @Published
    private(set) var state: State = .loading

    init(weatherAPI: WeatherAPI = RealWeatherAPI()) {
        self.weatherAPI = weatherAPI
    }

    func fetchCurrentWeather() async {
        do {
            let weather = try await weatherAPI.fetchCurrentWeather()
            state = .data(weather)
        } catch {
            state = .error(error)
        }
    }
}
