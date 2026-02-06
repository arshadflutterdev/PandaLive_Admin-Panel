import 'package:get/instance_manager.dart';
import 'package:panda_adminpanel/AdminPanel/Controllers/watchlive_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WatchStreamControllers>(() => WatchStreamControllers());
  }
}
