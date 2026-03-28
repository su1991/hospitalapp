import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:gfhfg/ViewModel/Signup.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:url_launcher/url_launcher.dart';


import 'loginview.dart';
import 'navaigaitonbar.dart';
import 'navigationdoctor.dart';
class googleviews extends StatefulWidget
{
  final VoidCallback onToggleTheme;
const googleviews({super.key, required this.onToggleTheme,});

@override
State<googleviews> createState() => _signupState();
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

class _signupState extends State<googleviews>
{


  void gotopage() async {
    if (genderType == null ||
        rooleType == null ||
        selectedDate == null ||
        phonenumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );


      String? addresserror= _viewModel.validateGoogleMapsLink(AddressController.text , rooleType as String);
      if(addresserror != null)
      {
        ScaffoldMessenger.of(context).showSnackBar
          (

          SnackBar(content:  Text(addresserror)),
        );
      }

      return;
    }

    setState(() {
      loading = true;
    });

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _viewModel.completeGoogleProfile(
        uid: user.uid,
        gender: genderType!.name,
        role: rooleType!.name,
        birthDate: selectedDate!,
        phone: phonenumberController.text.trim(),
        specialization: specialziationController.text.trim(),
        Hospital: HospitalController.text.trim(),
        address : AddressController.text.trim(),


      );
    }

    setState(() {
      loading = false;
    });

    // Navigate based on role
    if (rooleType == roleType.patient) {
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
  GenderType? genderType;
  roleType? rooleType;

  final phonenumberController=TextEditingController();
  final specialziationController=TextEditingController();
  final HospitalController = TextEditingController();
  final AddressController = TextEditingController();




  DateTime? selectedDate;
  bool loading=false;
  final SignupViewModel _viewModel = SignupViewModel();





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
              [
                TextField(decoration: _input("Enter phone number"),controller: phonenumberController,),
                SizedBox.fromSize(size: const Size(50, 20)),
                Column
                  (
                  children: <Widget>
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
                  TextField(decoration: _input("Enter specialization"),
                      controller: specialziationController),
                    if(rooleType == roleType.doctor)
                    TextField(decoration: _input("Enter Hospital"), controller: HospitalController,),
                    if(rooleType == roleType.doctor)
                      Row( children: [ Expanded(child:
                      TextField(decoration: _input("Enter Google map  Link address "),controller: AddressController,keyboardType: TextInputType.url),)
                        , IconButton(
                          icon: Icon(Icons.map),
                          onPressed: () async {
                            final url = AddressController.text.trim();
                            if(await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Invalid Maps link")),
                              );
                            }
                          },
                        ),
                      ],
                      ),


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
                ElevatedButton(onPressed: gotopage, child: const Text('go to the page'), style: ElevatedButton.styleFrom( backgroundColor: Colors.blue)),
                ),SizedBox(width: 20)

                ,


              ],
            ),
            ),
          ),
        ))




        ));}



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