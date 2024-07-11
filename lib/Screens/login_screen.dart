import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mmfinfotech_machinetest/Screens/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/snackbar.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/hello.png",
                  height: 300,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Enter your email id",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await login();
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                    ),
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Forget Password",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          color: Colors.black,
                          height: 10,
                          thickness: 1,
                        )),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Or sign in with"),
                        ),
                        Expanded(
                            child: Divider(
                          color: Colors.black,
                          height: 10,
                          thickness: 1,
                        )),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      child: Image.asset("assets/google-logo.png"),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      child: Image.asset("assets/google-logo.png"),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      child: Image.asset("assets/google-logo.png"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an Account? ", style: TextStyle(
                        color: Colors.grey,fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ));
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.w500,
                              fontSize: 16,),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (email.text.isEmpty) {
      showCustomSnackBar(context,message:'Enter your email id');
    } else if (password.text.isEmpty) {
      showCustomSnackBar(context,message:'Enter your password');
    } else if (password.text.length < 6) {
      showCustomSnackBar(context,message:'Password should be of 6 digits');
    } else {
      var res = await http.post(Uri.parse("https://mmfinfotech.co/machine_test/api/userLogin"),body: {
        "email":email.text,
        "password":password.text
      });
      var json = jsonDecode(res.body);
      if(json["status"]) {
        SharedPreferences sh =await SharedPreferences.getInstance();
       await sh.setString("token", json["record"]["authtoken"]);
        showCustomSnackBar(context,message:"Successfully Logged in", isError: false);
        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                profileUrl: json["record"]["profileImg"],
                fullName: json["record"]["firstName"]+ " "+json["record"]["lastName"],
                email: json["record"]["email"],
              ),
            ));
        email.text = '';
        password.text = '';
      } else{
        email.text = '';
        password.text = '';
        showCustomSnackBar(context,message:"Invalid Credentials", isError: true);
      }
    }
  }

}
