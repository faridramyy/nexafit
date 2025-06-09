// ✅ Step 1: Import required libraries
import 'dart:convert'; // To convert JSON strings to Dart Maps
import 'package:http/http.dart' as http; // To make HTTP requests

// 🚀 GeminiService: Handles communication with Gemini API
class GeminiService {
  // ✅ Step 2: Add your Gemini API key here
  // 👉 Ask your instructor or refer to the lab handout for your API key
  static const String apiKey = "AIzaSyAkKtXkNqZJGyrKtish9SkjVn-0Dl3czec";

  // ✅ Step 3: Define the API endpoint URL
  // Don't change this unless instructed
  static const String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

  // 🧠 Step 4: Function to send the prompt and get a response
  static Future<String> getResponse(String message) async {
    String prompt =
        """You are a fitness expert. You are given a message from a user and you need to respond to them. 
    Format your response using markdown for better readability. Use:
    - Headers (# for main headers, ## for subheaders)
    - Lists (both ordered and unordered)
    - Bold and italic text for emphasis
    - Code blocks for specific instructions or measurements
    - Blockquotes for important tips or warnings
    
    The user's message is: $message""";

    try {
      // 📨 Step 4.1: Send POST request to Gemini API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}, // 📝 Sending the user's prompt here
              ],
            },
          ],
        }),
      );

      // 🛠️ Debug: Print API response to console
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // ✅ Step 4.2: Handle successful response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Parse JSON response
        return data["candidates"][0]["content"]["parts"][0]["text"]; // Extract AI reply
      } else {
        // ❌ Step 4.3: Handle errors (e.g., invalid API key)
        return "Error: ${response.body}";
      }
    } catch (e) {
      // ❗ Step 4.4: Handle unexpected exceptions (like no internet)
      return "Error: $e";
    }
  }
}
