import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/screens/onboard_screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' ;
import 'package:provider/provider.dart';
import 'firebase_options.dart';

late Size mq ;
void main()async{

  WidgetsFlutterBinding.ensureInitialized() ;
  await _intializeFirebase() ;
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>AppUserProvider()),
      ],
      child: MyApp()));

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserProvider>(builder: (context,appUserProvider,child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(appUser: appUserProvider,) ,
      ) ;
    }) ;
  }
}

_intializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}