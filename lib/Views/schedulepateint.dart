import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gfhfg/ViewModel/drscheduleviewmodel.dart';
import 'package:gfhfg/Views/chatpage.dart';
import 'dart:math' as math;
import 'loginview.dart';
import 'package:intl/intl.dart';



class Schedule extends StatefulWidget
{
  VoidCallback get onToggleTheme => onToggleTheme;


    @override
    State<Schedule> createState() => _appointmentState();
  }




  Color getColor()
{
  final random = math.Random();
  final colors =[
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.teal.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.cyan.shade100,

  ];

  return colors[random.nextInt(colors.length)];
}

  class _appointmentState extends State<Schedule>

  {


    final drschedule _viewModel = drschedule();
    bool loading = true;
    List<Map<String, dynamic>> doctorAppointments = [];



    Future<void> displaypatientname() async
    {
      final name = await _viewModel.loadDoctorAppointments();
      setState(()
      {doctorAppointments = name;

      loading = false;
      });

    }
void openchat()
{

}


    late Color cardColor;

  @override
  void initState()
  {
    super.initState();
    cardColor = getColor();
    displaypatientname();


    // generate once
  }
    int _selectedindex=0;

  VoidCallback? get onPressed => openchat;
  @override
  Widget build(BuildContext context)
  {
    return
         Scaffold(
           body:  Padding(padding: const EdgeInsets.all(16),
            child: Column
              (
              children: [
            Expanded( child :
            ListView.builder
              (
            itemCount: doctorAppointments.length,
                itemBuilder: (context, index)
                {
                  final appointment = doctorAppointments[index];
                  return Card(

                    color: getColor(),
                    child: ListTile(
                      title: Text(appointment["patientName"]),
                      subtitle:   Builder(
                        builder: (context) {
                          // 🔹 Parse the day
                          DateTime? date;
                          if (appointment["day"] is Timestamp)
                          {
                            date = (appointment["day"] as Timestamp).toDate();
                          } else if (appointment["day"] is String)
                          {
                            try {

                              date = DateTime.parse(appointment["day"]);
                            } catch (e)
                            {
                              date = null;
                            }
                          }

                          final formattedDate = date != null
                              ? DateFormat('EEE, MMM d').format(date)
                              : appointment["day"].toString();

                          return Text(

                                "$formattedDate | ${appointment["startTime"]}:00 - ${appointment["endTime"]}:00",
                          );
                        },


                      ),

                      trailing: ElevatedButton.icon(
                        onPressed: ()
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute
                              (
                              builder: (context) => ViewChatPage(
                                otherUserId: appointment["patientId"], // ✅ Now works
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat),
                        label: const Text("Chat"),
                      ),
                    ),
                  );;
                },
            )
            )] ,
            ),


            ),
          );

  }




}