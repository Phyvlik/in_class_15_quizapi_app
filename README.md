# Activity 15 - Quiz App with Answer Feedback

**Course:** Mobile App Development
**Student:** Vivek Patel
**GitHub:** https://github.com/Phyvlik/in_class_15_quizapi_app

A fully interactive trivia quiz app built in Flutter that fetches real programming questions from the QuizAPI, provides instant answer feedback, and adapts difficulty based on performance.

---

## Features

### Core
- Fetches 10 multiple-choice questions from QuizAPI with Bearer token authentication
- Shuffled answer options on every question to ensure fairness
- Color-coded feedback: green for correct, red for selected wrong answer
- SVG icons (checkmark/X) paired with color for color-blind accessibility
- Snackbar notification after each answer showing correct answer if wrong
- Manual Next button so users can read feedback before advancing
- Final results screen with score, performance message, and Play Again button
- Error screen with Retry button for network failures and timeouts
- Loading screen with SVG animation during API fetch

### Extension Track (Undergraduate - 2 of 5)

**Option 2: Difficulty Personalization Engine**
- Scoring 80% or above automatically escalates difficulty for the next quiz (EASY to MEDIUM, MEDIUM to HARD)
- Scoring below 40% drops difficulty to rebuild confidence
- Adapted difficulty is displayed as a badge on the results screen and passed to the next QuizScreen

**Option 3: Smart Review Summary**
- Every incorrect answer records the question category into a missed list
- Results screen groups missed answers by category and shows how many were missed per category
- Gives users a targeted study guide instead of just a score

---

## Project Structure

```
lib/
  main.dart               - App entry point and theme
  app_config.dart         - API key configuration
  models/
    question.dart         - Question data model and JSON parsing
  services/
    trivia_service.dart   - QuizAPI HTTP service with Bearer auth
  screens/
    quiz_screen.dart      - Main quiz UI and state management
    result_screen.dart    - Results, difficulty adaptation, review summary
assets/
  images/
    loading.svg           - Displayed during API fetch
    celebration.svg       - Displayed on results screen
  icons/
    correct.svg           - Shown next to correct answer after tap
    incorrect.svg         - Shown next to wrong selection after tap
```

---

## API

Uses the [QuizAPI](https://quizapi.io) Questions endpoint.

- **Endpoint:** `https://quizapi.io/api/v1/questions`
- **Auth:** Bearer token in Authorization header
- **Parameters:** limit, difficulty, category, type, random

---

## Running the App

```bash
flutter pub get
flutter run --dart-define=QUIZ_API_KEY=your_api_key_here
```

## Building the APK

```bash
flutter build apk --release --dart-define=QUIZ_API_KEY=your_api_key_here
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`

---

## Dependencies

- `http` - REST API calls
- `flutter_svg` - SVG asset rendering
