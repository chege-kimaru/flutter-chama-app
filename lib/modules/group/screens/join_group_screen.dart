import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/global_widgets/custom_input.dart';
import 'package:chama_app/models/group.dart';
import 'package:chama_app/modules/group/screens/my_groups_screen.dart';
import 'package:chama_app/providers/groups.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinGroupScreen extends StatefulWidget {
  static const routeName = '/join-group';

  const JoinGroupScreen({Key? key}) : super(key: key);

  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _form = GlobalKey<FormState>();

  final _codeFocusNode = FocusNode();
  final _joinGroupFocusNode = FocusNode();

  int? _code;

  bool _isLoading = false;

  @override
  void dispose() {
    _codeFocusNode.dispose();
    _joinGroupFocusNode.dispose();
    super.dispose();
  }

  Future<void> _findGroupByCode() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || _isLoading) return;
    _form.currentState!.save();
    setState(() => _isLoading = true);
    try {
      Group group = await Provider.of<Groups>(context, listen: false)
          .findGroupByCode(_code!);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Are you sure you want to join ${group.name}?'),
                // content: Text(''),
                actions: [
                  TextButton(
                      onPressed: () {
                        this._joinGroup(group);
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('Yes')),
                  TextButton(
                      onPressed: () {
                        // close the alert dialog
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Cancel'))
                ],
              ));
      // Navigator.of(context).pushNamed(MyGroupsScreen.routeName);
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred'),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        // close the alert dialog
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay'))
                ],
              ));
    }
    setState(() => _isLoading = false);
  }

  Future<void> _joinGroup(Group group) async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<Groups>(context, listen: false).joinGroup(group.id!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Your request to join ${group.name} has been accepted. You will be notified once the admin accepts you.')));
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(MyGroupsScreen.routeName);
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred'),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        // close the alert dialog
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay'))
                ],
              ));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 48),
                        Text(
                          'Join Group',
                          style: TextStyle(
                              fontFamily: 'ModernAntiqua',
                              fontSize: 24,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(30),
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.secondary),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          CustomInput(
                            hintText: 'Group Code',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_joinGroupFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the group code';
                              }
                              return null;
                            },
                            focusNode: _codeFocusNode,
                            onSaved: (newValue) {
                              _code = int.parse(newValue ?? '0');
                            },
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomButton(
                            label: 'Search Group',
                            handler: _findGroupByCode,
                            focusNode: this._joinGroupFocusNode,
                            loading: _isLoading,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
