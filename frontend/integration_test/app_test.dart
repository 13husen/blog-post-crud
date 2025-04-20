import 'package:fe_simple/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fe_simple/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("App launch test", (tester) async {
    app.main(); // jalankan aplikasi
    await tester.pumpAndSettle();

    // Periksa apakah widget utama tampil
    expect(find.byType(HomePage), findsOneWidget);
  });
}