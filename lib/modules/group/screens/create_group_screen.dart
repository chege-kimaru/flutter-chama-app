import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/global_widgets/custom_input.dart';
import 'package:chama_app/models/group.dart';
import 'package:chama_app/modules/group/screens/my_groups_screen.dart';
import 'package:chama_app/providers/groups.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroupScreen extends StatefulWidget {
  static const routeName = '/create-group';

  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _form = GlobalKey<FormState>();

  final _nameFocusNode = FocusNode();
  final _createGroupFocusNode = FocusNode();

  CreateGroupDto _createGroupDto = CreateGroupDto('');

  bool _isLoading = false;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _createGroupFocusNode.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || _isLoading) return;
    _form.currentState!.save();
    setState(() => _isLoading = true);
    try {
      Group group = await Provider.of<Groups>(context, listen: false)
          .createGroup(_createGroupDto);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully created ${group.name}!')));
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
                          'Create Group',
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
                            hintText: 'Name',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_createGroupFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter group name';
                              }
                              return null;
                            },
                            focusNode: _nameFocusNode,
                            onSaved: (newValue) {
                              _createGroupDto = CreateGroupDto(newValue ?? '');
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomButton(
                            label: 'Create Group',
                            handler: _createGroup,
                            focusNode: this._createGroupFocusNode,
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
