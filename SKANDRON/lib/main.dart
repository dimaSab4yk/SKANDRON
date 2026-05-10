import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(), 
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        File image = File(pickedFile.path);

        setState(() {
          _selectedImage = image;
        });

        if (!mounted) return; 
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(imageFile: image),
          ),
        );
      }
    } catch (e) {
      print("Помилка при виборі фото: $e");
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        File image = File(pickedFile.path);

        if (!mounted) return;
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(imageFile: image),
          ),
        );
      }
    } catch (e) {
      print("Помилка при використанні камери: $e");
    }
  }

  void showUploadDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierColor: const Color(0xFFD9D9D9).withOpacity(0.6),
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 360,
                    height: 250,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF79AAD5).withOpacity(0.6),
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Оберіть спосіб завантажити фото',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildDialogButton(
                              imagePath: 'assets/images/GalleryBotton.svg', 
                              label: 'ГАЛЕРЕЯ',
                              onTap: () async {
                                try {
                                  final response = await http.post(Uri.parse('http://192.168.1.2:5000/click/GalleryBotton'));
                                  if (response.statusCode == 200) {
                                    Navigator.pop(context); 
                                    pickImage();           
                                  }
                                } catch (e) {
                                  print("Помилка сервера: $e");
                                }
                              },
                            ),
                            buildDialogButton(
                              imagePath: 'assets/images/CameraButton.svg', 
                              label: 'КАМЕРА',
                              onTap: () async {
                                try {
                                  final response = await http.post(Uri.parse('http://192.168.1.2:5000/click/CameraButton'));
                                  if (response.statusCode == 200) {
                                    Navigator.pop(context); 
                                    takePhoto();            
                                  }
                                } catch (e) {
                                  print("Помилка сервера: $e");
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

  void showUploadLastResult(BuildContext context, String scanTime, String imageUrl, List<Map<String, dynamic>> results) {
  showDialog(
    context: context,
    barrierColor: const Color(0xFFD9D9D9).withOpacity(0.6),
    builder: (BuildContext context) {
      return ScanDetailDialog(
        title: 'Останнє сканування:',
        scanTime: scanTime,
        imageUrl: imageUrl,
        results: results,
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4698CE),
              Color(0xFF79AAD5),
              Color(0xFF80ADD4),
              Color(0xFFBFD5E3),
              Color(0xFFDFECF2),
            ],
            stops: [0.0, 0.29, 0.47, 0.84, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 211,
              left: 0,
              right: 0,
              child: const Text(
                'SKANDRON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  fontSize: 48,
                  color: Colors.black,
                ),
              ),
            ),
            
            CustomFrame(
                imagePath: 'assets/images/lucide_scan.png',
                size: 72,
                rotation: -10,
                top: 58,     
                left: 38,      
              ),

              CustomFrame(
                imagePath: 'assets/images/lucide_scan.png',
                size: 40,
                rotation: 0,
                top: 320,
                left: 150,
              ),

              CustomFrame(
                imagePath: 'assets/images/lucide_scan.png',
                size: 90,
                rotation: 10,
                top: 530,
                left: 230,
              ),

              CustomFrame(
                imagePath: 'assets/images/Drone1.png',
                size: 130,
                rotation: 0,
                top: 77,
                left: 200,
              ),

              CustomFrame(
                imagePath: 'assets/images/Drone2.png',
                size: 220,
                rotation: 0,
                top: 300,
                left: 230,
              ),

              CustomFrame(
                imagePath: 'assets/images/Drone3.png',
                size: 210,
                rotation: -20,
                top: 280,
                left: -60,
              ),

              CustomFrame(
                imagePath: 'assets/images/Drone4.png',
                size: 110,
                rotation: 0,
                top: 490,
                left: 70,
              ),

                        ImageButton(
              imagePath: 'assets/images/ScanBatton.svg',
              width: 80,
              height: 80,
              bottom: 20,
              left: 0,
              right: 0,
              onTap: () async {
                print("Запитую сервер про відкриття діалогу...");
                try {
                  final url = Uri.parse('http://192.168.1.2:5000/click/scan_init');
                  final response = await http.post(url);

                  if (response.statusCode == 200) {
                    if (!context.mounted) return;
                    showUploadDialog(context);
                    print("Сервер дозволив. Діалог відкрито.");
                  } else {
                    print("Сервер відхилив запит");
                  }
                } catch (e) {
                  print("Помилка зв'язку: $e"); 
                }
              },
            ),

            ImageButton(
              imagePath: 'assets/images/LastResult.svg',
              width: 130,
              height: 80,
              bottom: 20,
              left: 20,
              onTap: () async {
                try {
                  final response = await http.get(Uri.parse('http://192.168.1.2:5000/get_last_scan'))
                      .timeout(const Duration(seconds: 5));

                  if (response.statusCode == 200) {
                    final data = jsonDecode(response.body);

                    if (data['status'] == 'success' && context.mounted) {
                      final List<dynamic> rawResults = data['results'] ?? [];
                      final List<Map<String, dynamic>> scanResults = rawResults
                          .map((e) => Map<String, dynamic>.from(e))
                          .toList();

                      showUploadLastResult(
                        context, 
                        data['time'] ?? "Час невідомий", 
                        data['image'] ?? "", 
                        scanResults,
                      );
                    }
                  }
                } catch (e) {
                  debugPrint("Помилка з'єднання: $e");
                }
              },
            ),

            ImageButton(
              imagePath: 'assets/images/History.svg',
              width: 130,
              height: 80,
              bottom: 20,
              right: 20,
              onTap: () async {
                try {
                  final url = Uri.parse('http://192.168.1.2:5000/click/history');
                  final response = await http.post(url);

                  if (response.statusCode == 200) {
                    if (!context.mounted) return;
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HistoryPage()),
                    );
                  } else {
                    print("Сервер заборонив відкриття історії. Код: ${response.statusCode}");
                  }
                } catch (e) {
                  print("Не вдалося отримати дозвіл від сервера: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget buildDialogButton({
    required String imagePath, 
    required String label, 
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          imagePath.endsWith('.svg')
              ? SvgPicture.asset(
                  imagePath,
                  width: 80, 
                  height: 80,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  imagePath,
                  width: 80, 
                  height: 80,
                  fit: BoxFit.contain,
                ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _historyData = [];
  
  bool _isLoading = false;
  int _currentOffset = 0; 
  final int _limit = 15;   
  bool _hasMore = true;    

  @override
  void initState() {
    super.initState();
    _fetchHistory(); 
  }

  Future<void> _fetchHistory() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('http://192.168.1.2:5000/api/get_history?offset=$_currentOffset&limit=$_limit');
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        setState(() {
          _historyData.addAll(data.cast<Map<String, dynamic>>());
          _currentOffset += data.length;
          
          if (data.length < _limit) {
            _hasMore = false;
          }
        });
      }
    } catch (e) {
      debugPrint("Помилка зв'язку з БД: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Не вдалося підключитися до сервера")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ІСТОРІЯ СКАНУВАНЬ',
          style: TextStyle(color: Colors.white, fontFamily: 'Nunito', fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4698CE),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4698CE), Color(0xFF79AAD5), Color(0xFF80ADD4), Color(0xFFBFD5E3), Color(0xFFDFECF2),
            ],
            stops: [0.0, 0.29, 0.47, 0.84, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                'Нещодавні сканування',
                style: TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: _historyData.isEmpty && _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : _historyData.isEmpty
                      ? const Center(
                          child: Text(
                            "Історія порожня",
                            style: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _historyData.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_hasMore && index == _historyData.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 30),
                                child: Center(
                                  child: _isLoading 
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : ElevatedButton(
                                        onPressed: _fetchHistory,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF519CD0),
                                          foregroundColor: Colors.white,
                                          fixedSize: const Size(280, 60),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                        ),
                                        child: const Text(
                                          "ЗАВАНТАЖИТИ ЩЕ...", 
                                          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 16)
                                        ),
                                      ),
                                ),
                              );
                            }

                            final item = _historyData[index];

                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierColor: const Color(0xFFD9D9D9).withOpacity(0.6),
                                  builder: (context) => ScanDetailDialog(
                                    title: 'Деталі сканування',
                                    scanTime: "${item['time']} ${item['date']}",
                                    imageUrl: item['image_url'] ?? "",
                                    results: [item], 
                                  ),
                                );
                              },
                              child: HistoryCard(
                                label: item['label'] ?? "Невідомо",
                                time: item['time'] ?? "00:00",
                                date: item['date'] ?? "00.00.0000",
                                accuracy: item['accuracy'] ?? "0%",
                              ),
                            );
                          },
                        )
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String label;
  final String time;
  final String date;
  final String accuracy;

  const HistoryCard({
    super.key,
    required this.label,
    required this.time,
    required this.date,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    bool isDrone = label.toLowerCase() == 'drone';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDrone ? Colors.green.shade50 : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDrone ? Icons.radar : Icons.help_outline,
              color: isDrone ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$date, $time",
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16, 
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8), 

                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                    children: [
                      const TextSpan(text: 'Статус: '),
                      TextSpan(
                        text: isDrone ? 'виявлено' : 'не виявлено',
                        style: TextStyle(
                          color: isDrone ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "Назва: $label", 
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 80, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    print("Видалити запис"); 
                  },
                  child: SvgPicture.asset(
                    'assets/images/ButtonDelete.svg', 
                    width: 30,
                    height: 30,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Точність", 
                      style: TextStyle(fontSize: 14, color: Colors.grey)
                    ),
                    Text(
                      accuracy,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDrone ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFrame extends StatelessWidget {
  final String imagePath;   
  final double size;        
  final double rotation;    
  final double top;         
  final double left;        

  const CustomFrame({
    super.key,
    required this.imagePath,
    required this.size,
    this.rotation = 0,      
    this.top = 0,
    this.left = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: rotation * (math.pi / 180), 
        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  final String imagePath;
  final double width;  
  final double height; 
  final double? top;  
  final double? bottom; 
  final double? left;
  final double? right;
  final VoidCallback onTap;

  const ImageButton({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: SizedBox(
            width: width,   
            height: height,
            child: imagePath.endsWith('.svg')
                ? SvgPicture.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
}

class PreviewScreen extends StatefulWidget {
  final File imageFile;

  const PreviewScreen({super.key, required this.imageFile});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isLoading = false;
  String _resultText = "";
  String? _serverImageUrl;

  Future<void> _scanImage() async {
    setState(() {
      _isLoading = true;
      _resultText = "Аналізую...";
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.2:5000/upload'), 
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', widget.imageFile.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List objects = data['objects'];

        setState(() {
          _serverImageUrl = data['result_image_url']; 

          if (objects.isEmpty) {
            _resultText = "Об'єктів не знайдено";
          } else {
            _resultText = objects
                .map((obj) => "${obj['label']} (${(obj['confidence'] * 100).toInt()}%)")
                .join(", ");
          }
        });
      } else {
        setState(() => _resultText = "Помилка сервера: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _resultText = "Помилка зв'язку: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFECF2),
      appBar: AppBar(
        title: const Text('Перегляд та аналіз', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF519CD0),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _serverImageUrl == null
                      ? Image.file(widget.imageFile, fit: BoxFit.contain)
                      : Image.network(
                          "$_serverImageUrl?v=${DateTime.now().millisecondsSinceEpoch}",
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                ),
              ),
            ),
            
            if (_resultText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _resultText,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF519CD0)),
                ),
              ),

            ElevatedButton(
              onPressed: _isLoading ? null : _scanImage, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF519CD0),
                foregroundColor: Colors.white,
                fixedSize: const Size(280, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("ЗАПУСТИТИ СКАНУВАННЯ"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ScanDetailDialog extends StatelessWidget {
  final String title;
  final String scanTime;
  final String imageUrl;
  final List<dynamic> results;

  const ScanDetailDialog({
    super.key,
    required this.title,
    required this.scanTime,
    required this.imageUrl,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double dialogHeight = screenHeight * 0.6;

    String label = "Невідомо";
    String accuracy = "0%";
    String status = "не виявлено";
    Color statusColor = const Color(0xFFE75454);

    if (results.isNotEmpty) {
      final firstResult = results[0];
      label = firstResult['label']?.toString() ?? "Невідомо";
      
      double conf = double.tryParse(firstResult['confidence'].toString()) ?? 
                    (double.tryParse(firstResult['accuracy']?.toString().replaceAll('%', '') ?? '0') ?? 0.0);
      
      if (conf <= 1.0 && conf > 0) {
        accuracy = "${(conf * 100).toStringAsFixed(0)}%";
      } else {
        accuracy = "${conf.toStringAsFixed(0)}%";
      }

      if (label.toLowerCase() == 'drone') {
        status = "виявлено";
        statusColor = const Color(0xFF0BB43A);
      }
    }

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: screenWidth - 32,
          height: dialogHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, 
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF323232),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        scanTime,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          color: Color(0xFF757575),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 85,
                  bottom: 125,
                  left: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) =>
                          progress == null ? child : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (context, e, s) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 20,
                  left: 25,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRichText("Назва: ", label),
                      const SizedBox(height: 6),
                      _buildStatusText("Статус: ", status, statusColor),
                      const SizedBox(height: 6),
                      _buildRichText("Точність: ", accuracy),
                    ],
                  ),
                ),

                Positioned(
                  top: 15,
                  right: 15,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF323232), size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'Nunito', fontSize: 16, color: Color(0xFF323232)),
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildStatusText(String label, String status, Color color) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'Nunito', fontSize: 16, color: Color(0xFF323232)),
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

