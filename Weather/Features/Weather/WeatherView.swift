import SwiftUI

struct WeatherView: View {

    @StateObject
    private var viewModel = WeatherViewModel()

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading")
            case .error(let error):
                Text(error.localizedDescription)
            case .data(let data):
                WeatherDetailsView(weather: data)
            }

            Spacer()
        }
        .padding()
        .navigationTitle(viewModel.title)
        .task {
            await viewModel.fetchCurrentWeather()
        }
    }
}

struct Weather_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WeatherView()
        }
    }
}
