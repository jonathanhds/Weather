import Foundation

struct Weather {
    let temperature: Measurement<UnitTemperature>
    let min: Measurement<UnitTemperature>
    let max: Measurement<UnitTemperature>
    let state: WeatherState
}
