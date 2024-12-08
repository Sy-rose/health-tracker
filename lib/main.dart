import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/core/services/injection_container.dart';
import 'package:health_metrics_tracker/global_theme_data.dart';

import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/view_all_patient_page.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';  // Import SharedPreferences
import 'firebase_options.dart';
import 'healthmetric managment/presentation/view_all_health_metric_page.dart';
import 'profile_page.dart'; // Import ProfilePage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<HealthMetricCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<PatientCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Health Metrics Tracker',
        themeMode: ThemeMode.light,
        theme: GlobalThemeData.lightThemeData,
        home: const MyHomePage(title: "Health Metrics Tracker"),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0; // Default index

  final List<Widget> _pages = [
    const ViewAllPatientsPage(),
    ViewAllHealthMetricsPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadPageIndex(); // Load the saved page index on app start
  }

  // Function to load the saved page index from SharedPreferences
  Future<void> _loadPageIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('currentIndex') ?? 0; // Default to 0 if not found
    setState(() {
      _currentIndex = savedIndex; // Set the loaded index
    });
  }

  // Function to save the page index to SharedPreferences
  Future<void> _savePageIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentIndex', index); // Save the index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Switch between pages
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change the index to switch pages
            _savePageIndex(index); // Save the new index
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: "Patients",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: "Health Metrics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
