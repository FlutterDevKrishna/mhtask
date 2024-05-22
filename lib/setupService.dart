import 'package:get_it/get_it.dart';

import 'FormService.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<FormService>(() => FormService());
}
