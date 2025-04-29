import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CameraScreen extends StatefulWidget { // Сынып атауын CameraScreen қалдырамыз немесе GalleryScreen деп өзгертуге болады
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _apiResponse;
  bool _isLoading = false;
  String? _errorMessage;
  File? _selectedImage;

  // --- API Конфигурациясы ---
  final String _apiKey = "AIzaSyDYgxAqt5g6xvJkOomVCWDXhHo8DYYJ3M4"; // Өз API кілтіңізді қойыңыз
  final String _apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
  // -------------------------

  Future<void> _pickAndAnalyzeImage() async {
    setState(() {
      _isLoading = true;
      _apiResponse = null;
      _errorMessage = null;
      _selectedImage = null;
    });

    try {
      // *** ӨЗГЕРІС ОСЫ ЖЕРДЕ: Камера орнына Галереядан сурет алу ***
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // Камера орнына галереяны көрсету
        maxWidth: 800,
        imageQuality: 85,
      );
      // ************************************************************

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        setState(() {
          _selectedImage = imageFile;
        });

        // Суретті base64 форматына аудару
        final List<int> imageBytes = await imageFile.readAsBytes();
        final String base64Image = base64Encode(imageBytes);

        // Gemini API-ға сұрау жіберу
        await _callGeminiApi(base64Image);

      } else {
        // Пайдаланушы сурет таңдаудан бас тартты
        setState(() {
          _errorMessage = "Галереядан сурет таңдалмады.";
        });
      }
    } catch (e) {
      print("Қате пайда болды: $e");
      setState(() {
        _errorMessage = "Суретті өңдеу кезінде қате пайда болды: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _callGeminiApi(String base64Image) async {
    final prompt = "Суреттегі зат туралы анықтама, қауіптілігі, қайта өңделема";

    final requestBody = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
            {
              "inline_data": {
                // MIME типін анықтау маңызды болуы мүмкін, бірақ көбінесе jpeg/png жұмыс істейді
                // Егер нақты тип қажет болса, pickedFile.mimeType қолдануға болады (image_picker >= 0.8.1)
                "mime_type": "image/jpeg", // Немесе "image/png"
                "data": base64Image
              }
            }
          ]
        }
      ],
    });

    try {
      final response = await http.post(
        Uri.parse("$_apiUrl?key=$_apiKey"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final candidates = decodedResponse['candidates'] as List<dynamic>?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'] as Map<String, dynamic>?;
          if (content != null) {
            final parts = content['parts'] as List<dynamic>?;
            if (parts != null && parts.isNotEmpty) {
              final text = parts[0]['text'] as String?;
              if (text != null) {
                setState(() {
                  _apiResponse = text;
                  _errorMessage = null;
                });
                return;
              }
            }
          }
        }
        throw Exception("API жауабынан мәтінді алу мүмкін болмады.");

      } else {
        print("API қатесі: ${response.statusCode}");
        print("Жауап: ${response.body}");
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        final errorMessage = errorBody['error']?['message'] ?? 'Белгісіз API қатесі';
        throw Exception("API қатесі (${response.statusCode}): $errorMessage");
      }
    } catch (e) {
      print("API сұрауы кезінде қате: $e");
      setState(() {
        _errorMessage = "API-ға сұрау жіберу кезінде қате: $e";
        _apiResponse = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Тақырыпты сәйкестендіру
        title: const Text('Галереядан Объектіні Анықтау'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: CircularProgressIndicator(),
                  )
                else if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Қате: $_errorMessage',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                else if (_apiResponse != null)
                    Column(
                      children: [
                        if (_selectedImage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                _selectedImage!,
                                height: 250,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'AI Жауабы:\n\n$_apiResponse',
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    )
                  else if (_selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            _selectedImage!,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    else
                      const Padding( // Нұсқаулық мәтінін өзгерту
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Объектіні анықтау үшін төмендегі батырманы басып, галереядан сурет таңдаңыз.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                const SizedBox(height: 30),

                // Батырма мәтіні мен иконкасын өзгерту
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _isLoading ? null : _pickAndAnalyzeImage,
                  icon: const Icon(Icons.photo_library_outlined), // Галерея иконкасы
                  label: const Text('Галереядан Таңдау'), // Батырма мәтіні
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}