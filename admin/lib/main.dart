import 'package:admin/enums/internet_connectivity_status.dart';
import 'package:admin/screens/splash/splash_screen.dart';
import 'package:admin/services/auth.dart';
import 'package:admin/services/internet_monitoring.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "SF Pro Text",
        ),
        title: 'Ordery Waiter',
        home: Splash(
          auth: Auth(),
        ),
      ),
    );
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: ,
    // );
  }
}
