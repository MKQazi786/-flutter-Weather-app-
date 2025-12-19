import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'modals/modal.dart'; // Assuming this file contains the models

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _cityController = TextEditingController();
  WeatherModels? _weatherData;
  bool _isLoading = false;

  Future<void> getWeather(String cityName) async {
    setState(() {
      _isLoading = true;
    });

    String weatherKey = '8ec1cd18aec637e2b0a0c34aeb0b868c';
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$weatherKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _weatherData = WeatherModels.fromJson(data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _weatherData = null;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _weatherData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MKQazi786 Weather App'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                hintText: 'e.g., Karachi, Lahore',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                getWeather(_cityController.text);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : _weatherData != null
                    ? Expanded(
                        child: ListView(
                          children: [
                            _buildWeatherCard(),
                          ],
                        ),
                      )
                    : const Text(
                        'Jani City Enter Kro',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${_weatherData!.name}, ${_weatherData!.sys?.country}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Image.network(
              "https://openweathermap.org/img/wn/${_weatherData!.weather![0].icon}@2x.png",
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              'Temperature: ${_weatherData!.main!.temp}°C',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Feels like: ${_weatherData!.main!.feelsLike}°C',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Humidity: ${_weatherData!.main!.humidity}%',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Wind Speed: ${( _weatherData!.wind!.speed! * 3.6).toStringAsFixed(0)} Km/h',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Visibility: ${(_weatherData!.visibility! * 0.001).toStringAsFixed(1)} Km',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Description: ${_weatherData!.weather![0].description}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
