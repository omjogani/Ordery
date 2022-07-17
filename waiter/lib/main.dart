import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:waiter/enums/internet_connectivity_status.dart';
import 'package:waiter/providers/order_provider.dart';
import 'package:waiter/screens/splash/splash_screen.dart';
import 'package:waiter/services/auth.dart';
import 'package:waiter/services/internet_monitoring.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );

    return StreamProvider<InternetConnectivityStatus?>(
      initialData: null,
      create: (context) =>
          InternetMonitorService().internetConnectionStatusController.stream,
      child: ChangeNotifierProvider(
        create: (_) => OrderProvider(),
        child: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: "SF Pro Text",
              ),
              title: 'Ordery Waiter',
              home: Splash(
                auth: Auth(),
              ),
            );
          },
        ),
      ),
    );
  }
}
