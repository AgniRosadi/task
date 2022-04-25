import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supplier/custom-helper/app_util.dart';
import '/helper/constant/shared_prefs_const.dart';
import '/helper/constant/app_settings.dart';
import '/helper/ui/app_dialog.dart';
import '/helper/utility/app_shared_prefs.dart';
import '/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => _LoginPageProvider()),
    ], child: const Scaffold(body: _LoginPageContent()));
  }
}

class _LoginPageContent extends StatefulWidget {
  const _LoginPageContent({Key? key}) : super(key: key);

  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<_LoginPageContent> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _usernameController.text = await AppSharedPrefs.getString("username");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Image(
            image: const AssetImage(
                AppSettings.assetsImagesDirApp + "user_login.png"),
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width / 3,
          ),
          Text("LOGIN",
              style: GoogleFonts.mochiyPopOne(
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: AppUtil.getSecondaryColor(),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              hintText: "Username",
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            ),
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) {
                              if (_usernameController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                context
                                    .read<_LoginPageProvider>()
                                    .setSubmitButtonStatus(false);
                              } else {
                                context
                                    .read<_LoginPageProvider>()
                                    .setSubmitButtonStatus(true);
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Usernamenya diisi dong.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _passwordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                hintText: "Password",
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    context
                                        .read<_LoginPageProvider>()
                                        .setInputTypePassword();
                                  },
                                  icon: Icon(
                                    context
                                            .watch<_LoginPageProvider>()
                                            .typePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: context
                                            .watch<_LoginPageProvider>()
                                            .typePassword
                                        ? Colors.grey
                                        : Theme.of(context).primaryColor,
                                    size: 21,
                                  ),
                                  color: Colors.grey,
                                )),
                            obscureText: context
                                .watch<_LoginPageProvider>()
                                .typePassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.send,
                            onFieldSubmitted: (_) {
                              submitLogin();
                            },
                            onChanged: (_) {
                              if (_usernameController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                context
                                    .read<_LoginPageProvider>()
                                    .setSubmitButtonStatus(false);
                              } else {
                                context
                                    .read<_LoginPageProvider>()
                                    .setSubmitButtonStatus(true);
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Passwordnya jangan lupa.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                bool value =
                                    context.read<_LoginPageProvider>().checked;
                                context
                                    .read<_LoginPageProvider>()
                                    .setCheckBoxValue(!value);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    shape: const CircleBorder(),
                                    checkColor: Colors.white,
                                    value: context
                                        .watch<_LoginPageProvider>()
                                        .checked,
                                    onChanged: (bool? value) {
                                      context
                                          .read<_LoginPageProvider>()
                                          .setCheckBoxValue(value ?? false);
                                    },
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Text(
                                      "Simpan username.",
                                      style: TextStyle(
                                          fontSize: 16, fontFamily: "Rubrik"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Consumer<_LoginPageProvider>(
                    builder: (context, value, child) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 6),
                                backgroundColor: value.enableSubmitButton
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey),
                            onPressed: value.enableSubmitButton
                                ? () async {
                                    submitLogin();
                                  }
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("LOGIN",
                                  style: GoogleFonts.mochiyPopOne(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            )),
                      );
                    },
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: OutlinedButton(
                  //       style: OutlinedButton.styleFrom(
                  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  //           padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 6),
                  //           backgroundColor: Theme.of(context).primaryColor ),
                  //       onPressed: () {
                  //         Navigator.pushNamed(context, CsiRoute.rRegister);
                  //       },
                  //       child:  Padding(
                  //         padding: const EdgeInsets.all(10.0),
                  //         child: Text("DAFTAR", style: GoogleFonts.mochiyPopOne(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold)),
                  //       )),
                  // ),
                ],
              ),
            ),
          )),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            width: double.infinity,
            color: AppUtil.getSecondaryColor(),
            child: Align(
              alignment: Alignment.center,
              child: RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      children: [
                    const TextSpan(text: "Copyright @ 2022 "),
                    TextSpan(
                        text: "Aro Dev",
                        style: TextStyle(color: Theme.of(context).primaryColor))
                  ])),
            ),
          ),
        ],
      ),
    );
  }

  void submitLogin() {
    //todo sementara
    if (_formKey.currentState!.validate()) {
      _apiLogin(
          context,
          jsonEncode({
            'username': _usernameController.text,
            'password': _passwordController.text,
          }));
    }
  }

  Future<void> _apiLogin(BuildContext context, dynamic params) async {
    print(params);
    AppDialogs.showProgressDialog(
        context: context,
        title: "Validasi",
        message: "Sedang memvalidasi akun Anda",
        isDismissible: false);
    try {
      Response response =
          await Dio().post('https://duplicode.my.id/tugas/login.php',
              data: params,
              options: Options(headers: {
                HttpHeaders.contentTypeHeader: "application/json",
              }));
      var jsonResponse = await response.data;
      var data = jsonResponse;
      // if (data['result'] != null) {
      Future.delayed(const Duration(milliseconds: 100), () async {
        AppDialogs.showProgressDialog(
            context: context,
            title: "Hampir selesai",
            message: "Sedang menyiapkan aplikasi untuk kenyamanan Anda...",
            isDismissible: false);
      });
      print(response.data);
      await AppSharedPrefs.setLogin(true);
      await AppSharedPrefs.setToken(data['token']);
      await AppSharedPrefs.setString(SharedPrefsConst.userName, data['nmrole']);
      await AppSharedPrefs.setInt(
          SharedPrefsConst.userRoleId, int.parse(data['idrole']));
      if (context.read<_LoginPageProvider>().checked) {
        await AppSharedPrefs.setString("username", _usernameController.text);
      } else {
        await AppSharedPrefs.setString("username", "");
      }
      Future.delayed(const Duration(milliseconds: 2500), () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Selamat datang'),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).primaryColor,
        ));
        AppDialogs.hideProgressDialog();
        Navigator.pushReplacementNamed(context, AppRoute.rMain);
      });
      // }
      // else {
      //   await CsiDialogs.resultDialog(
      //       context: context,
      //       title: "Error",
      //       message:
      //           "Login gagal silahkan cek kembali password dan username anda",
      //       dialogType: CsiDialogType.error);
      //   CsiDialogs.hideProgressDialog();
      // }
    } catch (e) {
      AppDialogs.resultDialog(
          context: context,
          title: "Error",
          message: "Something went wrong. (syserr:" + e.toString() + ")",
          dialogType: AppDialogType.error);
    }
  }
}

///Provider
class _LoginPageProvider with ChangeNotifier {
  bool enableSubmitButton = false;
  bool typePassword = true;
  bool checked = true;

  setInputTypePassword() {
    typePassword = !typePassword;
    notifyListeners();
  }

  setSubmitButtonStatus(bool enable) {
    enableSubmitButton = enable;
    notifyListeners();
  }

  setCheckBoxValue(bool checked) {
    this.checked = checked;
    notifyListeners();
  }
}

/// API
