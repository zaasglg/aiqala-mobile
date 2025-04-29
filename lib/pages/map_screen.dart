import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

class RecyclingPoint {
  final String id;
  final String name;
  final String address;
  final LatLng position;
  final String openingHours;
  final List<String> acceptedMaterials;
  final String phoneNumber;

  RecyclingPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    required this.openingHours,
    required this.acceptedMaterials,
    this.phoneNumber = '',
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  // Начальная позиция (можно будет заменить на текущую позицию пользователя)
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(43.238949, 76.889709), // Алматы по умолчанию
    zoom: 12,
  );

  List<RecyclingPoint> recyclingPoints = [];
  List<RecyclingPoint> filteredPoints = [];

  List<String> allMaterialTypes = [
    'Пластик',
    'Бумага',
    'Стекло',
    'Металл',
    'Электроника',
    'Текстиль',
    'Батарейки',
  ];

  List<String> selectedMaterials = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadRecyclingPoints();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Разрешения не выданы, но можно использовать положение по умолчанию
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Разрешения не выданы навсегда, можно предложить открыть настройки
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      final GoogleMapController controller = await _controller.future;
      CameraPosition userPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      );

      setState(() {
        _initialPosition = userPosition;
      });

      controller.animateCamera(CameraUpdate.newCameraPosition(userPosition));
    } catch (e) {
      print('Ошибка получения локации: $e');
    }
  }

  Future<void> _loadRecyclingPoints() async {
    // В реальном приложении эти данные нужно будет загружать с сервера или из базы данных
    // Здесь мы просто создаем пример данных
    setState(() {
      _isLoading = true;
    });

    try {
      // Имитация загрузки данных с сервера
      await Future.delayed(const Duration(seconds: 1));

      final List<RecyclingPoint> points = [
        RecyclingPoint(
          id: '1',
          name: 'ЭкоАлматы',
          address: 'ул. Толе би, 59/1',
          position: const LatLng(43.253651, 76.928354),
          openingHours: 'Пн-Сб: 9:00-18:00, Вс: выходной',
          acceptedMaterials: ['Пластик', 'Бумага', 'Стекло'],
          phoneNumber: '+7 (727) 123-45-67',
        ),
        RecyclingPoint(
          id: '2',
          name: 'GreenTech Recycling',
          address: 'пр. Абая, 150',
          position: const LatLng(43.238442, 76.852654),
          openingHours: 'Пн-Пт: 8:00-20:00, Сб-Вс: 10:00-18:00',
          acceptedMaterials: ['Пластик', 'Металл', 'Электроника'],
          phoneNumber: '+7 (701) 987-65-43',
        ),
        RecyclingPoint(
          id: '3',
          name: 'ВторСырье Плюс',
          address: 'ул. Жандосова, 34',
          position: const LatLng(43.227330, 76.909873),
          openingHours: 'Ежедневно: 8:00-20:00',
          acceptedMaterials: ['Бумага', 'Стекло', 'Металл', 'Текстиль'],
          phoneNumber: '+7 (777) 456-78-90',
        ),
        RecyclingPoint(
          id: '4',
          name: 'ЭкоПункт',
          address: 'ул. Тимирязева, 42',
          position: const LatLng(43.235123, 76.945632),
          openingHours: 'Пн-Сб: 9:00-19:00, Вс: выходной',
          acceptedMaterials: ['Пластик', 'Батарейки', 'Бумага'],
          phoneNumber: '+7 (707) 234-56-78',
        ),
        RecyclingPoint(
          id: '5',
          name: 'Вторма Казахстан',
          address: 'ул. Саина, 17/1',
          position: const LatLng(43.219876, 76.876543),
          openingHours: 'Пн-Пт: 8:30-17:30, Сб-Вс: выходной',
          acceptedMaterials: ['Металл', 'Пластик', 'Стекло', 'Электроника'],
          phoneNumber: '+7 (727) 345-67-89',
        ),
      ];

      setState(() {
        recyclingPoints = points;
        filteredPoints = points;
        _createMarkers();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Ошибка загрузки данных: $e');
    }
  }

  void _createMarkers() {
    final Set<Marker> markerSet = {};

    for (final point in filteredPoints) {
      final marker = Marker(
        markerId: MarkerId(point.id),
        position: point.position,
        infoWindow: InfoWindow(
          title: point.name,
          snippet: point.address,
        ),
        onTap: () {
          _showPointDetails(point);
        },
      );

      markerSet.add(marker);
    }

    setState(() {
      _markers = markerSet;
    });
  }

  void _filterPoints() {
    setState(() {
      if (selectedMaterials.isEmpty && _searchQuery.isEmpty) {
        filteredPoints = recyclingPoints;
      } else {
        filteredPoints = recyclingPoints.where((point) {
          // Фильтрация по материалам
          bool matchesMaterials = selectedMaterials.isEmpty ||
              selectedMaterials.any((material) => point.acceptedMaterials.contains(material));

          // Фильтрация по поисковому запросу
          bool matchesSearch = _searchQuery.isEmpty ||
              point.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              point.address.toLowerCase().contains(_searchQuery.toLowerCase());

          return matchesMaterials && matchesSearch;
        }).toList();
      }

      _createMarkers();
    });
  }

  void _showPointDetails(RecyclingPoint point) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          point.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          point.address,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (point.phoneNumber.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.green),
                      onPressed: () {
                        // Здесь можно добавить функционал для звонка
                      },
                    ),
                ],
              ),
              const Divider(height: 20),
              const Text(
                'Время работы:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                point.openingHours,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Принимаемые материалы:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: point.acceptedMaterials.map((material) {
                  return Chip(
                    label: Text(material),
                    backgroundColor: Colors.green[100],
                  );
                }).toList(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Здесь можно добавить функционал для построения маршрута
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Построить маршрут',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Фильтр по типу материалов',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: allMaterialTypes.map((material) {
                      final isSelected = selectedMaterials.contains(material);
                      return FilterChip(
                        label: Text(material),
                        selected: isSelected,
                        selectedColor: Colors.green[200],
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              selectedMaterials.add(material);
                            } else {
                              selectedMaterials.remove(material);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            selectedMaterials = [];
                          });
                        },
                        child: const Text('Очистить'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _filterPoints();
                        },
                        child: const Text('Применить'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Пункты приема вторсырья',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(IconlyBroken.filter),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Поисковая строка
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск по названию или адресу',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _filterPoints();
                });
              },
            ),
          ),
          // Карта
          Expanded(
            flex: 3,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          // Список пунктов
          Expanded(
            flex: 2,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredPoints.isEmpty
                ? const Center(
              child: Text(
                'Пункты приема не найдены',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: filteredPoints.length,
              itemBuilder: (context, index) {
                final point = filteredPoints[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      point.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(point.address),
                        const SizedBox(height: 4),
                        Text(
                          point.openingHours,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: point.acceptedMaterials
                              .map((material) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              material,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Центрируем карту на выбранной точке
                      _controller.future.then((controller) {
                        controller.animateCamera(
                          CameraUpdate.newLatLngZoom(point.position, 15),
                        );
                      });

                      // Показываем подробную информацию
                      _showPointDetails(point);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}