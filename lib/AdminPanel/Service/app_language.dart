import 'package:get/get.dart';

class AppLanguage extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "en_US": {
      "home": "Home",
      "user": "ManageUser",
      "wallet": 'Wallet',
      "language": "Language",
    },
    "ar_UE": {
      "home": "الرئيسية",
      "user": "إدارة المستخدم",
      'wallet': "محفظة",
      "language": "لغة",
    },
  };
}
