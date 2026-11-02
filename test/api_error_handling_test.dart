import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/base_api.dart';
import 'package:jigers_kitchen/core/contstants.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';
import 'package:jigers_kitchen/utils/widget/success_dialoug.dart';

class TestableBaseApi extends BaseApi {
  Response? testProcessResponse(Response? response) {
    return processResponseForTest(response);
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  test('BaseApi processes 400 Bad Request JSON and normalizes error message', () {
    final api = TestableBaseApi();
    const errorJson = {'status': 400, 'message': 'Incorrect password.'};
    final response = Response(statusCode: 400, body: errorJson);

    final result = api.testProcessResponse(response);
    expect(result, isNotNull);
    expect(result!.body['status'], 400);
    expect(result.body['message'], 'Incorrect password.');
  });

  test('BaseApi processes 422 validation errors map into readable string', () {
    final api = TestableBaseApi();
    final errorJson = {
      'message': 'The given data was invalid.',
      'errors': {
        'email': ['The email has already been taken.'],
        'phone': ['The phone field is required.']
      }
    };
    final response = Response(statusCode: 422, body: errorJson);

    final result = api.testProcessResponse(response);
    expect(result, isNotNull);
    expect(result!.body['status'], 400);
    expect(result.body['message'], contains('The email has already been taken.'));
  });

  test('BaseApi processes 500 HTML error body without crashing', () {
    final api = TestableBaseApi();
    const htmlError = '<!DOCTYPE html><html><body><h1>500 Server Error</h1></body></html>';
    final response = Response(statusCode: 500, body: htmlError, statusText: 'Internal Server Error');

    final result = api.testProcessResponse(response);
    expect(result, isNotNull);
    expect(result!.body['status'], 400);
    expect(result.body['message'], 'Internal server error. Please try again later.');
  });

  test('BaseApi decodes JSON string body for 200 response', () {
    final api = TestableBaseApi();
    final jsonStr = json.encode({'status': 200, 'data': {'id': 123}});
    final response = Response(statusCode: 200, body: jsonStr);

    final result = api.testProcessResponse(response);
    expect(result, isNotNull);
    expect(result!.body['status'], 200);
    expect(result.body['data']['id'], 123);
  });

  testWidgets('API error handling dismisses loader and does not pop route', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => Scaffold(
                      body: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            appWidgets.loadingDialog();
                          },
                          child: const Text('Target Screen'),
                        ),
                      ),
                    ));
              },
              child: const Text('Open Target Screen'),
            ),
          ),
        ),
      ),
    );

    // Navigate to target screen
    await tester.tap(find.text('Open Target Screen'));
    await tester.pumpAndSettle();
    expect(find.text('Target Screen'), findsOneWidget);

    // Show loading dialog
    await tester.tap(find.text('Target Screen'));
    await tester.pump();
    expect(Get.isDialogOpen, isTrue);

    // Trigger API error via Constants.internalServerErrorToast()
    Constants.internalServerErrorToast();
    await tester.pumpAndSettle();

    // Verify dialog was closed but route was NOT popped
    expect(Get.isDialogOpen, isFalse);
    expect(find.text('Target Screen'), findsOneWidget);
    expect(find.text('Open Target Screen'), findsNothing);
  });

  test('BaseApi normalizes string status 200, success, and boolean into integer 200', () {
    final api = TestableBaseApi();
    
    // String "200"
    final res1 = api.testProcessResponse(Response(
      statusCode: 200,
      body: {'status': '200', 'message': 'Chef registered'},
    ));
    expect(res1!.body['status'], 200);

    // "success"
    final res2 = api.testProcessResponse(Response(
      statusCode: 200,
      body: {'status': 'success', 'message': 'Chef registered'},
    ));
    expect(res2!.body['status'], 200);

    // success: true
    final res3 = api.testProcessResponse(Response(
      statusCode: 200,
      body: {'success': true, 'message': 'Chef registered'},
    ));
    expect(res3!.body['status'], 200);
  });

  testWidgets('Chef added: loader dismisses instantly on success and shows success dialog', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                // Simulate addChef action
                appWidgets.loadingDialog();
                // Simulate API 200 response
                appWidgets.hideDialog();
                showDialogWithAutoDismiss(
                  context: Get.context,
                  doubleBack: false,
                  heading: "Hurray!",
                  text: "Chef Added Successfully",
                );
              },
              child: const Text('Add Chef'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Add Chef'));
    // Pump frames to let post-frame showDialog execute
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Loader is gone
    expect(appWidgets.isLoading, isFalse);
    // Success dialog is displayed
    expect(find.text('Hurray!'), findsOneWidget);
    expect(find.text('Chef Added Successfully'), findsOneWidget);
  });
}
