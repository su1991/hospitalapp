import 'package:flutter/material.dart';
import 'package:gfhfg/Views/Doctordashboard.dart';
import 'package:gfhfg/Views/loginview.dart';
import 'package:gfhfg/Views/patientstab.dart';
import '../ViewModel/login.dart';
import 'patientmainscreen.dart';
import 'schedulepateint.dart';// Import your separate files
// import 'schedule_page.dart';

class navigationdr extends StatefulWidget
{ final VoidCallback onToggleTheme;
  const navigationdr({super.key, required this.onToggleTheme});

  @override
  State<navigationdr> createState() => _navigationbar();


}



class _navigationbar extends State<navigationdr>
{
  final LoginViewModel _viewModel = LoginViewModel();

  void changeTab(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  void handleLogout() async
  {
    await _viewModel.logout();

    // Navigate to Login screen and remove all previous screens
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => login(onToggleTheme: widget.onToggleTheme)),
          (route) => false,
    );
  }
  int _selectedIndex = 0;

  // The pages that will be displayed in the body
  late final List<Widget> _pages =
  [
    Homedoc(

        onSchedulePressed: ()
        {
          setState(() {
            _selectedIndex = 1;
          });
        }
    ),
    Schedule(),

    patients(),
    const Center(child: Text("chat")),
    const Center(child: Text("Notification")),
    const Center(child: Text("profile")),
  ];

  VoidCallback? get handleslogut => handleLogout;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      // Setting the color here provides the base for all sub-pages

      appBar: AppBar
        (
        title: const Text("Dcotor Portal"),

        elevation: 0,
        actions: [
          ElevatedButton.icon(onPressed: handleslogut, icon: Icon(Icons.logout), label: Text("logout"), style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA1C5CB))
          ), IconButton(
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
          NavigationDestination(icon: Icon(Icons.people), label: 'patients'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'chat'),
          NavigationDestination(icon: Icon(Icons.notifications), label: 'notification'),
          NavigationDestination(icon: Icon(Icons.person), label: 'profile'),
        ],

      ),
    );
  }
}