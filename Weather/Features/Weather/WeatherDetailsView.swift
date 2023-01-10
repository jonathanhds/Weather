import SwiftUI

struct WeatherDetailsView: View {

    private let weather: Weather

    init(weather: Weather) {
        self.weather = weather
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: "https://cdn.faire.com/static/mobile-take-home/icons/s.png")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.clear
                }
                .frame(maxWidth: 120, maxHeight: 100)

                Text(weather.temperature.formatted())
                    .font(.system(size: 60))
            }

            switch weather.state {
            case .lightCloud:
                Text("Light cloud")
            case .showers:
                Text("Showers")
            case .lightRain:
                Text("Light rain")
            }

            HStack(spacing: 12) {
                Text("L: \(weather.min.formatted())")

                Text("H: \(weather.max.formatted())")
            }
            .font(.system(size: 24))
        }
    }
}

struct WeatherDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherDetailsView(weather: .init(temperature: Measurement(value: 27, unit: .celsius),
                                              min: Measurement(value: 13, unit: .celsius),
                                              max: Measurement(value: 31, unit: .celsius),
                                              state: .lightRain))
                .previewDisplayName("Light rain")

            WeatherDetailsView(weather: .init(temperature: Measurement(value: 27, unit: .celsius),
                                              min: Measurement(value: 13, unit: .celsius),
                                              max: Measurement(value: 31, unit: .celsius),
                                              state: .lightCloud))
                .previewDisplayName("Light cloud")

            WeatherDetailsView(weather: .init(temperature: Measurement(value: 27, unit: .celsius),
                                              min: Measurement(value: 13, unit: .celsius),
                                              max: Measurement(value: 31, unit: .celsius),
                                              state: .showers))
                .previewDisplayName("Showers")
        }
        .previewLayout(.fixed(width: 400, height: 200))
    }
}
