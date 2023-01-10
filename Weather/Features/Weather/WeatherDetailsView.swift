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
                        .frame(maxHeight: 100)
                } placeholder: {
                    Color.clear
                }

                Text("\(weather.temperature)º")
                    .font(.system(size: 60))

            }

            Text("Light cloud")

            HStack(spacing: 12) {
                Text("L: 11º")

                Text("H: 17º")
            }
            .font(.system(size: 30))
        }
    }
}

struct WeatherDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherDetailsView(weather: .init(temperature: 27, min: 13, max: 31, state: .lightRain))
                .previewDisplayName("Light rain")

            WeatherDetailsView(weather: .init(temperature: 27, min: 13, max: 31, state: .lightCloud))
                .previewDisplayName("Light cloud")

            WeatherDetailsView(weather: .init(temperature: 27, min: 13, max: 31, state: .showers))
                .previewDisplayName("Showers")
        }
        .previewLayout(.fixed(width: 400, height: 200))
    }
}
