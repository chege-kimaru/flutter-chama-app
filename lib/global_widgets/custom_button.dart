import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final void Function() handler;
  final FocusNode? focusNode;
  final bool loading;
  final Color? backgroundColor;
  final Color? labelColor;

  const CustomButton(
      {@required required this.label,
      @required required this.handler,
      this.focusNode,
      this.loading = false,
      this.backgroundColor,
      this.labelColor});

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
            backgroundColor:
                this.backgroundColor ?? Theme.of(context).primaryColor),
        child: loading
            ? CircularProgressIndicator()
            : Text(
                this.label,
                style: TextStyle(
                  color: this.labelColor ?? Theme.of(context).accentColor,
                  fontSize: 18,
                ),
              ),
        onPressed: this.handler,
        focusNode: this.focusNode,
      ),
    );
  }
}
