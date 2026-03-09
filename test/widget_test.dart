import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enterprise_field_service_tracker/main.dart';

void main() {
  testWidgets('App starts and shows task list screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    expect(find.text('Field Service Tasks'), findsOneWidget);
  });

  testWidgets('App has filter button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    expect(find.byIcon(Icons.filter_list), findsOneWidget);
  });

  testWidgets('App has floating action button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
