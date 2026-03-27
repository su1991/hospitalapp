import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gfhfg/ViewModel/doctorhome.dart';
import 'package:gfhfg/Views/navigationdoctor.dart';
import '../ViewModel/Drtimeviewmodel.dart';
import '../ViewModel/appointmentViewModel.dart';
import 'schedulepateint.dart';
import 'navaigaitonbar.dart';
import 'package:intl/intl.dart';


class Homedoc extends StatefulWidget
{
  final int _selectedindex=0;



  const Homedoc({super.key,  required this.onSchedulePressed}

      );
  final VoidCallback onSchedulePressed;

  @override
  State<Homedoc> createState()=> _HomedocState();
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
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

class _HomedocState extends State<Homedoc>
{
  var drname;
  var result;
  bool loading=true;
  List<Map<String, dynamic>> TodaydoctorAppointments = [];
  final appointmentViewModel _viewModel = appointmentViewModel();
  final doctorhome _viewModel1 = doctorhome();

  Future<void> displaytoday() async
  {

    final result = await _viewModel1.fetchtoday();

    setState(()
    {
      TodaydoctorAppointments = result;
      loading = false;
    });

  }

  Future<void> displayname() async
  {

    final name = await _viewModel.fetchPatientName();
    setState(()
    {
      drname = name;
      loading = false;
    });

  }


  @override
  void initState()
  {
    super.initState();
    displayname();
    displaytoday();
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

                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 10,
                ),

                const Text("Quick Actions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Expanded prevents the yellow/black overflow stripes
                    Expanded(child: _action("Add availability ", Icons.add, color: Colors.blue, onPressed: ()
                    {

                      opendialogavailability(context);

                    })),
                    Expanded(child: _action("View Schedule", Icons.schedule, color: Colors.orange, onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(title: Text("Schedule")),
                          body: Schedule(),
                        ),
                      ),
                    );})),

                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Today's Appointments",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                const SizedBox(height: 10),

                TodaydoctorAppointments.isEmpty
                    ? const Text("No appointments today")
                    : ListView.builder
                  (
                  shrinkWrap: true, // ✅ important inside scroll
                  physics: const NeverScrollableScrollPhysics(), // ✅ prevent nested scroll
                  itemCount: TodaydoctorAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = TodaydoctorAppointments[index];

                    // 🔹 Convert date
                    DateTime? date;
                    if (appointment["day"] is Timestamp) {
                      date = (appointment["day"] as Timestamp).toDate();
                    }

                    final formattedDate = date != null
                        ? DateFormat('EEE, MMM d').format(date)
                        : appointment["day"].toString();

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(appointment["patientName"]),
                        subtitle: Text(
                          "$formattedDate\n${appointment["startTime"]}:00 - ${appointment["endTime"]}:00",
                        ),

                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      )
            );



  }

  Widget _action(String text, IconData icon, {required Color color, required VoidCallback onPressed})
  {
    return GestureDetector
      (
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
   DateTime? selectedDate;


    showDialog<String>
      (
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
                DatePickerExample
                  (
                  selectedDate: selectedDate,
                  onDateChanged: (date)
                  {
                    setState(()
                    {
                      selectedDate = date;
                    });
                  },
                ),
            SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async
                  {

                    final Drtimeviewmodel viewModel = Drtimeviewmodel();

                    String? result = await viewModel.addAvailability(
                      day: selectedDate!,
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
