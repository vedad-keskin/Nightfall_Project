import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nightfall Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplitHomeScreen(),
    );
  }
}

class SplitHomeScreen extends StatefulWidget {
  const SplitHomeScreen({super.key});

  @override
  State<SplitHomeScreen> createState() => _SplitHomeScreenState();
}

class _SplitHomeScreenState extends State<SplitHomeScreen> {
  // Page 0: Left side of image
  // Page 1: Right side of image
  // Initial page is 1 (Right side)
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        // Optional: Add physics if you want specific scroll behavior,
        // but default PageScrollPhysics gives the snapping effect.
        children: const [
          // Page 0: Left Half
          ImageSection(
            imagePath: 'assets/images/2-split-home.jpg',
            alignment: Alignment.centerLeft,
          ),
          // Page 1: Right Half
          ImageSection(
            imagePath: 'assets/images/2-split-home.jpg',
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String imagePath;
  final Alignment alignment;

  const ImageSection({
    super.key,
    required this.imagePath,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    // Using Container with DecorationImage to handle alignment and fit easily
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          alignment: alignment,
        ),
      ),
    );
  }
}
