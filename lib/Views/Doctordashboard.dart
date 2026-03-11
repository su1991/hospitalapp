import 'package:flutter/material.dart';
import '../ViewModel/Drtimeviewmodel.dart';
import '../ViewModel/appointmentViewModel.dart';
import 'schedulepateint.dart';
import 'navaigaitonbar.dart';


class Homedoc extends StatefulWidget
{
  final int _selectedindex=0;



  const Homedoc({super.key,  required this.onSchedulePressed}

      );
  final VoidCallback onSchedulePressed;

  @override
  State<Homedoc> createState()=> _HomedocState();
}

class _HomedocState extends State<Homedoc>
{
  var drname;
  bool loading=true;
  final appointmentViewModel _viewModel = appointmentViewModel();

  Future<void> displayname() async
  {

    final name = await _viewModel.fetchPatientName();
    setState(()
    {
      drname = name;
      loading = false;
    })
    ;

  }

  @override
  void initState()
  {
    super.initState();

    displayname();
  }

  @override
  Widget build(BuildContext context)
  {

    return Scaffold
      (



      body: SafeArea
        (
        child: SingleChildScrollView
          (
          child: Padding
            (
            padding: const EdgeInsets.all(16),
            child: Column
              (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hello Dr ${drname } 👋",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.person),
                    ),
                  ],
                ),
                Text("Today appointments",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: const ListTile
                    (
                    leading: Icon(Icons.calendar_month, color: Colors.blue),
                    title: Text("Next Appointment"),
                    subtitle: Row( children: [Text("Feb 10, 3:00 PM"),
                      SizedBox(width: 10),
                      
                      Text("Status:")

                        ]


                    )



                  ),



                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,

                ),
                const SizedBox(height: 30),
                const Text("Quick Actions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Expanded prevents the yellow/black overflow stripes
                    Expanded(child: _action("Add availability ", Icons.add, color: Colors.blue, onPressed: ()
                    {

                      opendialogavailability(context);

                    })),
                    Expanded(child: _action("View Schedule", Icons.schedule, color: Colors.orange, onPressed: () {  })),
                    Expanded(child: _action("Message", Icons.message, color: Colors.green, onPressed: () {  })),
                    Expanded(child: _action("patient records", Icons.receipt, color: Colors.red, onPressed: () {  })),
                  ],
                ),
              ],


            ),
          ),

        ),

      ),


    );
  }

  Widget _action(String text, IconData icon, {required Color color, required VoidCallback onPressed})
  {
    return GestureDetector(
        onTap: onPressed,
       child : Column(
      children: [
        Container(
          height: 60, width: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    ) );
  }

  void opendialogavailability(BuildContext context)
  {
   final StarttimeController=TextEditingController();
   final EndtimeController=TextEditingController();
   final DayController=TextEditingController();


    showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog
          (
        child: Padding
          (
          padding: const EdgeInsets.all(8.0),
          child: Column
            (
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>
              [


            Text("Start Time:"),
            TextField(
              decoration: InputDecoration(hintText: "Enter start time"), controller: StarttimeController,
            ),
            SizedBox(height: 10),
            Text("End Time:"),
            TextField(
              decoration: InputDecoration(hintText: "Enter end time"), controller: EndtimeController,
            ),

            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(hintText: "Enter day"), controller: DayController,
            ),
            SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {

                    final Drtimeviewmodel viewModel = Drtimeviewmodel();

                    String? result = await viewModel.addAvailability(
                      day: DayController.text.trim(),
                      startTime: StarttimeController.text.trim(),
                      endTime: EndtimeController.text.trim(),
                    );

                    if (result == null) {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Availability Added")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result)),
                      );
                    }
                  },
                  child: const Text("Save"),
                )
                ,

          ],
        ),
      ),
    ),
    );


  }




}
