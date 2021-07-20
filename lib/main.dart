import 'package:ad_tv/firebaseFile.dart';
import 'package:ad_tv/providerAndFunctionFile.dart';
import 'package:ad_tv/startingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp()
      .whenComplete(() => print('Firebase Initialized.'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<FirebaseProvider>>.value(
            value: DatabaseServices().streamFirebaseProvider(),
            initialData: [
              FirebaseProvider(
                  title: 'Product1',
                  details: 'Product 1 details',
                  image: 'null',
                  price: '\$00',
                  id: '0'),
            ]),
        ChangeNotifierProvider<VideoAndProductDetails>(
          create: (_) => VideoAndProductDetails(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.light(),
        home: StartingScreen(),
      ),
    );
  }
}
