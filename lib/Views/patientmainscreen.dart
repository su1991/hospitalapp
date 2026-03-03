import 'package:flutter/material.dart';
import '../ViewModel/appointmentViewModel.dart';
import 'appointmnetscreenpatient.dart';
import 'schedulepateint.dart';
import 'navaigaitonbar.dart';

class HomePage extends StatefulWidget
{
  final int _selectedindex = 0;

  const HomePage({super.key, required this.onSchedulePressed});

  final VoidCallback onSchedulePressed;

  @override
  State<HomePage> createState() => _HomePageState();

}



   @override
   class _HomePageState extends State<HomePage>
   {
   Map<String, dynamic>? nextAppointment;
   bool loading = true;
   var patientname;

   final appointmentViewModel _viewModel = appointmentViewModel();



   Future<void> displayname() async
   {

     final name = await _viewModel.fetchPatientName();
     setState(()
     {
       patientname = name;
       loading = false;
     });

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
                    Text
                      (
                      "Hello ${patientname }👋",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    CircleAvatar
                      (
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.person),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                StreamBuilder<Map<String, dynamic>?>
                  (
                  stream: _viewModel.loadNextAppointment(),
                  builder: (context, snapshot) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.calendar_month, color: Colors.blue),
                        title: const Text("Next Appointment"),
                        subtitle: snapshot.connectionState == ConnectionState.waiting
                            ? const Text("Loading...")
                            : !snapshot.hasData || snapshot.data == null
                            ? const Text("No upcoming appointments")
                            : Text(
                          "${snapshot.data!["doctorName"]}\n"
                              "${snapshot.data!["day"]} | "
                              "${snapshot.data!["startTime"]}:00 - "
                              "${snapshot.data!["endTime"]}:00",
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton
                    (
                    onPressed:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Appointments()),
                      );

                    },
                    child: const Text("Book Appointment"),
                  ),
                ),
                const SizedBox(height: 30),
                const Text("Services", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children:
                  [
                    // Expanded prevents the yellow/black overflow stripes
                    Expanded(child: _action("Doctors", Icons.people, color: Colors.blue)),
                    Expanded(child: _action("Chat", Icons.chat, color: Colors.orange)),
                    Expanded(child: _action("Meds", Icons.medical_services, color: Colors.green)),
                    Expanded(child: _action("Settings", Icons.settings, color: Colors.red)),
                  ],
                ),
              ],


            ),
          ),

        ),

      ),


    );
  }

  Widget _action(String text, IconData icon, {required Color color})
  {
    return Column
      (
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
    );
  }




}