import 'package:enavit/Data/DB_sql.dart';
import 'package:enavit/models/notify.dart';

import 'package:get/get.dart';

class DataController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }


  Future<void> fetchData({required Notify notify}) async {
    return await DBSql.insertNotify(notify);
  }

  

}
