import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case errorResponse
    case emptyResponse
    case unknownWeatherState(String)
}

final class RealWeatherAPI: WeatherAPI {

    private let BASE_URL = "https://cdn.faire.com/static/mobile-take-home"

    private let TORONTO_LOCATION_ID = 4418

    private lazy var iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter
    }()

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(iso8601Full)
        return decoder
    }()

    func fetchCurrentWeather() async throws -> Weather {
        guard let url = URL(string: "\(BASE_URL)/\(TORONTO_LOCATION_ID).json") else { throw APIError.invalidURL }
        let request = URLRequest(url: url)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard (200..<300).contains(response.statusCode) else { throw APIError.errorResponse }

        let decodedResponse = try decoder.decode(WeatherResponse.self, from: data)

        guard let mostRecentConsolidatedWeather = decodedResponse.consolidatedWeather.sorted().first else { throw APIError.emptyResponse  }

        guard let state = WeatherState.from(abbr: mostRecentConsolidatedWeather.weatherStateAbbr)
        else { throw APIError.unknownWeatherState(mostRecentConsolidatedWeather.weatherStateAbbr) }

        return Weather(temperature: mostRecentConsolidatedWeather.temperature,
                       min: mostRecentConsolidatedWeather.minTemp,
                       max: mostRecentConsolidatedWeather.maxTemp,
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
    let minTemp: Float
    let maxTemp: Float
    let temperature: Float
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
        self.minTemp = try container.decode(Float.self, forKey: .minTemp)
        self.maxTemp = try container.decode(Float.self, forKey: .maxTemp)
        self.temperature = try container.decode(Float.self, forKey: .temperature)
        self.weatherStateAbbr = try container.decode(String.self, forKey: .weatherStateAbbr)
    }

    static func < (lhs: ConsolidatedWeather, rhs: ConsolidatedWeather) -> Bool {
        lhs.created < rhs.created
    }
}
