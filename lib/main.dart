import 'package:flutter/material.dart';

import 'app/app_scope.dart';
import 'presentation/app/kototinder_app.dart';

void main() {
  final appScope = AppScope.create();
  runApp(KototinderApp(scope: appScope));
}
