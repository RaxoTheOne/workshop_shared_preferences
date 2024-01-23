import 'package:bloc/bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesState {
  final bool isDarkMode;
  final bool isButtonEnabled;
  final bool isOnboardingFinished;

  SharedPreferencesState(
      {required this.isDarkMode,
      required this.isButtonEnabled,
      required this.isOnboardingFinished});
}

class SharedPreferencesCubit extends Cubit<SharedPreferencesState> {
  final SharedPreferences sharedPreferences;

  SharedPreferencesCubit(this.sharedPreferences)
      : super(SharedPreferencesState(
          isDarkMode: false,
          isButtonEnabled:  true,
          isOnboardingFinished:
              sharedPreferences.getBool("isOnboardingFinished") ?? false,
        ));
        
        
        
        
void toggleTheme() {
    final bool newTheme = !state.isDarkMode;
    sharedPreferences.setBool("isDarkMode", newTheme);
    emit(SharedPreferencesState(
        isDarkMode: newTheme,
        isButtonEnabled: state.isButtonEnabled,
        isOnboardingFinished: state.isOnboardingFinished));
  }

  Future<void> toggleButton() async {
    if (state.isButtonEnabled) {
      final bool newButtonState = !state.isButtonEnabled;
      sharedPreferences.setBool("isButtonEnabled", newButtonState);

      emit(SharedPreferencesState(
          isDarkMode: state.isDarkMode,
          isButtonEnabled: newButtonState,
          isOnboardingFinished: state.isOnboardingFinished));


     await Future.delayed(
        const Duration(seconds: 5),
        () {
          emit(SharedPreferencesState(
              isDarkMode: state.isDarkMode,
              isButtonEnabled: true,
              isOnboardingFinished: state.isOnboardingFinished));
          
        },
      );
      sharedPreferences.setBool("isButtonEnabled", true);
    }
  }

  void toggleOnboarding() {
    final bool newOnboardingState = !state.isOnboardingFinished;
    sharedPreferences.setBool("isOnboardingFinished", newOnboardingState);
    emit(SharedPreferencesState(
        isDarkMode: state.isDarkMode,
        isButtonEnabled: state.isButtonEnabled,
        isOnboardingFinished: newOnboardingState));
  }


}
