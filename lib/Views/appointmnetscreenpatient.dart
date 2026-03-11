import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../ViewModel/appointmentViewModel.dart';

class Appointments extends StatefulWidget
{
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
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

    if (pickedDate != null) {
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
              ? '${widget.selectedDate!.day}/${widget.selectedDate!
              .month}/${widget.selectedDate!.year}'
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

class _AppointmentsState extends State<Appointments>
{

   final appointmentViewModel _viewModel = appointmentViewModel();
   DateTime? selectedDate;


  // List to store doctors
  List<Map<String, dynamic>> doctors = [];
  List <Map <String,dynamic>> slots=[];



   Future<void> loadDoctors() async
   {
     final result = await _viewModel.fetchDoctors();

     setState(()
     {
       doctors = result;
       loading = false;
     });
   }



   Future<void> saveappointments() async
   {
     if (selectedDoctorId == null || selectedSlotId == null ) return;

 final save = await _viewModel.saveAppointments
   (
       doctorId: selectedDoctorId!,
       patientId: FirebaseAuth.instance.currentUser!.uid,
       slotId: selectedSlotId!,

     );

   }


   Future <void> loadslots(String doctorId) async
   {

     if (selectedDoctorId == null) return;
     else {
       print("Selected Doctor ID: $selectedDoctorId");
     }

     final slot = await _viewModel.fetchDoctorSlots(doctorId: doctorId,);
     print("Fetched slots: $slot");

     setState(() {
       slots = slot;
       loading = false;
     });

   }
  // Selected doctor id
  String? selectedDoctorId;
   String? selectedSlotId;
   String? day;
   String? endTime;
   String? startTime;
   String? selectedCancelSlotId;

   bool loading = false;

  @override
  void initState()
  {
    super.initState();
    loadDoctors();

  }
  @override
  Widget build(BuildContext context)
  {

    return Scaffold
      (


      appBar: AppBar
        (

        title: const Text("Book Appointment"),
        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding
        (
        padding: const EdgeInsets.all(16),

         child: SingleChildScrollView ( child :Column
          (
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text
              (
              "Select Doctor",
              style: TextStyle
                (
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Dropdown
            DropdownButtonFormField<String>
              (

              value: selectedDoctorId,

              hint: const Text("Choose a doctor"),

              items: doctors.map((doctor)
              {
                return DropdownMenuItem<String>
                  (
                  value: doctor["id"],
                  child: Text(doctor["name"]),
                );
              }).toList(),

              onChanged: (value)
              async {
                setState(()
                {
                  selectedDoctorId = value;
                  selectedSlotId=null;
                  loading = true;
                });
                await loadslots(value!);
              },

              decoration: InputDecoration
                (
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder
                  (
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),



            const SizedBox(height: 30),

        DropdownButtonFormField<String>
          (
          value: selectedSlotId,

          hint: const Text("Choose a slot"),

          items: slots.map((slot)
          { final bool isbooked= slot["isBooked"]== true;

            return DropdownMenuItem<String>(
              value: slot["id"] , // disable selection
              enabled: !isbooked,                  // prevents tapping

              child: Text(
                  "${slot["day"]} | ${slot["startTime"]}:00 - ${slot["endTime"]}:00"
                      "${isbooked ? " (Booked)" : ""}",
                style: TextStyle(
                  color: isbooked ? Colors.grey : Colors.black,
              ),

            ));
          }).toList(),

          onChanged: (value)
          {
            setState(()
            {
              selectedSlotId = value;
            });
          },

          decoration: InputDecoration
            (
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        )
        , SizedBox(height: 30,),




            // 🔹 Continue button
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton
                (
                onPressed: (
                    selectedDoctorId == null
                    ||
                    selectedSlotId == null
                    )
                    ? null
                    : () async
                {
                  try {
                  await saveappointments();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Appointment booked successfully!"),
                    ),
                  );

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $e"),
                    ),
                  );
                }
                },



                child: Text("Book Appointment"),

              ),
            ),

            SizedBox(height: 40,),
          StreamBuilder<List<Map<String, dynamic>>>
            (
              stream: _viewModel.fetchSavedAppointments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final savedslots = snapshot.data!;


                return DropdownButtonFormField<String>
                  (
                  value: selectedCancelSlotId,
                  hint: const Text("Cancel a slot"),
                  items: savedslots.map((slot) {
                    return DropdownMenuItem<String>(
                      value: slot["appointmentId"],
                      child: Text(
                          "${slot["day"]} | ${slot["startTime"]}:00 - ${slot["endTime"]}:00 ${slot["doctorName"]}" ),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: const Text("Confirm Cancellation"),
                              content: const Text(
                                  "Are you sure you want to cancel this appointment?"),
                              actions: [
                                TextButton(onPressed: () =>
                                    Navigator.pop(context, false),
                                    child: const Text("No")),
                                TextButton(onPressed: () =>
                                    Navigator.pop(context, true),
                                    child: const Text("Yes")),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        setState(() {
                          selectedCancelSlotId = value;
                        });

                        try {
                          await _viewModel.cancelAppointment(value);

                          setState(() {
                            savedslots.removeWhere((slot) =>
                            slot["appointmentId"] == value);
                            selectedCancelSlotId = null;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(
                                "Appointment canceled successfully")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                                "Failed to cancel appointment: $e")),
                          );
                        }
                      }
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                );
              })],
        ),
      ),
    ) );
  }
}
