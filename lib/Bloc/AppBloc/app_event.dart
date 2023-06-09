abstract class AppEvent {
  const AppEvent();
}

class AppOpened extends AppEvent {
  const AppOpened();
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

class AppLogouted extends AppEvent {
  const AppLogouted();
}

class AppLogined extends AppEvent {
  const AppLogined();
}

class ChangedSelectedIndex extends AppEvent {
  const ChangedSelectedIndex({required this.selectedIndex});

  final int selectedIndex;
}

class GuestModeRequested extends AppEvent {
  const GuestModeRequested();
}
