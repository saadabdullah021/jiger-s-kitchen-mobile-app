import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../utils/widget/appwidgets.dart';
import '../../utils/widget/no_internet_dialog.dart';

class BaseApi extends GetConnect {
  // late SharedPreferences prefs;
  @override
  void onInit() {
    // allowAutoSignedCert = true;
    super.onInit();
    // httpClient.baseUrl = Constants.API_BASE_URL;
    httpClient.timeout = const Duration(seconds: 60);
  }

  Future<Response?> sendPost(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    final stopwatch = Stopwatch()..start();
    Response? response;
    try {
      response = await _requestWithRetry(() => post(url, FormData(body),
          contentType: contentType, headers: headers, query: query));
    } catch (e, stack) {
      developer.log('sendPost exception: $e',
          name: 'API', error: e, stackTrace: stack);
      response = null;
    }
    stopwatch.stop();

    _logResponse(
      method: 'POST',
      url: url,
      query: query,
      requestBody: body,
      response: response,
      durationMs: stopwatch.elapsedMilliseconds,
    );

    return _processResponse(response);
  }

  Future<Response?> sendPostRaw(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    final stopwatch = Stopwatch()..start();
    Response? response;
    try {
      response = await _requestWithRetry(() => post(url, json.encode(body),
          contentType: contentType, headers: headers, query: query));
    } catch (e, stack) {
      developer.log('sendPostRaw exception: $e',
          name: 'API', error: e, stackTrace: stack);
      response = null;
    }
    stopwatch.stop();

    _logResponse(
      method: 'POST (RAW)',
      url: url,
      query: query,
      requestBody: body,
      response: response,
      durationMs: stopwatch.elapsedMilliseconds,
    );

    return _processResponse(response);
  }

  Future<Response?> sendGet(String url,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    final stopwatch = Stopwatch()..start();
    Response? response;
    try {
      response = await _requestWithRetry(() =>
          get(url, contentType: contentType, headers: headers, query: query));
    } catch (e, stack) {
      developer.log('sendGet exception: $e',
          name: 'API', error: e, stackTrace: stack);
      response = null;
    }
    stopwatch.stop();

    _logResponse(
      method: 'GET',
      url: url,
      query: query,
      response: response,
      durationMs: stopwatch.elapsedMilliseconds,
    );

    return _processResponse(response);
  }

  Future<Response?> _requestWithRetry(
      Future<Response> Function() sendRequest) async {
    Response response;
    try {
      response = await sendRequest();
    } catch (e) {
      response = Response(statusCode: null, statusText: e.toString());
    }
    while (response.statusCode == null) {
      final retry = await NoInternetDialog.show();
      if (!retry) return response;
      try {
        response = await sendRequest();
      } catch (e) {
        response = Response(statusCode: null, statusText: e.toString());
      }
    }
    return response;
  }

