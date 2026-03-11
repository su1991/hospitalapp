import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfhfg/ViewModel/login.dart';
import 'package:gfhfg/Views/navaigaitonbar.dart';
import 'package:gfhfg/Views/patientmainscreen.dart';
import 'package:gfhfg/Views/signupview.dart';
import 'package:gfhfg/Views/navigationdoctor.dart';

class login extends StatefulWidget
{
  final VoidCallback onToggleTheme;

  const login({super.key, required this.onToggleTheme,});

  @override
  State<login> createState() => _loginState();
}



class _loginState extends State<login>
{  bool loading=false;
  VoidCallback? get onPressed => handleslogin;
   final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final LoginViewModel _viewModel = LoginViewModel();




  void handleslogin() async
  {
    setState(()
    {
      loading=true;
    });
    String? result = await _viewModel.login
      (
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(()
    {
      loading = false;
    });

    // If success

    if (result == "doctor")
    {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              navigationdr(onToggleTheme: widget.onToggleTheme),
        ),
            (route) => false,
      );
    }
    else if (result == "patient") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              navigation(onToggleTheme: widget.onToggleTheme),
        ),
            (route) => false,
      );
    }


    // If error
      else
      {
        ScaffoldMessenger.of(context).showSnackBar
          (
          SnackBar(content: Text(result!)),
        );
      }

  }
  @override
  Widget build(BuildContext context)
  {
    return  Scaffold
          (
          appBar: AppBar
            (
            title: const Text(""),
          ),
          body: SingleChildScrollView(child: Center( child: Column
            (
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              TextField(decoration: _input("Enter email"), controller: emailController,
              ), SizedBox(height:40),
              TextField(decoration: _input("Enter password"), controller: passwordController,
              ),SizedBox(height:40),
              ElevatedButton(onPressed: onPressed, child: const Text('login')),
              ElevatedButton(onPressed: ()
              {
                Navigator.push
                  (
                  context,
                  MaterialPageRoute(builder: (context) => signup(onToggleTheme: widget.onToggleTheme)
                ),
                );}, child: const Text('Dont have an account ? '))
            ],
          ),

          )
          ),
          );
  }
  InputDecoration _input(String hint)
  {
    return InputDecoration
      (
      hintText: hint,
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

}