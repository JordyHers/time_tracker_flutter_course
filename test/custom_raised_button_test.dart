import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

void main(){
  /// This syntax is used to test widgets
  ///
  /// we use it to build and interact in a test environment
  testWidgets('', (WidgetTester tester) async {


    /// pumpWidget is always called for the widget we want to build
    ///don't forget to surround it with a [Material Widget]
    await tester.pumpWidget(MaterialApp(home: CustomRaisedButton(
      child: Text('tap me'),
    )));

  ///This code tries to find if in CustomRaisedButton there is a RaisedButton
  final button = find.byType(RaisedButton);
  ///we use it a finder which finds fromType
  expect(button,findsOneWidget);
  ///findsNothing is used to check if no widget are found
  expect(find.byType(FlatButton), findsNothing);

  ///here we try to find if a widget text holds tap me as value
  expect(find.text('tap me'), findsOneWidget);

  });
}