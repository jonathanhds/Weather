enum WeatherState {
    case lightRain
    case lightCloud
    case showers
}

extension WeatherState {
    static func from(abbr: String) -> Self? {
        switch abbr {
        case "light_rain": return .lightRain
        case "light_cloud": return .lightCloud
        case "showers": return .showers
        default: return nil
        }
    }
}
