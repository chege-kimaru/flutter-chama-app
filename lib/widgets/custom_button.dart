import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function handler;
  final FocusNode focusNode;
  final bool loading;

  const CustomButton(
      {@required this.label,
      @required this.handler,
      this.focusNode,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        // style: ButtonStyle(
        //   shape:
        //       MaterialStateProperty.all<RoundedRectangleBorder>(
        //     RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(18.0),
        //     ),
        //   ),
        //   backgroundColor: MaterialStateProperty.all<Color>(
        //       Theme.of(context).primaryColor),
        // ),
        style: TextButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            backgroundColor: Theme.of(context).primaryColor),
        child: loading
            ? CircularProgressIndicator()
            : Text(
                this.label,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18,
                ),
              ),
        onPressed: this.handler,
        focusNode: this.focusNode,
      ),
    );
  }
}
