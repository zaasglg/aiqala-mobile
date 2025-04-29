import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AirQualityScreen extends StatefulWidget {
  const AirQualityScreen({super.key});

  @override
  State<AirQualityScreen> createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  // --- Өзгертілетін параметрлер ---
  final String apiKey = "70507e4c-c94d-4356-b131-2ca31fd3c6ec"; // ОСЫ ЖЕРГЕ ӨЗ API КІЛТІҢІЗДІ ҚОЙЫҢЫЗ
  // ---------------------------------

  String? _cityName;
  int? _aqiUS; // AQI (US EPA стандарты)
  String? _mainPollutantUS; // Негізгі ластаушы (US)
  String? _errorMessage;
  bool _isLoading = true;

  // Карта үшін қажетті өзгермелілер
  double? _latitude;
  double? _longitude;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchAirQualityData(); // Қосымша іске қосылғанда деректерді алу
  }

  // IQAir API-дан деректерді алу функциясы
  Future<void> _fetchAirQualityData() async {
    // IP мекенжайы бойынша ең жақын қаланың деректерін сұрау
    final String apiUrl = "https://api.airvisual.com/v2/nearest_city?key=$apiKey";

    setState(() {
      _isLoading = true; // Жүктеу индикаторын көрсету
      _errorMessage = null; // Қате хабарын тазарту
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Сұрау сәтті болса, JSON жауабын түрлендіру
        final data = jsonDecode(response.body);

        // Деректерді алу (API жауабының құрылымына сәйкес)
        if (data['status'] == 'success') {
          final cityData = data['data'];
          final currentPollution = cityData['current']['pollution'];

          // Координаттарды алу (API-дан)
          final coordinates = cityData['location']['coordinates'];
          final longitude = coordinates[0] as double;  // longitude келеді алдымен
          final latitude = coordinates[1] as double;   // latitude екінші келеді

          setState(() {
            _cityName = cityData['city'];
            _aqiUS = currentPollution['aqius']; // US AQI
            _mainPollutantUS = currentPollution['mainus']; // US негізгі ластаушысы
            _latitude = latitude;
            _longitude = longitude;
            _isLoading = false; // Жүктеу аяқталды

            // Маркерді орнату
            _setMarkers();
          });
        } else {
          // API қатесі (мысалы, кілт дұрыс емес)
          throw Exception('API қатесі: ${data['data']['message']}');
        }
      } else {
        // HTTP қатесі (мысалы, 404 Not Found, 500 Server Error)
        throw Exception('Серверден деректерді алу мүмкін болмады: ${response.statusCode}');
      }
    } catch (e) {
      // Желі қатесі немесе басқа да қателер
      setState(() {
        _errorMessage = 'Қате пайда болды: ${e.toString()}';
        _isLoading = false; // Жүктеу аяқталды (қатемен)
      });
    }
  }

  // Картада маркер орнату
  void _setMarkers() {
    if (_latitude == null || _longitude == null || _aqiUS == null) return;

    _markers = {
      Marker(
        markerId: const MarkerId('airQualityStation'),
        position: LatLng(_latitude!, _longitude!),
        icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(_aqiUS!)),
        infoWindow: InfoWindow(
          title: _cityName ?? 'Ауа сапасы станциясы',
          snippet: 'AQI: $_aqiUS - ${_getAqiCategory(_aqiUS!)}',
        ),
      ),
    };

    // Егер карта контроллері бар болса, картаны жаңа орынға жылжыту
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_latitude!, _longitude!),
          10.0, // Масштаб
        ),
      );
    }
  }

  // AQI-ға байланысты маркер түсін орнату
  double _getMarkerHue(int aqi) {
    if (aqi <= 50) return BitmapDescriptor.hueGreen;
    if (aqi <= 100) return BitmapDescriptor.hueYellow;
    if (aqi <= 150) return BitmapDescriptor.hueOrange;
    if (aqi <= 200) return BitmapDescriptor.hueRed;
    if (aqi <= 300) return BitmapDescriptor.hueViolet;
    return BitmapDescriptor.hueRose; // 300-ден жоғары
  }

  // Ауа сапасы индексіне (AQI) байланысты түс қайтару
  Color _getAqiColor(int? aqi) {
    if (aqi == null) return Colors.grey;
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown; // 300-ден жоғары
  }

  // AQI категориясын қайтару
  String _getAqiCategory(int aqi) {
    if (aqi <= 50) return 'Жақсы';
    if (aqi <= 100) return 'Қанағаттанарлық';
    if (aqi <= 150) return 'Сезімтал топтар үшін қолайсыз';
    if (aqi <= 200) return 'Денсаулыққа зиянды';
    if (aqi <= 300) return 'Өте зиянды';
    return 'Қауіпті'; // 300-ден жоғары
  }

  // Негізгі ластаушы атауын алу
  String _getPollutantName(String? pollutantCode) {
    if (pollutantCode == null) return 'Белгісіз';
    switch (pollutantCode.toLowerCase()) {
      case 'p2': return 'PM2.5'; // Fine particulate matter
      case 'p1': return 'PM10';  // Particulate matter
      case 'o3': return 'Ozon (O3)'; // Ozone
      case 'n2': return 'Azot dioksidi (NO2)'; // Nitrogen dioxide
      case 's2': return 'Kükirt dioksidi (SO2)'; // Sulphur dioxide
      case 'co': return 'Kömirtögi oksidi (CO)'; // Carbon monoxide
      default: return pollutantCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ауа Сапасы (IQAir)'),
        actions: [
          // Қайта жүктеу батырмасы
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchAirQualityData, // Жүктеп жатқанда батырманы өшіру
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Жүктеу индикаторы
          : _errorMessage != null
          ? Padding( // Қате хабарын көрсету
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      )
          : _buildAirQualityWithMap(), // Карта және ауа сапасы туралы ақпаратты көрсету
    );
  }

  // Карта және ауа сапасы туралы ақпаратты көрсететін виджет
  Widget _buildAirQualityWithMap() {
    if (_cityName == null || _aqiUS == null || _mainPollutantUS == null || _latitude == null || _longitude == null) {
      return const Center(child: Text('Деректерді алу мүмкін болмады.')); // Егер деректер толық болмаса
    }

    return Column(
      children: [
        // Google Maps бөлігі (экранның жартысын алады)
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_latitude!, _longitude!),
              zoom: 10.0,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
        ),

        // Ауа сапасы туралы ақпарат бөлігі
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  _cityName!,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // AQI картасы
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'AQI (US EPA):',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '$_aqiUS',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: _getAqiColor(_aqiUS),
                          ),
                        ),
                        Text(
                          _getAqiCategory(_aqiUS!),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getAqiColor(_aqiUS),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Негізгі ластаушы туралы ақпарат
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Негізгі ластаушы:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getPollutantName(_mainPollutantUS),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // AQI туралы түсіндірме
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Ауа сапасы индексі (AQI)',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAqiInfo(0, 50, Colors.green, 'Жақсы', 'Ауа сапасы қанағаттанарлық, ауаның ластануы аз немесе жоқ.'),
                        _buildAqiInfo(51, 100, Colors.yellow, 'Қанағаттанарлық', 'Ауа сапасы жалпы қолайлы. Алайда, кейбір ластаушы заттар сезімтал адамдар үшін қолайсыз болуы мүмкін.'),
                        _buildAqiInfo(101, 150, Colors.orange, 'Сезімтал топтар үшін қолайсыз', 'Сезімтал топтар үшін денсаулыққа әсер етуі мүмкін. Қоғамның көп бөлігінде проблемалар болмауы мүмкін.'),
                        _buildAqiInfo(151, 200, Colors.red, 'Денсаулыққа зиянды', 'Әр адам денсаулыққа әсерін сезінуі мүмкін. Сезімтал топтар үшін аса қауіпті.'),
                        _buildAqiInfo(201, 300, Colors.purple, 'Өте зиянды', 'Денсаулыққа қауіпті ескерту. Барлық адамдар үшін денсаулыққа елеулі әсер етуі мүмкін.'),
                        _buildAqiInfo(301, 500, Colors.brown, 'Қауіпті', 'Денсаулыққа төтенше жағдай. Бүкіл халық денсаулыққа елеулі әсер етуі мүмкін.'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  '(Деректер IP мекенжайы бойынша ең жақын станциядан алынды)',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Координаттары: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // AQI индексі туралы ақпарат блогын құру
  Widget _buildAqiInfo(int min, int max, Color color, String category, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$min-$max: $category',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}