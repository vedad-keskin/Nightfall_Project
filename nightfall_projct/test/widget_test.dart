import 'package:flutter_test/flutter_test.dart';
import 'package:nightfall_projct/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('SplitHomeScreen loads with Centered Scroll View', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the SplitHomeScreen is present
    expect(find.byType(SplitHomeScreen), findsOneWidget);
    
    // Verify that SingleChildScrollView is present
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    // Verify that the Image is present
    expect(find.byType(Image), findsOneWidget);
  });
}

