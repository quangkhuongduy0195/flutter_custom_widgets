import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _value = false;
  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(widget.value);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        width: 64,
        height: 34,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.black,
          ),
          // color: _value ? Colors.orange : Colors.teal,
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 300),
          alignment: _value ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.decelerate,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _value ? Colors.black : Colors.black26,
                // borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