  Response? _processResponse(Response? response) {
    if (response == null || response.statusCode == null) {
      appWidgets.hideDialog();
      appWidgets().showToast(
        "Connection Error",
        "Unable to connect to the server. Please check your internet connection.",
      );
      return null;
    }

    dynamic body = response.body;
    if (body is String && body.trim().isNotEmpty) {
      try {
        body = json.decode(body);
      } catch (_) {
        // Not a JSON string (could be HTML error or plain text)
      }
    }

    // Success response with valid body
    if (response.statusCode == 200) {
      if (body is Map) {
        final map = Map<String, dynamic>.from(body);
        final rawStatus = map['status']?.toString().trim().toLowerCase();
        if (rawStatus == null ||
            rawStatus == '200' ||
            rawStatus == 'success' ||
            rawStatus == 'true' ||
            rawStatus == '1' ||
            map['success'] == true) {
          map['status'] = 200;
        } else if (rawStatus == '400' ||
            rawStatus == 'error' ||
            rawStatus == 'false' ||
            rawStatus == '0') {
          map['status'] = 400;
        }
        return Response(
          body: map,
          statusCode: response.statusCode,
          statusText: response.statusText,
          headers: response.headers,
        );
      }
      return response;
    }

    // Non-200 HTTP response (400, 401, 403, 404, 422, 500, etc.)
    Map<String, dynamic> bodyMap;
    if (body is Map) {
      bodyMap = Map<String, dynamic>.from(body);
    } else {
      bodyMap = <String, dynamic>{};
    }

    String? message;
    if (bodyMap['errors'] != null) {
      if (bodyMap['errors'] is Map) {
        message = (bodyMap['errors'] as Map)
            .values
            .map((v) => v is List ? v.join(', ') : v.toString())
            .join('\n');
      } else if (bodyMap['errors'] is List) {
        message = (bodyMap['errors'] as List).join(', ');
      } else {
        message = bodyMap['errors'].toString();
      }
    } else if (bodyMap['error'] != null) {
      message = bodyMap['error'].toString();
    } else if (bodyMap['message'] != null &&
        bodyMap['message'].toString().trim().isNotEmpty) {
      if (bodyMap['message'] is List) {
        message = (bodyMap['message'] as List).join(', ');
      } else if (bodyMap['message'] is Map) {
        message = (bodyMap['message'] as Map)
            .values
            .map((v) => v is List ? v.join(', ') : v.toString())
            .join('\n');
      } else {
        message = bodyMap['message'].toString();
      }
    } else if (body is String &&
        body.trim().isNotEmpty &&
        !body.contains('<html') &&
        !body.contains('<!DOCTYPE')) {
      message = body.trim();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      message = "Unauthorized. Please login again.";
    } else if (response.statusCode == 404) {
      message = "Requested resource not found.";
    } else if (response.statusCode != null && response.statusCode! >= 500) {
      message = "Internal server error. Please try again later.";
    } else {
      message = response.statusText ?? "Request failed. Please try again.";
    }

    // Route through AppInterface's standard `status == 400` handler to display the message and hide loader
    bodyMap['status'] = 400;
    bodyMap['message'] = message;
    bodyMap['http_status'] = response.statusCode;

    return Response(
      body: bodyMap,
      statusCode: response.statusCode,
      statusText: response.statusText,
      headers: response.headers,
    );
  }

  @visibleForTesting
  Response? processResponseForTest(Response? response) =>
      _processResponse(response);

  void _logResponse({
    required String method,
    required String? url,
    Map<String, dynamic>? query,
    dynamic requestBody,
    Response? response,
    int? durationMs,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('==================== [API RESPONSE] ====================');
    buffer.writeln('METHOD   : $method');
    buffer.writeln('URL      : $url');
    if (query != null && query.isNotEmpty) {
      buffer.writeln('QUERY    : $query');
    }
    if (requestBody != null) {
      buffer.writeln('REQ BODY : $requestBody');
    }
    if (durationMs != null) {
      buffer.writeln('DURATION : ${durationMs}ms');
    }
    if (response == null) {
      buffer.writeln('STATUS   : NULL (No response / network error)');
    } else {
      buffer.writeln('STATUS   : ${response.statusCode} ${response.statusText ?? ''}');
      buffer.writeln('BODY     :');
      try {
        if (response.body is Map || response.body is List) {
          const encoder = JsonEncoder.withIndent('  ');
          buffer.writeln(encoder.convert(response.body));
        } else if (response.bodyString != null &&
            response.bodyString!.isNotEmpty) {
          try {
            final decoded = json.decode(response.bodyString!);
            const encoder = JsonEncoder.withIndent('  ');
            buffer.writeln(encoder.convert(decoded));
          } catch (_) {
            buffer.writeln(response.bodyString);
          }
        } else {
          buffer.writeln(response.body ?? '<empty>');
        }
      } catch (e) {
        buffer.writeln(response.bodyString ?? response.body ?? '<parse error>');
      }
    }
    buffer.writeln('========================================================');

    final message = buffer.toString();
    developer.log(message, name: 'API');
    debugPrint(message);
  }

  BaseApi() : super(timeout: const Duration(seconds: 60));
}
