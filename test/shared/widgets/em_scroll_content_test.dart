import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gz_app/shared/widgets/em_scroll_content.dart';

void main() {
  testWidgets('can be used inside an Expanded parent', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: EmScrollContent(
                  child: SizedBox(height: 800, child: Text('Scrollable')),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
