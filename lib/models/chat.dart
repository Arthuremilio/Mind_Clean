import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../components/chat_balloon.dart';

class ChatProvider with ChangeNotifier {
  String? userId;
  final ImagePicker _picker = ImagePicker();
  final List<ChatBalloon> _messages = [];

  List<ChatBalloon> get messages => _messages;

  void setUserId(String id) {
    userId = id;
    notifyListeners();
  }

  Future<void> getMessages(String userId) async {
    _messages.clear();
    try {
      final response = await http.get(
        Uri.parse(
            'https://mind-clean-default-rtdb.firebaseio.com/historyChat.json'),
      );

      if (response.body == 'null' || response.statusCode != 200) return;

      final Map<String, dynamic> data = jsonDecode(response.body);

      data.forEach((key, value) {
        if (value['userId'] == userId) {
          String timestamp = value['timestamp'];
          DateTime messageTime = DateTime.parse(timestamp);

          if (value['image'] != null) {
            final imageBytes = base64Decode(value['image']);
            _messages.insert(
              0,
              ChatBalloon(
                image: Image.memory(imageBytes),
                isUserMessage: value['isUserMessage'] ?? true,
                timestamp: messageTime,
              ),
            );
          } else if (value['message'] != null) {
            _messages.insert(
              0,
              ChatBalloon(
                message: value['message'],
                isUserMessage: value['isUserMessage'] ?? false,
                timestamp: messageTime,
              ),
            );
          }
        }
      });

      notifyListeners();
    } catch (error) {
      print("Erro ao obter mensagens: $error");
    }
  }

  Future<void> sendImageFromGallery(String userId) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    await _processImageAndSend(pickedFile, userId);
  }

  Future<void> sendImageFromCamera(String userId) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    await _processImageAndSend(pickedFile, userId);
  }

  Future<void> _sendImage(XFile? pickedFile, String userId) async {
    if (pickedFile == null) return;

    try {
      final imageBytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse(
            'https://mind-clean-default-rtdb.firebaseio.com/historyChat.json'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "image": base64Image,
          "isUserMessage": true,
          "userId": userId,
          "timestamp": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        _messages.insert(
          0,
          ChatBalloon(
            image: Image.file(File(pickedFile.path)),
            isUserMessage: true,
            timestamp: DateTime.now(),
          ),
        );
        notifyListeners();
      } else {
        print('Erro ao enviar a imagem: ${response.statusCode}');
      }
    } catch (error) {
      print("Erro ao enviar a imagem: $error");
    }
  }

  Future<void> _sendDescriptionImage(String description, String userId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://mind-clean-default-rtdb.firebaseio.com/historyChat.json'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "message": description,
          "isUserMessage": false,
          "userId": userId,
          "timestamp": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        _messages.insert(
          0,
          ChatBalloon(
            message: description,
            isUserMessage: false,
            timestamp: DateTime.now(),
          ),
        );
        notifyListeners();
      } else {
        print('Erro ao enviar a descrição: ${response.statusCode}');
      }
    } catch (error) {
      print("Erro ao enviar a descrição: $error");
    }
  }

  Future<void> _processImageAndSend(XFile? pickedFile, String userId) async {
    if (pickedFile == null) return;

    try {
      final bytes = await pickedFile.readAsBytes();
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: 'ChaveDaAPI',
      );
      final prompt =
          "Descreva de maneira resumida se existe uma pessoa na imagem";
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', bytes),
        ])
      ];
      final response = await model.generateContent(content);
      await _sendImage(pickedFile, userId);
      await _sendDescriptionImage(response.text ?? '', userId);
    } catch (error) {
      print("Erro no processamento da imagem e descrição: $error");
    }
  }
}
