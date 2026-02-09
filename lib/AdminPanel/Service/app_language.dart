import 'package:get/get.dart';

class AppLanguage extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "en_US": {
      "home": "Home",
      "user": "ManageUser",
      "wallet": 'Wallet',
      "language": "Language",
      "no live": "No one Live NOw",
      "totaluser": "Total App Users",
      "follow": "Follow",
      "follower": "Follower",
      "manage": 'Manage',
      "blockuser": "Blocked Users",
      "unblock": "Unblock",
    },
    "ar_UE": {
      "home": "الرئيسية",
      "user": "إدارة المستخدم",
      'wallet': "محفظة",
      "language": "لغة",
      "no live": "لا أحد يعيش الآن",
      "totaluser": "إجمالي مستخدمي التطبيق",
      "follow": "يتبع",
      "follower": "تابع",
      "manage": "يدير",
      "blockuser": "المستخدمون المحظورون",
      "unblock": "إلغاء الحظر",
    },
  };
}
