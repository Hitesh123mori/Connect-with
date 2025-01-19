import 'package:connect_with/providers/buckets_provider.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:connect_with/screens/onboard_screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase/project_1.dart';

late Size mq ;
void main()async{

  WidgetsFlutterBinding.ensureInitialized() ;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((value){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky) ;
  });
  await _intializeFirebase() ;
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>AppUserProvider()),
        ChangeNotifierProvider(create: (context)=>OrganizationProvider()),
        ChangeNotifierProvider(create: (context)=>BucketsProvider()),

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
    return Consumer2<AppUserProvider,OrganizationProvider>(builder: (context,appUserProvider,organizationProvider,child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(appUser: appUserProvider, orgizationProvider: organizationProvider,) ,
      ) ;
    }) ;
  }
}

_intializeFirebase() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(
        name: 'connect_with_1',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBKCwjTBv6gzAf3gMXXu19mf7D0D-rx6Yc',
          appId: '1:643798867875:android:237a2bd56d95a004bb0416',
          messagingSenderId: '643798867875',
          projectId: 'connectwith-60f8a',
          storageBucket: 'connectwith-60f8a.firebasestorage.app',
        ));
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(
        name: 'connect_with_2',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyCDoxpe3BSbOqy-aA4I2iLmuPS2j5J3HHU',
          appId: '1:1011888016997:android:77bf8f56888fb1a0ac008c',
          messagingSenderId: '1011888016997',
          projectId: 'mori-hitesh',
          storageBucket: 'mori-hitesh.appspot.com',
        ));
  }

}
