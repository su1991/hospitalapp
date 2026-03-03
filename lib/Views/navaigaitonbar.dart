import 'package:flutter/material.dart';
import 'loginview.dart';
import '../ViewModel/login.dart';
import 'patientmainscreen.dart';
import 'schedulepateint.dart';// Import your separate files
// import 'schedule_page.dart';

class navigation extends StatefulWidget
{
  final VoidCallback onToggleTheme;
  const navigation({super.key, required this.onToggleTheme,});
  @override
  State<navigation> createState() => _navigationbar();
}

final LoginViewModel _viewModel = LoginViewModel();

class _navigationbar extends State<navigation>
{
  void changeTab(int index)
  {
    setState(()
    {
      _selectedIndex = index;
    });
  }

  void handleLogout() async
  {
    await _viewModel.logout();


    Navigator.pushAndRemoveUntil
      (
      context,
      MaterialPageRoute(builder: (context) => login(onToggleTheme: widget.onToggleTheme)),
          (route) => false,
    );
  }
  int _selectedIndex = 0;

  // The pages that will be displayed in the body
  late final List<Widget> _pages =
  [
    HomePage(

 onSchedulePressed: ()
 {
      setState(() {
        _selectedIndex = 1;
      });
    }
    ),
    Schedule(),
    const Center(child: Text("Report")),
    const Center(child: Text("Notifications")),
  ];
  VoidCallback? get handleslogut => handleLogout;




  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      // Setting the color here provides the base for all sub-pages

      appBar: AppBar(

        title: const Text("Patient Portal"),

        elevation: 0,
        actions: [
          ElevatedButton.icon(onPressed: handleslogut, icon: Icon(Icons.logout), label: Text("logout"), style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA1C5CB),
          )
          )

          ,IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),


        ],

      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar
        (

         shadowColor: const Color(0xFFA1C5CB) ,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index)
        {
          setState(()
          {
            _selectedIndex = index;
          });
        },
        destinations: const
        [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Schedule'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'Report'),
          NavigationDestination(icon: Icon(Icons.notifications), label: 'notifications'),
        ],

      ),
    );
  }
}