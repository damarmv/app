import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTHelper {
  final String apiKey;
  ChatGPTHelper({required this.apiKey});

  Future<String> ask(String prompt) async {
    if (apiKey.isEmpty || apiKey.startsWith('<')) return "ChatGPT API key not set.";
    try {
      final url = Uri.parse("https://api.openai.com/v1/chat/completions");
      final resp = await http.post(url,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'},
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are assistant for a poultry farm management app. Answer in Indonesian."},
            {"role": "user", "content": prompt}
          ],
          "max_tokens": 400,
          "temperature": 0.2
        }));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['choices'][0]['message']['content'] ?? "No reply";
      } else {
        return "GPT error ${resp.statusCode}: ${resp.body}";
      }
    } catch (e) {
      return "GPT request failed: $e";
    }
  }
}
