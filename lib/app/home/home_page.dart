import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/account/account_page.dart';
import 'package:time_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _selectTab(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async =>!await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _selectTab,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
