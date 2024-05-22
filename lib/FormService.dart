import 'package:flutter/material.dart';

class FormService extends ChangeNotifier {
  List<FormData> components = [FormData()];

  void addComponent() {
    components.add(FormData());
    notifyListeners();
  }

  void removeComponent(int index) {
    if (components.length > 1) {
      components.removeAt(index);
      notifyListeners();
    }
  }

  void updateComponent(int index, FormData data) {
    components[index] = data;
    notifyListeners();
  }
}

class FormData {
  String label = '';
  String infoText = '';
  String settings = 'Required';

  FormData({this.label = '', this.infoText = '', this.settings = 'Required'});
}
