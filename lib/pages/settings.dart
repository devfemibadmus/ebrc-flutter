import 'package:ebrc/constants/variables.dart';
import 'package:ebrc/constants/database.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bnumberController = TextEditingController();
  final _bunameController = TextEditingController();
  final _bnameController = TextEditingController();
  final _updateAccountkey = GlobalKey<FormState>();
  final _updatePasswordkey = GlobalKey<FormState>();
  String? _oldPasswordError = '';
  String? _newPasswordError = '';
  String? _bnumberError = '';
  String? _bunameError = '';
  String? _bnameError = '';
  bool _bloading = false;
  bool _ploading = false;

  @override
  void initState() {
    super.initState();
    _bnameController.addListener(_validateBname);
    _bunameController.addListener(_validateBuname);
    _bnumberController.addListener(_validateBnumber);
    _newPasswordController.addListener(_validateNewPassword);
    _oldPasswordController.addListener(_validateOldPassword);
  }

  void _validateOldPassword() {
    String password = _oldPasswordController.text;
    RegExp number = RegExp(r'[0-9]');
    RegExp symbol = RegExp(r'[!@#\$%^&*]');

    if (password.length <= 8) {
      setState(() {
        _oldPasswordError = 'must can\'t be less than 8';
      });
    } else if (!number.hasMatch(password)) {
      setState(() {
        _oldPasswordError = 'Invalid Password';
      });
    } else if (!symbol.hasMatch(password)) {
      return setState(() {
        _oldPasswordError = 'Invalid Password';
      });
    } else {
      setState(() {
        _oldPasswordError = null;
      });
    }
  }

  void _validateNewPassword() {
    String password = _newPasswordController.text;
    RegExp number = RegExp(r'[0-9]');
    RegExp symbol = RegExp(r'[!@#\$%^&*]');

    if (password.length <= 8) {
      setState(() {
        _newPasswordError = 'must can\'t be less than 8';
      });
    } else if (!number.hasMatch(password)) {
      setState(() {
        _newPasswordError = 'at least one number (0123456789)';
      });
    } else if (password == _oldPasswordController.text) {
      return setState(() {
        _newPasswordError = 'new password can not be same as old password';
      });
    } else if (!symbol.hasMatch(password)) {
      return setState(() {
        _newPasswordError = 'at least one symbols (!@#\$%^&*)';
      });
    } else {
      setState(() {
        _newPasswordError = null;
      });
    }
  }

  void _validateBnumber() {
    String bnumber = _bnumberController.text;

    if (bnumber.length != 10) {
      setState(() {
        _bnumberError = 'can\'t be less than 10 digits';
      });
    } else {
      setState(() {
        _bnumberError = null;
      });
    }
  }

  void _validateBname() {
    String bname = _bnameController.text;

    if (bname.length < 4) {
      setState(() {
        _bnameError = 'please enter bank full name';
      });
    } else {
      setState(() {
        _bnameError = null;
      });
    }
  }

  void _validateBuname() {
    String buname = _bunameController.text;
    List<String> words = buname.split(",");

    if (buname.length < 10) {
      setState(() {
        _bunameError = 'firstname, middlename, lastname,';
      });
    } else if (words.length != 4) {
      setState(() {
        _bunameError = "Enter in the format 'firstname, middlename, lastname,'";
      });
    } else {
      setState(() {
        _bunameError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          "account settings page, set your bank details so to recieve payment and update your password too on this page",
      child: FutureBuilder<Account>(
        future: getAccountFromSharedPrefs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Account? user = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: const Text("Account Settings"),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: defaultPadding / 2),
                    const Text("Bank Account Update"),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _updateAccountkey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _bnameController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              cursorColor: bgColor,
                              enabled: user!.accountEditable,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your bank name';
                                }
                                return _bnameError;
                              },
                              onChanged: (String value) {
                                _updateAccountkey.currentState!.validate();
                              },
                              decoration: InputDecoration(
                                hintText: user.accountEditable == false
                                    ? user.accountName
                                    : 'Bank Name',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(Icons.account_balance),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            TextFormField(
                              controller: _bnumberController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              cursorColor: bgColor,
                              enabled: user.accountEditable,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your bank account number';
                                }
                                return _bnumberError;
                              },
                              onChanged: (String value) {
                                _updateAccountkey.currentState!.validate();
                              },
                              decoration: InputDecoration(
                                hintText: user.accountEditable == false
                                    ? user.accountNumber.toString()
                                    : 'Bank Account Number',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(Icons.numbers),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            TextFormField(
                              controller: _bunameController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              cursorColor: bgColor,
                              enabled: user.accountEditable,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your bank account name';
                                }
                                return _bunameError;
                              },
                              onChanged: (String value) {
                                _updateAccountkey.currentState!.validate();
                              },
                              decoration: InputDecoration(
                                hintText: user.accountEditable == false
                                    ? user.accountUname
                                    : 'First Name Middle Name Last Name',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(Icons.account_balance),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            TextFormField(
                              controller: _passwordController,
                              textInputAction: TextInputAction.done,
                              cursorColor: bgColor,
                              enabled: user.accountEditable,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your passworrd';
                                } else if (value != user.password) {
                                  return 'Incorrect Password';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (String value) {
                                _updateAccountkey.currentState!.validate();
                              },
                              decoration: const InputDecoration(
                                hintText: 'your password',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(Icons.lock),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            Visibility(
                              visible: _bloading,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            ElevatedButton(
                              onPressed: () {
                                if (user.accountEditable ?? false) {
                                  setState(() {
                                    _bloading = true;
                                  });
                                  if (_updateAccountkey.currentState!
                                      .validate()) {
                                    //
                                    bank(
                                      _bnameController.text,
                                      _bnumberController.text,
                                      _bunameController.text,
                                    ).then(
                                      (value) {
                                        setState(
                                          () {
                                            _bloading = false;
                                          },
                                        );
                                        if (value == true) {
                                          showAlert(
                                              context,
                                              "Account Info",
                                              "Account info updated successfully you can check detail in your notifications",
                                              false,
                                              '');
                                        }
                                      },
                                    );
                                  } else {
                                    setState(
                                      () {
                                        _bloading = false;
                                      },
                                    );
                                  }
                                } else {
                                  showAlert(
                                      context,
                                      "Bank",
                                      "Bank info already exist you can not edit this",
                                      false,
                                      '');
                                }
                              },
                              child: Text(
                                "save".toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    const Text("Password Update"),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _updatePasswordkey,
                        child: Column(
                          children: [
                            const SizedBox(height: defaultPadding / 2),
                            TextFormField(
                              controller: _oldPasswordController,
                              textInputAction: TextInputAction.done,
                              cursorColor: bgColor,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your passworrd';
                                }
                                return _oldPasswordError;
                              },
                              onChanged: (String value) {
                                _updatePasswordkey.currentState!.validate();
                              },
                              decoration: const InputDecoration(
                                hintText: 'old password',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(Icons.lock),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            TextFormField(
                              controller: _newPasswordController,
                              textInputAction: TextInputAction.done,
                              cursorColor: bgColor,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your new passworrd';
                                }
                                return _newPasswordError;
                              },
                              onChanged: (String value) {
                                _updatePasswordkey.currentState!.validate();
                              },
                              decoration: const InputDecoration(
                                hintText: 'new password',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(Icons.lock),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            Visibility(
                              visible: _ploading,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _ploading = true;
                                });
                                if (_updatePasswordkey.currentState!
                                    .validate()) {
                                  //print("${_oldPasswordController.text} ${_newPasswordController.text}");
                                  setState(() {
                                    _ploading = false;
                                  });
                                } else {
                                  setState(
                                    () {
                                      _ploading = false;
                                    },
                                  );
                                }
                              },
                              child: Text("save".toUpperCase(),
                                  style: const TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
              child: CircularProgressIndicator(color: kPrimaryLightColor));
        },
      ),
    );
  }
}
