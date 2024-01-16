import 'package:ebrsng/constants/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Monster After Dark
// Final Destination
// Jakie Chanuary
// Mad-Max: furry road
// Furious 7
// Battle Los Angeles
// Robotapocalyps
// THhe trigonal: fight for justice
// Jide Jendo
// mia and the white lion
// Beast
// mohbad weekend
// soso omahlay
// wondamo rema, mavis, boy spyce, bayanni, crayon
// now davido, forecalistic

Account defaultAccount = Account(
  id: 0,
  email: 'email',
  username: 'username',
  account_balance: 0,
  referral: 'referral',
  password: 'password',
  earn_balance: 0,
  notifications: [],
  account_name: "fcmb",
  account_number: 0,
  coin_balance: 0,
  reward_ads: false,
  tic_tac_toe_1: false,
  tic_tac_toe_2: false,
  tic_tac_toe_3: false,
  user_referral: false,
  super_referral: false,
  might_referral: false,
  premium_referral: false,
  account_editable: false,
  account_uname: '',
  pending_cashout: false,
);

class Account {
  int? id;
  String? email;
  String? referral;
  String? username;
  String? password;
  String? account_name;
  String? account_uname;
  int? account_number;
  int? account_balance;
  int? coin_balance;
  int? earn_balance;
  bool? reward_ads;
  bool? account_editable;
  bool? tic_tac_toe_1;
  bool? tic_tac_toe_2;
  bool? tic_tac_toe_3;
  bool? user_referral;
  bool? super_referral;
  bool? might_referral;
  bool? premium_referral;
  bool? pending_cashout;
  List<Notification>? notifications;

  Account({
    this.id,
    this.email,
    this.referral,
    this.username,
    this.password,
    this.account_name,
    this.account_uname,
    this.account_number,
    this.account_balance,
    this.notifications,
    this.coin_balance,
    this.earn_balance,
    this.account_editable,
    this.reward_ads,
    this.tic_tac_toe_1,
    this.tic_tac_toe_2,
    this.tic_tac_toe_3,
    this.user_referral,
    this.super_referral,
    this.might_referral,
    this.premium_referral,
    this.pending_cashout,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    List<Notification> notificationsList = [];
    if (json['notifications'] != null) {
      var list = json['notifications'] as List;
      notificationsList = list.map((i) => Notification.fromJson(i)).toList();
    }

    return Account(
      id: json['id'],
      email: json['email'],
      referral: json['referral'],
      username: json['username'],
      password: json['password'],
      account_name: json['account_name'],
      account_uname: json['account_uname'],
      account_editable:
          json['account_editable'] == 1 || json['account_editable'] == true,
      account_number: json['account_number'],
      earn_balance: json['earn_balance'],
      account_balance: json['account_balance'],
      notifications: notificationsList,
      coin_balance: json['coin_balance'],
      reward_ads: json['reward_ads'] == 1 || json['reward_ads'] == true,
      tic_tac_toe_1:
          json['tic_tac_toe_1'] == 1 || json['tic_tac_toe_1'] == true,
      tic_tac_toe_2:
          json['tic_tac_toe_2'] == 1 || json['tic_tac_toe_2'] == true,
      tic_tac_toe_3:
          json['tic_tac_toe_3'] == 1 || json['tic_tac_toe_3'] == true,
      user_referral:
          json['user_referral'] == 1 || json['user_referral'] == true,
      super_referral:
          json['super_referral'] == 1 || json['super_referral'] == true,
      might_referral:
          json['might_referral'] == 1 || json['might_referral'] == true,
      premium_referral:
          json['premium_referral'] == 1 || json['premium_referral'] == true,
      pending_cashout:
          json['pending_cashout'] == 1 || json['pending_cashout'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    var notificationsList = <Map<String, dynamic>>[];
    for (var i in notifications!) {
      notificationsList.add(i.toJson());
    }
    return {
      'id': id,
      'email': email,
      'referral': referral,
      'username': username,
      'password': password,
      'account_editable': account_editable,
      'account_uname': account_uname,
      'account_name': account_name,
      'account_number': account_number,
      'account_balance': account_balance,
      'notifications': notificationsList,
      'coin_balance': coin_balance,
      'earn_balance': earn_balance,
      'reward_ads': reward_ads,
      'tic_tac_toe_1': tic_tac_toe_1,
      'tic_tac_toe_2': tic_tac_toe_2,
      'tic_tac_toe_3': tic_tac_toe_3,
      'user_referral': user_referral,
      'super_referral': super_referral,
      'might_referral': might_referral,
      'premium_referral': premium_referral,
      'pending_cashout': pending_cashout,
    };
  }
}

class Notification {
  String date;
  String type;
  int amount;
  String comment;
  String referral;
  int account_id;

  Notification(
      {required this.date,
      required this.type,
      required this.amount,
      required this.comment,
      required this.referral,
      required this.account_id});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      date: json['date'],
      type: json['type'],
      amount: json['amount'],
      referral: json['referral'],
      comment: json['comment'],
      account_id: json['account_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'type': type,
      'amount': amount,
      'comment': comment,
      'referral': referral,
      'account_id': account_id,
    };
  }
}

Future<Account?> signIn(String username, String password) async {
  //print("hello");
  final response = await http.post(
    signInUrl,
    body: jsonEncode(
      {'username': username, 'password': password},
    ),
  );

  if (response.statusCode == 200) {
    var responseJson = jsonDecode(response.body);
    print(responseJson);
    if (responseJson['status'] == 'success') {
      var account = Account.fromJson(responseJson['account']);
      account.notifications = (responseJson['notifications'] as List<dynamic>)
          .map((e) => Notification.fromJson(e))
          .toList();
      account.notifications = account.notifications!.reversed.toList();
      account.password = password;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('account', jsonEncode(account.toJson()));
      return Account.fromJson(responseJson['account']);
    } else {
      //print(responseJson['message']);
      return null;
    }
  } else {
    //print('object');
    return defaultAccount;
  }
}

Future<Account> getAccountFromSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final accountJson = prefs.getString("account");
  //print(accountJson);
  //print('accountJson');
  if (accountJson == null) {
    throw const FormatException('No Account');
  } else {
    final account = Account.fromJson(jsonDecode(accountJson));
    //print(account.notifications[0]);
    return account;
  }
}

Future<void> refreshAccount() async {
  final prefs = await SharedPreferences.getInstance();
  final accountJson = prefs.getString("account");
  if (accountJson == null) {
    throw const FormatException('No Account');
  } else {
    final account = Account.fromJson(jsonDecode(accountJson));
    //print(account.password);
    await signIn(account.username ?? "", account.password ?? "");
  }
}

Future<void> logOut() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<String> usernameExist(String username) async {
  final response = await http.post(
    usernameUrl,
    body: jsonEncode(
      {'username': username},
    ),
  );

  if (response.statusCode == 200) {
    var responseJson = jsonDecode(response.body);
    print(responseJson);
    return responseJson['exist'];
  } else {
    return 'connection';
  }
}

Future createNewNotification(String type, double amount, String comment) async {
  // Make new-Notification request and get response
  final response = await http.post(
    notificationUrl,
    body: jsonEncode(
      {
        //'username': username,
        //'password': password,
        //"account_id": id.toString(),
        //"date": date,
        "type": type,
        "amount": amount.toString(),
        "comment": comment
      },
    ),
  );
  var responseJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // success
    return responseJson['message'];
  } else {
    // error
    return 'Failed to create new Notification';
  }
}

