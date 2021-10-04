import 'package:flutter/material.dart';

class HomeItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function()? handler;

  const HomeItem({required this.label, required this.icon, this.handler});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: this.handler,
            child: Icon(
              this.icon,
              color: Colors.black,
            ),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              primary: Colors.white,
              // onPrimary: Colors.black,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            this.label,
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontFamily: 'ModernAntiqua'),
          ),
        ],
      ),
    );
  }
}
