import 'package:flutter/material.dart';
import 'package:gfhfg/ViewModel/patientportal.dart';
import 'package:gfhfg/Views/chatpage.dart';
import '../ViewModel/appointmentViewModel.dart';
import '../ViewModel/drscheduleviewmodel.dart';
import 'Drprofile.dart';
import 'appointmnetscreenpatient.dart';
import 'schedulepateint.dart';
import 'navaigaitonbar.dart';
import 'package:gfhfg/Views/chatpage.dart';

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
   var doctorname;
   var specialization;
   List<Map<String, dynamic>> doctor = [];
   List<Map<String, dynamic>> doctorAppointments = [];
   final drschedule _viewModel1 = drschedule();

   final appointmentViewModel _viewModel = appointmentViewModel();
   final patientportal _viewModel2 = patientportal();





   Future<void> displayname() async
   {

     final name = await _viewModel.fetchPatientName();
     setState(()
     {
       patientname = name;
       loading = false;
     });

   }

   Future<void> displaydocotrs() async
   {


     var result= await _viewModel2.fetchFeaturedDoctors();

     setState(() {
       doctor = result;
       loading = false;

     });
   }



   @override
   void initState()
   {
   super.initState();

   displayname();
   displaydocotrs();
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
                  builder: (context, snapshot)
                  {
                    final appointment = snapshot.data;
                    print(snapshot.data);

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder
                        (
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

                        trailing: ElevatedButton.icon(
                          onPressed: appointment != null
                              ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewChatPage(
                                  otherUserId: appointment["doctorId"],
                                ),
                              ),
                            );
                          }
                              : null, // disables button if no appointment
                          icon: const Icon(Icons.chat),
                          label: const Text("Chat"),
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
                const Text("Featured Doctors", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: doctor.length,
                  itemBuilder: (context, index)
                  {


                    final doc = doctor[index];

                    return  Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => drprofile(doctorId: doc["id"],)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(height: 5),
                            Text(
                              doc["name"],
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              doc["specialization"],
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ), // Fixed the missing closing parenthesis and bracket here
                          ],
                        ),
                      ),
                    ) ;
                  },
                )
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