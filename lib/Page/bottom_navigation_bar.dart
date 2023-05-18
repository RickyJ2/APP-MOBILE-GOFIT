import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_gofit/Bloc/AppBloc/app_state.dart';

import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/AppBloc/app_event.dart';
import '../const.dart';

class BotttomNavigationBarPage extends StatefulWidget {
  final Widget mainPageContent;
  final int selectedIndex;
  const BotttomNavigationBarPage(
      {super.key, required this.mainPageContent, required this.selectedIndex});

  @override
  State<BotttomNavigationBarPage> createState() =>
      _BotttomNavigationBarPageState();
}

class _BotttomNavigationBarPageState extends State<BotttomNavigationBarPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<AppBloc>()
        .add(ChangedSelectedIndex(selectedIndex: widget.selectedIndex));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 56.0,
                ),
                child: widget.mainPageContent,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: accentColor,
              selectedItemColor: primaryColor,
              selectedLabelStyle: TextStyle(color: primaryColor),
              unselectedItemColor: textColor,
              unselectedLabelStyle: TextStyle(color: textColor),
              showUnselectedLabels: false,
              items: bottomMenuNavigationList[state.user.role],
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context
                    .read<AppBloc>()
                    .add(ChangedSelectedIndex(selectedIndex: index));
                switch (state.user.role) {
                  //Member
                  case 0:
                    {
                      switch (index) {
                        case 0:
                          {
                            context.go('/home-member');
                            break;
                          }
                        case 1:
                          {
                            context.go('/history-member', extra: 0);
                            break;
                          }
                        case 2:
                          {
                            context.go('/setting');
                            break;
                          }
                      }
                      break;
                    }
                  //Instruktur
                  case 1:
                    {
                      switch (index) {
                        case 0:
                          {
                            context.go('/home-instruktur');
                            break;
                          }
                        case 1:
                          {
                            break;
                          }
                        case 2:
                          {
                            context.go('/setting');
                            break;
                          }
                      }
                      break;
                    }
                  //MO
                  case 2:
                    {
                      switch (index) {
                        case 0:
                          {
                            context.go('/home-MO');
                            break;
                          }
                        case 1:
                          {
                            context.go('/setting');
                            break;
                          }
                      }
                      break;
                    }
                  //Guest
                  case 3:
                    {
                      switch (index) {
                        case 0:
                          {
                            context.go('/home-guest');
                            break;
                          }
                        case 1:
                          {
                            context.go('/jadwal-umum-guest');
                            break;
                          }
                        case 2:
                          {
                            context.go('/setting');
                            break;
                          }
                      }
                      break;
                    }
                }
              },
            ),
          ),
        );
      },
    );
  }
}
