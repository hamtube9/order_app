// import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:order_app/injection.dart';
import 'package:order_app/utils/hive_services.dart';
import 'package:order_app/views/category.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  GetIt.instance.get<LocalStorage>().ini();

  // runApp(DevicePreview(
  //   enabled: !kReleaseMode,
  //   builder: (context) => const MyApp(), // Wrap your app
  // ),);
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // locale: DevicePreview.locale(context),
      // builder:(context, myWidget){
      //   // myWidget = EasyLoading.init()(context,myWidget);
      //   myWidget = DevicePreview.appBuilder(context, myWidget);
      //   return myWidget;
      // },
      home: const CategoryScreen(),
    );
  }
}

