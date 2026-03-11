import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'loginview.dart';


class patients extends StatefulWidget
{

  @override
  State<patients> createState() => _appointmentState();
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

class _appointmentState extends State<patients>

{ late Color cardColor;

@override
void initState()
{
  super.initState();
  cardColor = getColor(); // generate once
}
int _selectedindex=0;
@override
Widget build(BuildContext context)
{

  return
    Scaffold(


      body: SingleChildScrollView(child: Center( child: Padding(padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // Welcome Card
            Card(  color: getColor(),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Greeting
                    Row(
                      children: [

                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [

                            Text(
                              "Welcome 👋",
                              style: TextStyle
                                (
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),

                            Text(
                              "Patient name",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ), Text("reason : fever", style: TextStyle(fontSize: 14),)
                            
                            
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Appointment Info
                    Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child:
                      Row(
                        children: const
                        [

                          Icon(Icons.calendar_month, color: Colors.blue),

                          SizedBox(width: 8),

                          Text(
                            "Next Appointment: Feb 10, 3:00 PM",
                            style: TextStyle(fontSize: 14),
                          ),
                          

                        ],
                      ),

                    ),

                    const SizedBox(height: 20),

                    // Button
                    SizedBox(
                      width: double.infinity,


                    ),
                  ],
                ),
              ),
            ),

            Card(  color: getColor(),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Greeting
                    Row(
                      children: [

                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [

                            Text(
                              "Welcome 👋",
                              style: TextStyle
                                (
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),

                            Text(
                              "Patient name",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ), Text("reason : fever", style: TextStyle(fontSize: 14),)


                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Appointment Info
                    Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child:
                      Row(
                        children: const
                        [

                          Icon(Icons.calendar_month, color: Colors.blue),

                          SizedBox(width: 8),

                          Text(
                            "Next Appointment: Feb 10, 3:00 PM",
                            style: TextStyle(fontSize: 14),
                          ),


                        ],
                      ),

                    ),

                    const SizedBox(height: 20),

                    // Button
                    SizedBox(
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),


      ),
    )));









}




}