import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:gfhfg/ViewModel/Signup.dart';
import 'package:gfhfg/Views/googleviews.dart';
import 'package:sign_in_button/sign_in_button.dart';


import 'loginview.dart';
import 'navaigaitonbar.dart';
import 'navigationdoctor.dart';
class signup extends StatefulWidget
{ final VoidCallback onToggleTheme;
  const signup({super.key, required this.onToggleTheme,});

  @override
  State<signup> createState() => _signupState();
}

class DatePickerExample extends StatefulWidget
{ final DateTime? selectedDate;
  final Function(DateTime) onDateChanged;
  const DatePickerExample({super.key,required this.selectedDate,
    required this.onDateChanged,});

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample>
{

  Future<void> _selectDate() async
  {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null)
    {
      widget.onDateChanged(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context)
  {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        Text(
          widget.selectedDate != null
              ? '${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}'
              : 'No date selected',
        ),

        OutlinedButton(
          onPressed: _selectDate,
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}


enum GenderType { male, female }
enum roleType { patient, doctor }

class _signupState extends State<signup>
{


GenderType? genderType;
roleType? rooleType;
final nameController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final phonenumberController=TextEditingController();
  final specializationController=TextEditingController();
  final HospitalController = TextEditingController();
  final AddressController = TextEditingController();


  VoidCallback? get onPressed => handlesignup;
  dynamic get onPressed1 =>googlesignup;
  DateTime? selectedDate;
  bool loading=false;
  final SignupViewModel _viewModel = SignupViewModel();
  void handlesignup() async
  {

    String? emailError = _viewModel.validateemail(emailController.text,);

  if (emailError != null)
  {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(emailError)),
    );
    return; // Stop signup
  }

  String? passworderror=_viewModel.validatepassword(passwordController.text);
  if (passworderror != null)
  {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(passworderror)),
    );
    return; // Stop signup
  }

  String? phoneerror=_viewModel.validatephone(phonenumberController.text);
  if (phoneerror != null)
  {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(phoneerror)),
    );
    return; // Stop signup
  }


    setState(()
    {
      loading=true;
    });
    String? result = await _viewModel.signup
      (birthdate: selectedDate! ,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      phonenumber: phonenumberController.text.trim(),
      specialization: specializationController.text.trim(),
      Hospital: HospitalController.text.trim(),
      address : AddressController.text.trim(),
      genderType: genderType!.name,
      rooleType: rooleType!.name,
      selectedDate: selectedDate!,
    );

    setState(()
    {
      loading = false;
    });

    // If success
    if (result == null)
    {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful")),
      );

      // Later: Navigate to Home screen

    }
    // If error
    else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }

  }

void googlesignup() async
{
  User? user = await _viewModel.signInWithGoogle();

  if (user == null) return;

  final doc = await FirebaseFirestore.instance
      .collection("User")
      .doc(user.uid)
      .get();

  // If role does NOT exist → go to googleviews
  if (!doc.data()!.containsKey("rooleType"))
  {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            googleviews(onToggleTheme: widget.onToggleTheme),
      ),
    );
  }
  else {
    String role = doc["rooleType"];

    if (role == "patient") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              navigation(onToggleTheme: widget.onToggleTheme),
        ),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              navigationdr(onToggleTheme: widget.onToggleTheme),
        ),
            (route) => false,
      );
    }
  }
}


  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
  appBar: AppBar
    (
    title: const Text(""),


  ),
  body: SingleChildScrollView(child: Center( child: Padding(
    padding: const EdgeInsets.all(16),

    child: Card(
      elevation: 6,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20), child: Column
    (
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [ TextField(decoration: _input("Enter full name"), controller: nameController),
        SizedBox(height:10),
      TextField(decoration: _input("Enter email"),controller: emailController,),
         SizedBox(height:10),
        TextField(decoration: _input("password"),controller: passwordController,)
        ,SizedBox(height:10),
        TextField(decoration: _input("Enter phone number"),controller: phonenumberController,),
        SizedBox.fromSize(size: const Size(10, 20)),
        Column
         (children: <Widget>
        [
Text('Choose Gender please',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

      ListTile
       (

      title: Text('male'),
      leading: Radio<GenderType>(value: GenderType.male,  groupValue: genderType,onChanged: (value)
      {
        setState(()
        {
          genderType = value;
        });
      },),
      ),
    ListTile
      (
    title: Text('female'),
  leading: Radio<GenderType>(value: GenderType.female,groupValue: genderType,onChanged: (value){

    setState(()
    {
      genderType = value;
    });
  }),
    ),
            Text(("Pick the Role"),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            ListTile
              (

              title: Text('Patient'),
              leading: Radio<roleType>(value: roleType.patient, groupValue: rooleType,onChanged: (value)
              {
                setState(()
                {
                  rooleType = value;
                });
              }),
            ),


            ListTile
              (
              title: Text('Doctor'),
              leading: Radio<roleType>(value: roleType.doctor,groupValue: rooleType,onChanged: (value){

                setState(()
                {
                  rooleType = value;
                });
              },),
            ),
            SizedBox.fromSize(size: const Size(50, 20)),

          if(rooleType == roleType.doctor)
                   TextField(decoration: _input("Enter specialization"), controller: specializationController),
          if(rooleType == roleType.doctor)
                   TextField(decoration: _input("Enter Hospital"), controller: HospitalController,),
          if(rooleType == roleType.doctor)
                   TextField(decoration: _input("Enter Address"),controller: AddressController,),

          Text("Pick birth of date",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            DatePickerExample
              (
              selectedDate: selectedDate,
              onDateChanged: (date)
              {
                setState(() {
                  selectedDate = date;
                });
              },
            ),

          ],

  )
     ,   SizedBox(width: 20)
, SizedBox(width: 20),
SizedBox(width: double.infinity, child:
     ElevatedButton(onPressed: onPressed, child: const Text('signup'), style: ElevatedButton.styleFrom( backgroundColor: Colors.blue)),
),SizedBox(width: 20)
        
        , 
  SignInButton(Buttons.google, onPressed: onPressed1)
  ,    ElevatedButton(onPressed: () {

    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => login(onToggleTheme: widget.onToggleTheme)),
        );

      }, child: const Text('Already have an account ? '))

      ],
    ),
  ),
  ),
))




  ));


  }



  InputDecoration _input(String hint)
  {
    return InputDecoration(
      hintText: hint,

      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}