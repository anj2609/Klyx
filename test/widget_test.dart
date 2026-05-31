import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/features/auth/auth_provider.dart';
import 'package:klyx/features/auth/auth_model.dart';
import 'package:klyx/features/auth/auth_notifier.dart';
import 'package:klyx/main.dart';

class FakeAuthNotifier extends AuthNotifier {
  @override
  FutureOr<UserProfile?> build() async {
    return null; // Simulate not logged in
  }
}

void main() {
  testWidgets('App smoke test - renders login screen initially', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => FakeAuthNotifier()),
        ],
        child: const KlyxApp(),
      ),
    );

    await tester.pumpAndSettle();

    // The login button should be present on the login screen
    expect(find.text('INITIALIZE PROFILE'), findsOneWidget);
  });
}