Future<String?> signUp(
    String email, String username, String password, String referee) async {
  final response = await http.post(signUpUrl,
      body: jsonEncode(
        {
          'email': email,
          'username': username,
          'password': password,
          'referral': referee,
        },
      ));

  if (response.statusCode == 200) {
    var responseJson = jsonDecode(response.body);
    if (responseJson['status'] == 'success') {
      var account = Account.fromJson(responseJson['account']);
      print(responseJson['account']);
      account.password = password;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('account', jsonEncode(account.toJson()));
    }
    //print(responseJson['message']);
    return responseJson['status'];
  } else {
    return 'connection';
  }
}

Future<bool> rewardUser(int reward) async {
  //print("$bankname, $bankNumber, $bankUserName");
  final prefs = await SharedPreferences.getInstance();
  final accountJson = prefs.getString("account");
  final account = Account.fromJson(jsonDecode(accountJson!));
  final response = await http.post(
    rewardUrl,
    body: jsonEncode(
      {
        'username': account.username,
        'password': account.password,
        'reward': reward,
      },
    ),
  );

  if (response.statusCode == 200) {
    var responseJson = jsonDecode(response.body);
    if (responseJson['status'] == 'success') {
      //return Account.fromJson(responseJson['account']);
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> bank(
    String bankname, String bankNumber, String bankUserName) async {
  final prefs = await SharedPreferences.getInstance();
  final accountJson = prefs.getString("account");
  final account = Account.fromJson(jsonDecode(accountJson!));
  final response = await http.post(
    bankAccountUrl,
    body: jsonEncode(
      {
        'username': account.username,
        'password': account.password,
        'account_name': bankname,
        'account_uname': bankUserName,
        'account_number': bankNumber,
      },
    ),
  );

  if (response.statusCode == 200) {
    var responseJson = jsonDecode(response.body);
    if (responseJson['status'] == 'success') {
      //return Account.fromJson(responseJson['account']);
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
