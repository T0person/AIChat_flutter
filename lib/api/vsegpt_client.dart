// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';

// class VseGPTClient {
//   final String apiKey;
//   final String baseUrl;
//   final Map<String, String> headers;

//   VseGPTClient({
//     required this.apiKey,
//     required this.baseUrl,
//   }) : headers = {
//           'Authorization': 'Bearer $apiKey',
//           'Content-Type': 'application/json',
//           'X-Title': 'AI Chat Flutter',
//         } {
//     _initializeClient();
//   }

//   void _initializeClient() {
//     try {
//       if (kDebugMode) {
//         print('Initializing VseGPTClient...');
//         print('Base URL: $baseUrl');
//       }

//       if (kDebugMode) {
//         print('VseGPTClient initialized successfully');
//       }
//     } catch (e, stackTrace) {
//       if (kDebugMode) {
//         print('Error initializing VseGPTClient: $e');
//         print('Stack trace: $stackTrace');
//       }
//       rethrow;
//     }
//   }

//   Future<List<Map<String, dynamic>>> getModels() async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/models'),
//         headers: headers,
//       );

//       if (kDebugMode) {
//         print('Models response status: ${response.statusCode}');
//         print('Models response body: ${response.body}');
//       }

//       if (response.statusCode == 200) {
//         final modelsData = json.decode(response.body);
//         if (modelsData['data'] != null) {
//           return (modelsData['data'] as List)
//               .map((model) => {
//                     'id': model['id'] as String,
//                     'name': (() {
//                       try {
//                         return utf8.decode((model['name'] as String).codeUnits);
//                       } catch (e) {
//                         final cleaned = (model['name'] as String)
//                             .replaceAll(RegExp(r'[^\x00-\x7F]'), '');
//                         return utf8.decode(cleaned.codeUnits);
//                       }
//                     })(),
//                     'pricing': {
//                       'prompt': model['pricing']['prompt'] as String,
//                       'completion': model['pricing']['completion'] as String,
//                     },
//                     'context_length': (model['context_length'] ??
//                             model['top_provider']['context_length'] ??
//                             0)
//                         .toString(),
//                   })
//               .toList();
//         }
//         throw Exception('Invalid API response format');
//       } else {
//         return [
//           {'id': 'gpt-3.5-turbo', 'name': 'GPT-3.5 Turbo'},
//           {'id': 'gpt-4', 'name': 'GPT-4'},
//           {'id': 'yandexgpt', 'name': 'YandexGPT'},
//         ];
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error getting models: $e');
//       }
//       return [
//         {'id': 'gpt-3.5-turbo', 'name': 'GPT-3.5 Turbo'},
//         {'id': 'gpt-4', 'name': 'GPT-4'},
//         {'id': 'yandexgpt', 'name': 'YandexGPT'},
//       ];
//     }
//   }

//   Future<Map<String, dynamic>> sendMessage(String message, String model) async {
//     try {
//       final data = {
//         'model': model,
//         'messages': [
//           {'role': 'user', 'content': message}
//         ],
//         'max_tokens': 1000,
//         'temperature': 0.7,
//         'stream': false,
//       };

//       if (kDebugMode) {
//         print('Sending message to API: ${json.encode(data)}');
//       }

//       final response = await http.post(
//         Uri.parse('$baseUrl/chat/completions'),
//         headers: headers,
//         body: json.encode(data),
//       );

//       if (kDebugMode) {
//         print('Message response status: ${response.statusCode}');
//         print('Message response body: ${response.body}');
//       }

//       if (response.statusCode == 200) {
