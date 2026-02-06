import 'package:get/get.dart';
import 'package:panda_adminpanel/AdminPanel/Authentication/login_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Bindings/app_bindings.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/AboutMeScreens/about_me.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/AppUsersScreens/app_users_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/GraphScreen/graph_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/HomeScreen/home_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/HomeScreen/watch_streamer.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/SettingsScreen/settings_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/SideBar/sidebar.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/Wallet/wallet_screen.dart';

class AppRoutes {
  static const String login = "/LoginScreen";
  static const String home = "/HomeScreen";
  static const String sidebar = "/SideBarScreen";
  static const String graph = "/GraphScreen";

  static const String setting = "/SettingsScreen";
  static const String users = "/AppUsersScreen";
  static const String wallet = "/WalletScreen";
  static const String me = "/AboutMe";
  static const String watchstream = "/WatchstreamingClass";
  static final List<GetPage> routes = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: sidebar, page: () => SideBarScreen()),
    GetPage(name: graph, page: () => GraphScreen()),
    GetPage(name: setting, page: () => SettingsScreen()),
    GetPage(name: users, page: () => AppUsersScreen()),
    GetPage(name: wallet, page: () => WalletScreen()),
    GetPage(name: me, page: () => AboutMe()),
    GetPage(
      name: watchstream,
      binding: AppBindings(),
      page: () => WatchstreamingClass(),
    ),
  ];
}
