import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/blocs/blocs.dart';

import 'package:flutter_weather/repositories/repositories.dart';
import 'package:flutter_weather/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class SimpleBlocDelegate extends BlocDelegate {
	@override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
	final WeatherRepository weatherRepository = WeatherRepository(
		weatherApiClient: WeatherApiClient(
			httpClient: http.Client(),
		),
	);

	BlocSupervisor.delegate = SimpleBlocDelegate();

	runApp(
			BlocProvider<ThemeBloc>(
				builder: (context) => ThemeBloc(),
				child: App(weatherRepository: weatherRepository,),
			)
	);
}

class App extends StatelessWidget {
	final WeatherRepository weatherRepository;

	App({Key key, @required this.weatherRepository})
			: assert(weatherRepository != null),
				super(key: key);

	@override
	Widget build(BuildContext context) {
		return BlocBuilder<ThemeBloc, ThemeState>(
			builder: (context, themeState) {
				return MaterialApp(
					title: 'Flutter Weather',
					theme: themeState.theme,
					home: BlocProvider(
						builder: (context) =>
							WeatherBloc(weatherRepository: weatherRepository),
						child: Weather(),
					),
				);
			},
		);
	}
}