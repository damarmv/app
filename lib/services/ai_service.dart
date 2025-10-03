import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey = "YOUR_OPENAI_API_KEY"; // ganti API-mu

  Future<String> explainError(String log) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {"role": "system", "content": "Kamu adalah asisten debugging Flutter Web."},
            {"role": "user", "content": log}
          ],
          "max_tokens": 200
        }),
      );

      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"] ?? "Tidak ada saran AI";
    } catch (e) {
      return "Gagal meminta saran AI: $e";
    }
  }
}
