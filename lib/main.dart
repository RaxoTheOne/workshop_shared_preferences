import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_example/theme_cubit/shared_preferences_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SharedPreferencesCubit(sharedPreferences),
      child: BlocBuilder<SharedPreferencesCubit, SharedPreferencesState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Theme Changer',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: state.isOnboardingFinished
                ? const MyHomePage()
                : const OnboardingPage(),
          );
        },
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("This is an Onboarding Screen"),
            ElevatedButton(
                onPressed: () {
                  context.read<SharedPreferencesCubit>().toggleOnboarding();
                },
                child: const Text("Finish Onboarding")),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Theme switch:',
            ),
            Switch(
              value: context.watch<SharedPreferencesCubit>().state.isDarkMode,
              onChanged: (value) {
                context.read<SharedPreferencesCubit>().toggleTheme();
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<SharedPreferencesCubit>().toggleButton();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    context.read<SharedPreferencesCubit>().state.isButtonEnabled
                        ? Colors.blue
                        : Colors.grey,
              ),
              child: const Text(
                "Click me once every 5 Seconds",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<SharedPreferencesCubit>().toggleOnboarding();
              },
              child: const Text("Enable Onboarding Again"),
            )
          ],
        ),
      ),
    );
  }
}
