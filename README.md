# Expense Tracker

A cross-platform expense tracker app built with Flutter. Easily manage your income and expenses, visualize your spending, and keep your finances organized.

## Features
- User registration and login
- Add, edit, and delete transactions (income/expense)
- Categorize transactions (Food, Transportation, Entertainment, etc.)
- Monthly and overall statistics with charts
- Search and filter transactions
- Local database storage using SQLite (sqflite)
- Responsive UI for mobile and desktop

## Screenshots
*Add screenshots here if available*

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (comes with Flutter)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/swasthikdevadiga1/Mad
   cd mad
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure
```
lib/
  main.dart                # App entry point
  controllers/             # GetX controllers for state management
  models/                  # Data models (User, Transaction)
  routes/                  # App routes
  screens/                 # UI screens (login, register, home, stats, add transaction)
  services/                # Database and authentication services
  utils/                   # Theme, icons, helpers
  widgets/                 # Reusable widgets
```

## Main Packages Used
- [get](https://pub.dev/packages/get): State management and navigation
- [sqflite](https://pub.dev/packages/sqflite): SQLite database
- [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi): SQLite for desktop
- [google_fonts](https://pub.dev/packages/google_fonts): Custom fonts

## How It Works
- **Authentication:** Users can register and log in. User data is stored locally.
- **Transactions:** Each user can add income or expense transactions, categorized and timestamped.
- **Statistics:** View monthly and overall stats with charts for better insights.
- **Persistence:** All data is stored locally using SQLite, supporting both mobile and desktop platforms.

## How Database Works
- The app uses SQLite for local data storage via the `sqflite` and `sqflite_common_ffi` packages.
- There are two main tables: `users` and `transactions`.
  - The `users` table stores user credentials (id, name, email, password).
  - The `transactions` table stores all transactions with fields for title, amount, category, date, type (income/expense), and a reference to the user.
- On app startup, the database is initialized and tables are created if they do not exist.
- All CRUD operations (create, read, update, delete) for users and transactions are handled through service classes (`DbService`, `AuthService`).
- Each user's transactions are isolated by their user ID, ensuring privacy and separation of data.

## Program Flow
1. **App Launch:**
   - The app initializes the database and sets up GetX controllers for authentication and transactions.
2. **Authentication:**
   - Users can register or log in. On successful login, the user's data is loaded and stored in the controller.
3. **Main Screen:**
   - After login, users are taken to the main screen with navigation for Home, Statistics, and Add Transaction.
4. **Adding Transactions:**
   - Users can add new income or expense transactions, which are saved to the database and immediately reflected in the UI.
5. **Viewing & Managing Transactions:**
   - The Home screen lists all transactions for the logged-in user. Users can search, filter, and view details.
6. **Statistics:**
   - The Stats screen visualizes monthly and overall spending/income using charts, aggregating data from the database.
7. **Logout:**
   - Users can log out, which clears their session and returns to the login screen.

## Viewing the Database Manually
You can inspect the SQLite database directly from the terminal using the `sqlite3` command-line tool:

1. **Locate the Database File:**
   - By default, the database file is named `app.db` and is stored in the platform's database directory. For desktop (Linux), it is usually in your home directory under something like `~/.local/share/<app>/app.db` or as set by the app. If you run the app in debug mode, it may be in the project directory or a temp folder. Check your code for the exact path (see `DbService._initDB`).
   - If you can't find it, add a print statement in your code to print the database path at runtime.

2. **Open the Database:**
   ```bash
   sqlite3 path-to-app.db #database
   ```

3. **List Tables:**
   ```sql
   .tables
   ```

4. **View Data:**
   ```sql
   SELECT * FROM users;
   SELECT * FROM transactions;
   ```

5. **Exit:**
   ```sql
   .exit
   ```

> **Tip:** You may need to install `sqlite3` if it's not already available. On Ubuntu/Debian: `sudo apt install sqlite3`

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)

## All Files Working (Technical Overview)

- **lib/main.dart**: Initializes Flutter, sets up GetX controllers, and launches the app with routing and theming.
- **lib/controllers/auth_controller.dart**: GetX controller for managing user authentication state and session.
- **lib/controllers/transaction_controller.dart**: GetX controller for managing transaction list, filtering, and statistics logic.
- **lib/models/user_model.dart**: Defines the UserModel class for user data structure and serialization.
- **lib/models/transaction_model.dart**: Defines the TransactionModel class for transaction data structure and serialization.
- **lib/routes/app_routes.dart**: Centralizes all named routes and their corresponding screens for navigation using GetX.
- **lib/screens/login_screen.dart**: UI and logic for user login, including form validation and authentication calls.
- **lib/screens/register_screen.dart**: UI and logic for user registration, including form validation and database insertion.
- **lib/screens/home_screen.dart**: Displays the user's transactions, balance, and provides logout functionality.
- **lib/screens/add_transaction.dart**: Form UI for adding new transactions, with validation and submission to the database.
- **lib/screens/stats_screen.dart**: Visualizes transaction data using charts and statistics, grouped by month and category.
- **lib/screens/main_screen.dart**: Main navigation scaffold with bottom navigation bar and floating action button.
- **lib/services/auth_service.dart**: Handles user login and registration logic, interacting with the database.
- **lib/services/db_service.dart**: Manages all SQLite database operations, including table creation, CRUD, and stats queries.
- **lib/utils/app_theme.dart**: Defines the app's color palette, text styles, and theming using Google Fonts.
- **lib/widgets/transaction_tile.dart**: Custom widget for displaying individual transaction items in lists.

These files are modular and interact through GetX state management, SQLite database access, and Flutter's widget tree to deliver a robust, maintainable expense tracker application.

## Example User Flow (Technical Execution)

1. **App Launches**
   - The user opens the app. `main.dart` runs, initializing GetX controllers and the SQLite database via `db_service.dart`.
   - The app checks if the user is already authenticated. If not, it navigates to the login screen.

2. **User Registration**
   - The user taps "Register" and fills out the registration form (`register_screen.dart`).
   - On submission, `auth_service.dart` validates and inserts the new user into the `users` table using `db_service.dart`.
   - If successful, the user is redirected to the login screen.

3. **User Login**
   - The user enters credentials on the login screen (`login_screen.dart`).
   - `auth_service.dart` checks the credentials against the `users` table.
   - On success, `auth_controller.dart` stores the user session, and the app navigates to the main screen.

4. **Main Screen Navigation**
   - The user sees the main dashboard (`main_screen.dart`), which includes navigation to Home, Statistics, and Add Transaction.
   - The `transaction_controller.dart` loads all transactions for the logged-in user from the `transactions` table.

5. **Adding a Transaction**
   - The user taps the add button, opening `add_transaction.dart`.
   - The user fills out the form (amount, category, type, date) and submits.
   - The transaction is validated and inserted into the `transactions` table via `db_service.dart`.
   - The transaction list in `home_screen.dart` updates in real time using GetX reactivity.

6. **Viewing Transactions**
   - The Home screen (`home_screen.dart`) displays all transactions for the user, using `transaction_tile.dart` for each item.
   - The user can search, filter, or scroll through their transaction history.

7. **Viewing Statistics**
   - The user navigates to the Stats screen (`stats_screen.dart`).
   - The app queries the database for monthly and overall stats, then visualizes them with charts.

8. **Logging Out**
   - The user taps the logout button. `auth_controller.dart` clears the session, and the app returns to the login screen.

**Technical Notes:**
- All navigation is handled by GetX routes (`app_routes.dart`).
- State is managed reactively with GetX controllers, so UI updates automatically on data changes.
- All data is persisted locally in SQLite, and all CRUD operations are abstracted in `db_service.dart` and `auth_service.dart`.

This flow ensures a seamless, responsive, and robust user experience, with clear separation of concerns and maintainable code structure.
