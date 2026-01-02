import 'package:flutter_test/flutter_test.dart';
import 'package:nightfall_projct/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('SplitHomeScreen loads with PageView', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the SplitHomeScreen is present
    expect(find.byType(SplitHomeScreen), findsOneWidget);
    
    // Verify that the PageView is present
    expect(find.byType(PageView), findsOneWidget);

    // Verify that we start with the image (checking for ImageSection isn't directly possible by type 
    // unless we export it or find by type if public, but we can check for Containers or verify logic).
    // Start page is 1, so verify we are there? 
    // It's hard to verify "page 1" visually without screenshot tests, 
    // but we can ensure the widget tree is stable.
  });
}
