import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ViewModel/Profiles.dart';

class drprofile extends StatefulWidget

{
   final String doctorId;
   final bool isEditable;
  @override
  State<drprofile> createState() => _drprofile();
  const drprofile({super.key, required this.doctorId,this.isEditable=false});


}




  class _drprofile extends State<drprofile>
{
  final profiles _viewmodel= profiles();
  Map<String, dynamic>? doctorData;
  late final String name ;

  late Timestamp ts = doctorData?["birthdate"];
  late DateTime birthdate = ts.toDate();

  late bool isEditable;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late final isOwner = currentUserId == widget.doctorId;





  Future<void> displaydata() async
  {
    final data = await _viewmodel.loadDoctorById(widget.doctorId);

    if (data != null)
    {
      setState(() {
        doctorData = data;
      });
    }
  }

  Future<void> editphoneDialog() async
  {

    TextEditingController controller = TextEditingController(
      text: doctorData?["phonenumber"],
    );

    final newPhone = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Phone Number"),

          content: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: const InputDecoration(
              labelText: "Enter new phone",
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text("Save"),
            ),

          ],
        );
      },
    );

    if (newPhone == null) return;

    if (!RegExp(r'^\d{10}$').hasMatch(newPhone)) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Phone must be 10 digits"),
        ),
      );

      return;
    }

    await _viewmodel.modifyphone(newPhone);

    await displaydata();
  }


  Future<void> editnameDialog() async
  {

    TextEditingController controller = TextEditingController(
      text: doctorData?["name"],
    );

    final newPhone = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit name"),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Enter new name",
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text("Save"),
            ),

          ],
        );
      },
    );

    if (newPhone == null) return;



    await _viewmodel.modifyname(newPhone);

    await displaydata();
  }


  @override
  void initState()
  {
    super.initState();
     displaydata();
  }
  @override
  Widget build(BuildContext context)
  {
    return
    Scaffold
      ( appBar: AppBar(),
        body: SingleChildScrollView(child:  Padding(padding: const EdgeInsets.all(16),
          child: Column
            (
            children:
              [Row( children: [ Text("Name :  "),  Text( doctorData?["name"] ?? "Loading..." ), Text ("      "),if(isOwner)  ElevatedButton.icon(onPressed: editnameDialog, label: Icon(Icons.edit))],),
                SizedBox(height: 20),
                Row (children: [ Text("Phone : "), Text(doctorData?["phonenumber"] ?? "Loading..."), Text ("      "), if(isOwner) ElevatedButton.icon(onPressed: editphoneDialog, label: Icon(Icons.edit))]),
                SizedBox(height: 20),
                Row ( children: [ Text("Email : "), Text(doctorData?["email"] ?? "Loading..."), Text ("      ")]),
                SizedBox(height: 20),
                Row ( children: [Text("Gender Type :"), Text(doctorData?["genderType"] ?? "Loading..."), Text ("      ")]),
                SizedBox(height: 20),

                Row(children: [Text("Birth Date :"),Text("${birthdate.day}/${birthdate.month}/${birthdate.year}")],),
                SizedBox(height: 20),
                Row (children: [Text ("specialization :"),Text(doctorData?["specialization"] ?? "Loading..."), Text("  ")]),
                SizedBox(height: 20),
                Row (children: [Text ("Hospital :"),Text(doctorData?["Hospital"] ?? "Loading..."), Text("  ")]),
                SizedBox(height: 20),
                Row (children: [Text ("address :"),Text(doctorData?["address"] ?? "Loading..."), Text("  ")])


              ],
          ),
        )
        )
    );














}

}