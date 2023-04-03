import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenderRadioGroup extends StatefulWidget {
  final String? defaultValue;
  final String value1;
  final String value2;
  final Function(String) onChanged;

  const GenderRadioGroup(
      {Key? key,
      this.defaultValue,
      required this.value1,
      required this.value2,
      required this.onChanged})
      : super(key: key);

  @override
  _GenderRadioGroupState createState() => _GenderRadioGroupState();
}

class _GenderRadioGroupState extends State<GenderRadioGroup> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.defaultValue ?? '';
    Future.microtask(() {
      widget.onChanged(_selectedGender);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: widget.value1,
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
              widget.onChanged(value);
            });
          },
        ),
        Text(widget.value1),
        Radio(
          value: widget.value2,
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
              widget.onChanged(value);
            });
          },
        ),
        Text(widget.value2),
      ],
    );
  }
}
