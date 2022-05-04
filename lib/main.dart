import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:supplier/helper/ui/app_color.dart';
import 'package:supplier/helper/ui/app_dialog.dart';
import 'package:supplier/helper/utility/app_shared_prefs.dart';
import 'package:supplier/provider/user_info_provider.dart';
import 'package:supplier/routes/app_routes.dart';

void main() {
  runApp(MultiProvider( providers: [
    ChangeNotifierProvider(create: (context) => UserInfoProvider(),)
  ],child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRoute.generateRoute,
      initialRoute: AppRoute.rMain,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: AppColor.mainTheme,
          primaryTextTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          )
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
        _requestPermission(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(color: Theme.of(context).primaryColor,child:  Center(child: Text("SupplierApps", style: GoogleFonts.mochiyPopOne(fontSize: 35,color: Colors.white),),));
  }
}

Future<void> _requestPermission(BuildContext context) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.camera,
  ].request();
    _toPage(context);


}

///Navigate to other page
Future<void> _toPage(BuildContext context) async{
  AppSharedPrefs.isLoggedIn().then((login) {
    if(login){
      context.read<UserInfoProvider>().setUserInfo();
      Future.delayed(const Duration(milliseconds: 200), () async {
        if(context.read<UserInfoProvider>().userRoleId == 1) {
          Navigator.pushReplacementNamed(context, AppRoute.rHome);
        }else{
          Navigator.pushReplacementNamed(context, AppRoute.rNav);
        }
      });
    }else{
      Navigator.pushReplacementNamed(context, AppRoute.rLogin);
    }
  });
}
