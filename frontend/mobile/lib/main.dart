import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFE91E63), // สีชมพูหลัก
        scaffoldBackgroundColor: Color(0xFF000000), // สีดำ
      ),
      home: CalorieCalculatorPage(),
    );
  }
}

class CalorieCalculatorPage extends StatefulWidget {
  const CalorieCalculatorPage({super.key});

  @override
  State<CalorieCalculatorPage> createState() => _CalorieCalculatorPageState();
}

class _CalorieCalculatorPageState extends State<CalorieCalculatorPage> {
  // State variables for input data (protein, fat, sugars)
  double? _protein;
  double? _fat;
  double? _sugars;

  // State variables for output data (calories)
  double? _calories;
  bool _isLoading = false;
  String? _errorMessage;

  // Controller for text fields
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _sugarsController = TextEditingController();

  @override
  void dispose() {
    _proteinController.dispose();
    _fatController.dispose();
    _sugarsController.dispose();
    super.dispose();
  }

  // Function to calculate calories
  void _calculateCalories() {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
      _calories = null;
    });

    // Check if all fields are filled
    if (_protein == null || _fat == null || _sugars == null) {
      setState(() {
        _errorMessage = 'กรุณากรอกข้อมูลให้ครบถ้วน';
        _isLoading = false;
      });
      return;
    }

    // Simulate API call with a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      final double calculatedCalories = (_protein! * 4) + (_fat! * 9) + (_sugars! * 4);
      setState(() {
        _calories = calculatedCalories;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black, // Background สีดำ
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text(
              'คำนวณแคลอรี',
              style: TextStyle(
                color: Color(0xFFE91E63), // สีชมพู
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFF2C2C2E).withOpacity(0.8), // สีเทาดำโปร่งแสง
            border: Border.all(color: Colors.transparent), // ซ่อนเส้นขอบ
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Header
                  const SizedBox(height: 20),
                  const Center(
                    child: Icon(
                      Icons.local_dining, // แก้ไขไอคอนตรงนี้
                      color: Color(0xFF4CAF50), // สีเขียว
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'คำนวณแคลอรีซีเรียลของคุณ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Protein Input
                  _buildInputSection(
                    title: 'โปรตีน (กรัม)',
                    placeholder: '0 - 120 กรัม',
                    controller: _proteinController,
                    onChanged: (value) {
                      setState(() {
                        _protein = double.tryParse(value);
                      });
                    },
                  ),

                  // Fat Input
                  _buildInputSection(
                    title: 'ไขมัน (กรัม)',
                    placeholder: '0 - 100 กรัม',
                    controller: _fatController,
                    onChanged: (value) {
                      setState(() {
                        _fat = double.tryParse(value);
                      });
                    },
                  ),

                  // Sugars Input
                  _buildInputSection(
                    title: 'น้ำตาล (กรัม)',
                    placeholder: '0 - 20 กรัม',
                    controller: _sugarsController,
                    onChanged: (value) {
                      setState(() {
                        _sugars = double.tryParse(value);
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  // Calculate Button
                  _buildCalculateButton(),

                  const SizedBox(height: 20),

                  // Error Message
                  if (_errorMessage != null)
                    _buildErrorMessage(),

                  // Results
                  if (_calories != null)
                    _buildResultCard(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection({
    required String title,
    required String placeholder,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            cursorColor: const Color(0xFFE91E63),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return CupertinoButton(
      color: Colors.pink, // พื้นหลังสีชมพู
      borderRadius: BorderRadius.circular(15),
      padding: const EdgeInsets.symmetric(vertical: 16),
      onPressed: (_protein == null || _fat == null || _sugars == null || _isLoading)
          ? null
          : _calculateCalories,
      child: _isLoading
          ? const CupertinoActivityIndicator(color: Colors.white)
          : const Text(
              'คำนวณแคลอรี',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE91E63)),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.info, color: Color(0xFFE91E63)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Color(0xFFE91E63),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFF4CAF50)], // ชมพู-เขียว
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'ผลการคำนวณ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _calories!.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'แคลอรี',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
