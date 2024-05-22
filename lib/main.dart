import 'package:flutter/material.dart';
import 'package:mhtask/setupService.dart';

import 'FormService.dart';
import 'package:provider/provider.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Form App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final formService = getIt<FormService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _showFormData(context, formService.components);
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => formService,
        child: Consumer<FormService>(
          builder: (context, formService, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...formService.components
                      .asMap()
                      .map((index, component) => MapEntry(
                    index,
                    FormComponent(
                      index: index,
                      formData: component,
                      onRemove: () => formService.removeComponent(index),
                      onUpdate: (data) =>
                          formService.updateComponent(index, data),
                    ),
                  ))
                      .values
                      .toList(),
                  ElevatedButton(
                    onPressed: formService.addComponent,
                    child: Text('ADD'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showFormData(BuildContext context, List<FormData> components) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: components.map((component) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Label: ${component.label}'),
                        Text('Info-Text: ${component.infoText}'),
                        Text('Settings: ${component.settings}'),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}



class FormComponent extends StatefulWidget {
  final int index;
  final FormData formData;
  final VoidCallback onRemove;
  final ValueChanged<FormData> onUpdate;

  FormComponent({
    required this.index,
    required this.formData,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  _FormComponentState createState() => _FormComponentState();
}

class _FormComponentState extends State<FormComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: widget.formData.settings == 'Checked',
                onChanged: (value) {
                  setState(() {
                    widget.formData.settings = value! ? 'Checked' : 'Unchecked';
                    widget.onUpdate(widget.formData);
                  });
                },
              ),
              Text('Checkbox ${widget.index + 1}'),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Label',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
            onChanged: (value) {
              widget.formData.label = value;
              widget.onUpdate(widget.formData);
            },
          ),
          SizedBox(height: 8.0),
          TextField(
            decoration: InputDecoration(
              labelText: 'Info-Text',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
            onChanged: (value) {
              widget.formData.infoText = value;
              widget.onUpdate(widget.formData);
            },
          ),
          SizedBox(height: 8.0),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: 'Required',
                    groupValue: widget.formData.settings,
                    onChanged: (value) {
                      setState(() {
                        widget.formData.settings = value!;
                        widget.onUpdate(widget.formData);
                      });
                    },
                  ),
                  const Text('Required'),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'Readonly',
                    groupValue: widget.formData.settings,
                    onChanged: (value) {
                      setState(() {
                        widget.formData.settings = value!;
                        widget.onUpdate(widget.formData);
                      });
                    },
                  ),
                  const Text('Readonly'),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'Hidefield',
                    groupValue: widget.formData.settings,
                    onChanged: (value) {
                      setState(() {
                        widget.formData.settings = value!;
                        widget.onUpdate(widget.formData);
                      });
                    },
                  ),
                  const Text('Hidefield'),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: widget.onRemove,
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }
}
