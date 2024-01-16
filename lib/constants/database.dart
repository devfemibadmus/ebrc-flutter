import 'package:ebrsng/constants/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// This are movies i watch while coding...they are interesting i save them here to watch later

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
  accountBalance: 0,
  referral: 'referral',
  password: 'password',
  earnBalance: 0,
  notifications: [],
  accountName: "fcmb",
  accountNumber: 0,
  coinBalance: 0,
  accountEditable: false,
  accountUname: '',
  pendingCashout: false,
);

class Account {
  int? id;
  String? email;
  String? referral;
  String? username;
  String? password;
  String? accountName;
  String? accountUname;
  int? accountNumber;
  int? accountBalance;
  int? coinBalance;
  int? earnBalance;
  bool? accountEditable;
  bool? pendingCashout;
  List<Notification>? notifications;

  Account({
    this.id,
    this.email,
    this.referral,
    this.username,
    this.password,
    this.accountName,
    this.accountUname,
    this.accountNumber,
    this.accountBalance,
    this.notifications,
    this.coinBalance,
    this.earnBalance,
    this.accountEditable,
    this.pendingCashout,
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
      accountName: json['accountName'],
      accountUname: json['accountUname'],
      accountEditable:
          json['accountEditable'] == 1 || json['accountEditable'] == true,
      accountNumber: json['accountNumber'],
      earnBalance: json['earnBalance'],
      accountBalance: json['accountBalance'],
      notifications: notificationsList,
      coinBalance: json['coinBalance'],
      pendingCashout:
          json['pendingCashout'] == 1 || json['pendingCashout'] == true,
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
      'accountEditable': accountEditable,
      'accountUname': accountUname,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'accountBalance': accountBalance,
      'notifications': notificationsList,
      'coinBalance': coinBalance,
      'earnBalance': earnBalance,
      'pendingCashout': pendingCashout,
    };
  }
}

class Notification {
  String date;
  String type;
  int amount;
  String comment;
  String referral;
  int accountId;

  Notification(
      {required this.date,
      required this.type,
      required this.amount,
      required this.comment,
      required this.referral,
      required this.accountId});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      date: json['date'],
      type: json['type'],
      amount: json['amount'],
      referral: json['referral'],
      comment: json['comment'],
      accountId: json['accountId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'type': type,
      'amount': amount,
      'comment': comment,
      'referral': referral,
      'accountId': accountId,
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
    if (responseJson['status'] == 'success') {
      print(responseJson);
      var account = Account.fromJson(responseJson['account']);
      account.notifications = (responseJson['notifications'] as List<dynamic>)
          .map((e) => Notification.fromJson(e))
          .toList();
      account.notifications = account.notifications!.reversed.toList();
      account.password = password;
      final prefs = await SharedPreferences.getInstance();
      print(account.toJson());
      await prefs.setString('account', jsonEncode(account.toJson()));
      print(Account.fromJson(responseJson['account']));
      return Account.fromJson(responseJson['account']);
    } else {
      print(responseJson['message']);
      return null;
    }
  } else {
    print('object');
    return defaultAccount;
  }
}

Future<Account> getAccountFromSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final accountJson = prefs.getString("account");
  print(accountJson);
  //print('accountJson');
  if (accountJson == null) {
    throw const FormatException('No Account');
  } else {
    final account = Account.fromJson(jsonDecode(accountJson));
    //print(account.notifications[0]);
    return account;
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
        //"accountId": id.toString(),
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

Future<bool> rewardUser(int reward) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? accountJson = prefs.getString("account");
    if (accountJson == null) {
      return false;
    }
    Account account = Account.fromJson(jsonDecode(accountJson));
    // Update the account's reward
    account.coinBalance = (account.coinBalance ?? 0) + reward;

    // Add a notification
    String notificationMessage = 'You just earned $reward from ads you watched';
    Notification newNotification = Notification(
      date: DateTime.now().toString(),
      type: 'coin',
      amount: reward,
      comment: notificationMessage,
      referral: '',
      accountId: account.id ?? 0,
    );

    // Add the new notification to the account's notifications list
    account.notifications ??= [];
    account.notifications!.insert(0, newNotification);

    // Update shared preferences with the modified account
    prefs.setString("account", jsonEncode(account.toJson()));

    // Now, proceed with sending the reward information to the server
    final response = await http.post(
      rewardUrl,
      body: jsonEncode({
        'username': account.username,
        'password': account.password,
        'reward': reward,
      }),
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      if (responseJson['status'] == 'success') {
        // Handle the success scenario
        return true;
      } else {
        // Handle the scenario where the status is not 'success'
        return false;
      }
    } else {
      // Handle the scenario where the HTTP request fails
      return false;
    }
  } catch (error) {
    // Handle any unexpected errors during the execution
    print('Error: $error');
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
        'accountName': bankname,
        'accountUname': bankUserName,
        'accountNumber': bankNumber,
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
