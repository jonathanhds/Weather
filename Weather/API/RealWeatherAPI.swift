import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case errorResponse(Int)
    case emptyResponse
    case unknownWeatherState(String)
}

final class RealWeatherAPI: WeatherAPI {

    private let BASE_URL = "https://cdn.faire.com/static/mobile-take-home"

    private let TORONTO_LOCATION_ID = 4418

    private lazy var decoder: JSONDecoder = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)

        return decoder
    }()

    func fetchCurrentWeather() async throws -> Weather {
        guard let url = URL(string: "\(BASE_URL)/\(TORONTO_LOCATION_ID).json")
        else { throw APIError.invalidURL }

        let data = try await sendGETRequest(to: url)
        return try parseWeatherResponse(from: data)
    }

    private func sendGETRequest(to url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse
        else { throw APIError.invalidResponse }

        guard (200..<300).contains(response.statusCode)
        else { throw APIError.errorResponse(response.statusCode) }

        return data
    }

    private func parseWeatherResponse(from data: Data) throws -> Weather {
        let decodedResponse = try decoder.decode(WeatherResponse.self, from: data)

        guard let mostRecentConsolidatedWeather = decodedResponse.consolidatedWeather.sorted().first
        else { throw APIError.emptyResponse  }

        guard let state = WeatherState(rawValue: mostRecentConsolidatedWeather.weatherStateAbbr)
        else { throw APIError.unknownWeatherState(mostRecentConsolidatedWeather.weatherStateAbbr) }

        return Weather(temperature: Measurement(value: mostRecentConsolidatedWeather.temperature, unit: .celsius),
                       min: Measurement(value: mostRecentConsolidatedWeather.minTemp, unit: .celsius),
                       max: Measurement(value: mostRecentConsolidatedWeather.maxTemp, unit: .celsius),
                       state: state)
    }
}

private struct WeatherResponse: Decodable {
    let consolidatedWeather: [ConsolidatedWeather]

    enum CodingKeys: String, CodingKey {
        case consolidatedWeather = "consolidated_weather"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.consolidatedWeather = try container.decode([ConsolidatedWeather].self, forKey: .consolidatedWeather)
    }
}

private struct ConsolidatedWeather: Decodable, Comparable {
    let created: Date
    let minTemp: Double
    let maxTemp: Double
    let temperature: Double
    let weatherStateAbbr: String

    enum CodingKeys: String, CodingKey {
        case created
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case temperature = "the_temp"
        case weatherStateAbbr = "weather_state_abbr"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.created = try container.decode(Date.self, forKey: .created)
        self.minTemp = try container.decode(Double.self, forKey: .minTemp)
        self.maxTemp = try container.decode(Double.self, forKey: .maxTemp)
        self.temperature = try container.decode(Double.self, forKey: .temperature)
        self.weatherStateAbbr = try container.decode(String.self, forKey: .weatherStateAbbr)
    }

    static func < (lhs: ConsolidatedWeather, rhs: ConsolidatedWeather) -> Bool {
        lhs.created < rhs.created
    }
}
