AI Chatbot Mobile App (Flutter + API)

This project is a mobile AI Chatbot app built using Flutter. It connects to an AI language model (like ChatGPT or Groq) using an API and mimics a modern conversational interface, storing history just like the real ChatGPT app.



Features

- Built with Flutter 3.0+
- Uses Groq or OpenAI API for chat responses
- Modern chat UI with user and bot messages
- Persistent conversation history using SharedPreferences
- Shows "Thinking..." while waiting for responses
- Collapsible chat history drawer with date/time-based organization
- Works on both emulator and physical Android device



Tech Stack

- Flutter (Dart)
- Android Studio Arctic Fox
- JDK 17
- SharedPreferences (for local data storage)
- Groq/OpenAI API (via HTTP requests)



Project Structure



+-- lib/
¦   +-- main.dart              # App entry point
¦   +-- chat_screen.dart       # Main chat interface
¦   +-- chat_drawer.dart       # Chat history drawer
¦   +-- api_service.dart       # Handles communication with Groq/OpenAI
¦   +-- models/
¦   ¦   +-- message_model.dart # Data model for chat messages
¦   +-- utils/
¦       +-- shared_prefs.dart  # History persistence logic
+-- assets/
¦   +-- logo.png               # App logo (optional)
+-- pubspec.yaml               # Flutter dependencies




API Key Configuration

Before running the app, configure your API key.

Example (in `api_service.dart`):


final String apiKey = 'YOUR_API_KEY_HERE'; // Replace with Groq or OpenAI key


> You can store this in a `.env` file for security (optional advanced feature).





Security Note

* Do not hardcode your API key in public GitHub repositories.
* Use `.gitignore` to exclude sensitive config files.


Future Plans

* Add voice input & output (speech-to-text & text-to-speech)
* Support multi-language chatting
* Save chat history to cloud (Firebase/SQLite)
* Add user login for chat sync across devices



Author

* Nowfal
* GitHub: [https://github.com/Nowfal7861/My_Projects



License

This project is open-source and licensed under the MIT License.

