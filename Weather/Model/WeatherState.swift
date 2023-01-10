enum WeatherState {
    case lightRain
    case lightCloud
    case showers
}

extension WeatherState {
    static func from(abbreviation abbr: String) -> Self? {
        switch abbr {
        case "lr": return .lightRain
        case "lc": return .lightCloud
        case "s": return .showers
        default: return nil
        }
    }
}
