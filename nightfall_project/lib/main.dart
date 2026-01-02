import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/impostor_game/layouts/game_layout.dart';
import 'package:nightfall_project/mafia_game/layouts/game_layout.dart';

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
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplitHomeScreen extends StatefulWidget {
  const SplitHomeScreen({super.key});

  @override
  State<SplitHomeScreen> createState() => _SplitHomeScreenState();
}

class _SplitHomeScreenState extends State<SplitHomeScreen> {
  ScrollController? _scrollController;
  int _currentPage = 1; // Start on Right side (index 1)

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _scrollController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController == null || !_scrollController!.hasClients) return;
    final width = MediaQuery.of(context).size.width;
    final page = (_scrollController!.offset / width).round();
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          if (width == 0) return const SizedBox();

          if (_scrollController == null) {
            _scrollController = ScrollController(initialScrollOffset: width);
            _scrollController!.addListener(_onScroll);
          }

          return SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            child: SizedBox(
              width: width * 2,
              height: constraints.maxHeight,
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/2-split-home.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Left Side - Mafia
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: width,
                    child: Align(
                      alignment: const Alignment(0.0, -0.6), // Move up more
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _currentPage == 0 ? 1.0 : 0.0,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 500),
                          scale: _currentPage == 0 ? 1.0 : 0.8,
                          child: PixelDialog(
                            title: 'MAFIA',
                            color: Colors.black54, // More transparent
                            accentColor: Colors.redAccent,
                            soundPath: 'audio/wolf_howl.mp3',
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                    seconds: 2,
                                  ),
                                  reverseTransitionDuration: const Duration(
                                    seconds: 1,
                                  ),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                        return const MafiaGameLayout();
                                      },
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Right Side - Impostor
                  Positioned(
                    left: width,
                    top: 0,
                    bottom: 0,
                    width: width,
                    child: Align(
                      alignment: const Alignment(0.0, -0.6), // Move up more
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _currentPage == 1 ? 1.0 : 0.0,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 500),
                          scale: _currentPage == 1 ? 1.0 : 0.8,
                          child: PixelDialog(
                            title: 'IMPOSTOR',
                            color: const Color.fromRGBO(255, 82, 82, 0.7),
                            accentColor: Colors.black87,
                            soundPath: 'audio/mystery_mist.mp3',
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                    seconds: 2,
                                  ),
                                  reverseTransitionDuration: const Duration(
                                    seconds: 1,
                                  ),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                        return const ImpostorGameLayout();
                                      },
                                  settings: const RouteSettings(
                                    name: '/impostor_game',
                                  ),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        // Fade to black, then fade in new screen?
                                        // Or just a slow fade of the new screen over the old.
                                        // User asked for "transition... last 3 seconds... 3second animation"
                                        // A simple FadeTransition is cleanest and fits the "mystery" vibe.
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Version Info
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Text(
                      'Nightfall Project v1.0.1',
                      style: GoogleFonts.vt323(
                        color: Colors.white24,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
