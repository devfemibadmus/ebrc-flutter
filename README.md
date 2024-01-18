# EBRC App - Flutter Frontend Repository

## Table of Contents
1. [EBRC App - Flutter Frontend Repository](#ebrc-app---flutter-frontend-repository)
2. [Flutter](#flutter)
   - [Form Validation](#form-validation)
   - [Load JSON Data from API and Return JSON Data](#load-json-data-from-api-and-return-json-data)
   - [Integrating Google AdMob](#integrating-google-admob)
   - [Showing Ads](#showing-ads)

3. [TO-DO UPDATES](#to-do-updates)
4. [Contribution](#contribution)

  

This repository houses the UI/UX for the [ebrc-php](https://github.com/devfemibadmus/ebrc-php) server-side. This app is design basically to watch ads and make money. 

  **ADVANTAGES OF WATCHING ADS ON EBRC  AND MINIMIZING COSTS**

1.  **Monetize Your Time:**
    
    -   Users can turn their time into valuable rewards by watching ads on [App Name], creating an opportunity to earn money.
2.  **Receive Regular Updates:**
    
    -   Stay informed about the latest news, trends, and updates while watching ads, enhancing users' knowledge and awareness.
3.  **Entertainment Rewards:**
    
    -   Enjoy entertainment while earning rewards; users can watch ads and receive incentives for their time spent on the app.
4.  **Cost Minimization with Free Data Bonuses:**
    
    -   Users can maximize their benefits by utilizing free data bonuses from their Internet Service Provider (ISP) to watch ads, minimizing data costs.
5.  **Optimize Costs with Cheap Night Browsing:**
    
    -   Take advantage of cost-effective night browsing options to watch ads during off-peak hours, ensuring users maximize their rewards efficiently.
    
7.  **Reward Flexibility:**
    
    -   The reward system offers flexibility, allowing users to choose from a variety of options such as cash, gift cards, or discounts based on their preferences.
9.  **Seamless Redemption Process:**
    
    -   Enjoy a hassle-free redemption process within the app, making it easy for users to claim their rewards and enjoy the fruits of their engagement.
9.  **Diversify Earnings:**
    
    -   Users can diversify their earnings by engaging with different types of ads, ensuring a dynamic and rewarding experience.

[![Download on Google Play](https://cloud.githubusercontent.com/assets/5692567/10923351/6b688a92-8278-11e5-9973-8ffbf3c5cc52.png)](https://play.google.com/store/apps/details?id=com.blackstackhub.ebrc&hl=en-US&ah=WNIlRmUKRT1YYCEwY8gCKLCtK-k)

  

## Flutter (code review). 

 1. **form validation**  
    - (lib/authentication/signin_screen.dart)
```dart
@override
void initState() {
  super.initState();
  // Attach listeners for form validation
  _usernameController.addListener(_validateUsername);
  _passwordController.addListener(_validatePassword);
}

// Validate username in the form using async to check if username exist in saver
void _validateUsername() async {
  if (_usernameController.text.isEmpty) {
    // update error message if username is empty
    setState(() {
      _usernameError = 'Please enter your username';
    });
  } else if (_usernameController.text.length <= 4) {
    // update error message if username is too short
    setState(() {
      _usernameError = 'Username cannot be less than 5 characters';
    });
  } else {
    // Clear username error if validation passes
    setState(() {
      _usernameError = null;
    });
  }
}

// Validate password in the form on input
void _validatePassword() {
  String password = _passwordController.text;
  RegExp number = RegExp(r'[0-9]');
  RegExp symbol = RegExp(r'[!@#\$%^&*]');

  if (password.length <= 8) {
    // update error message if password is too short
    setState(() {
      _passwordError = 'Password must be at least 8 characters';
    });
  } else if (!number.hasMatch(password)) {
    // update error message if password doesn't contain a number
    setState(() {
      _passwordError = 'Invalid Password';
    });
  } else if (!symbol.hasMatch(password)) {
    // update error message if password doesn't contain a symbol
    return setState(() {
      _passwordError = 'Invalid Password';
    });
  } else {
    // Clear password error if validation passes
    setState(() {
      _passwordError = null;
    });
  }
}
```

 2. **Load Json data from api and retun Json data**  
    - (lib/constants/database.dart)
 
 ```dart
   
// Class Declaration and its instance variables to structure data and its type
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

  // Instance variables constructor
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

  // Factory Method (`fromJson`) to load from JSON data and create an instance
  factory Account.fromJson(Map<String, dynamic> json) {
    List<Notification> notificationsList = [];

    if (json['notifications'] != null) {
      var list = json['notifications'] as List;
      notificationsList =
          list.map((i) => Notification.fromJson(i)).toList();
    }

    return Account(
      id: json['id'],
      email: json['email'],
      referral: json['referral'],
      username: json['username'],
      password: json['password'],
      accountName: json['accountName'],
      accountUname: json['accountUname'],
      accountEditable: json['accountEditable'] == 1 || json['accountEditable'] == true,
      accountNumber: json['accountNumber'],
      earnBalance: json['earnBalance'],
      accountBalance: json['accountBalance'],
      notifications: notificationsList,
      coinBalance: json['coinBalance'],
      pendingCashout: json['pendingCashout'] == 1 || json['pendingCashout'] == true,
    );
  }

  // Factory Method (`toJson`) to convert instance to JSON data
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

// Notification class to store data and map to the Account class
class Notification {
  String date;
  String type;
  int amount;
  String comment;
  String referral;
  int accountId;

  Notification({
    required this.date,
    required this.type,
    required this.amount,
    required this.comment,
    required this.referral,
    required this.accountId,
  });

  // Factory Method (`fromJson`) to load instance from JSON data
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

  // Map from JSON to load instance from JSON data
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


// for exmaple now we can do
myJsonData = {"id":1,"email":"test@gmail.com","referral":"nobody","username":"test1","password":"hellotest1$","accountEditable":true,"accountUname":null,"
accountName":null,"accountNumber":0,"accountBalance":0,"notifications":[],"coinBalance":0,"earnBalance":0,"rewardAds":false,"pendingCashout":
false}

newaccount = Account.fromJson(myJsonData);
// now we can use account in our class like 
// newaccount.id unlike reading for all in each json

// below is sample signin that fetch data from the ebrc api(php) and load to the Class to have an instance

// future
Future<Account?> signIn(String username, String password) async {
  // Send a POST request to the signInUrl with the provided username and password
  // signInUrl is already define as https://ebrc.blackstackhub/signin
  final response = await http.post(
    signInUrl,
    body: jsonEncode(
      {'username': username, 'password': password},
    ),
  );

  // Check if the response status code is 200 (OK)
  if (response.statusCode == 200) {
    // Parse the JSON response
    var responseJson = jsonDecode(response.body);

    // Check if the status in the response is 'success'
    if (responseJson['status'] == 'success') {
      // Create an Account object from the 'account' field in the response
      var account = Account.fromJson(responseJson['account']);

      // Map and reverse the 'notifications' field in the response
      account.notifications = (responseJson['notifications'] as List<dynamic>)
          .map((e) => Notification.fromJson(e))
          .toList();
      account.notifications = account.notifications!.reversed.toList();

      // Set the password in the Account object (assuming it's needed)
      account.password = password;

      // Store the Account object in SharedPreferences
      // store for fast action like user wanna update its password u can quickly verify password, user account loaded from sharepreferences instead of api
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('account', jsonEncode(account.toJson()));

      // Log the created Account object and return it
      print(account.toJson());
      print(Account.fromJson(responseJson['account']));
      return Account.fromJson(responseJson['account']);
    } else {
      // Log and return null if the sign-in was not successful
      print(responseJson['message']);
      return null;
    }
  } else {
    // Log and return a default account if there was an error in the HTTP request
    print('object');
    return defaultAccount;
  }
}

// here is the sample default account defined
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

 ```
 
 3. **Integrating Google AdMob**  
    - (lib/constants/admob.dart)
 ```dart
 // Import necessary dependencies and files
import 'package:ebrc/constants/variables.dart';
import 'package:ebrc/constants/database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Class for managing AdMob functionalities
class AdmobModel with ChangeNotifier {
  // Attributes to hold references to InterstitialAd and RewardedAd
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;

  // Show a rewarded ad to the user
  void showRewardedAd() {
    // Check if rewardedAd is not loaded, then load it
    if (rewardedAd == null) {
      loadRewardedAd();
    } else {
      // If loaded, show the ad and set up reward callback
      rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          
          // this function is in the varibale.dart code where i define action to reward user
          rewardUser(int.parse(reward.amount.toString()));
        },
      );
    }
  }

  // Show an interstitial ad to the user
  void showInterstitialAd() {
    // Check if interstitialAd is not loaded, then load it
    if (interstitialAd == null) {
      loadInterstitialAd();
    } else {
      // If loaded, show the ad
      interstitialAd!.show();
    }
  }

  // Load a rewarded ad
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: GoogleAdmob.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          // Set up callback for ad dismissal and dispose of rewardedAd
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              rewardedAd = null;
              // After rewarded ad is dismissed, show interstitial ad
              showInterstitialAd();
            },
          );
          rewardedAd = ad;
        },
        onAdFailedToLoad: (err) {
          // Handle failure to load rewarded ad
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  // Load an interstitial ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: GoogleAdmob.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // Set up callback for ad dismissal and dispose of interstitialAd
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              interstitialAd = null;
            },
          );
          interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          // Handle failure to load interstitial ad
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  // Dispose of InterstitialAd and RewardedAd objects
  @override
  void dispose() {
    // Dispose an InterstitialAd object
    interstitialAd!.dispose();
    
    // Dispose a RewardedAd object
    rewardedAd!.dispose();
    
    super.dispose();
  }
}

 ```
 
 3. **Showing Ads**  
    - (lib/tasks/ads.dart)
```dart
// Import necessary dependencies and files
import 'package:ebrc/constants/admob.dart';
import 'package:ebrc/constants/variables.dart';
import 'package:ebrc/constants/database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

// Widget to display Ads page
class Ads extends StatefulWidget {
  const Ads({Key? key}) : super(key: key);

  @override
  State<Ads> createState() => AdsState();
}

// State class for Ads widget
class AdsState extends State<Ads> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

    // Load a banner ad
    BannerAd(
      adUnitId: GoogleAdmob.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdClosed: (ad) {
          ad.dispose();
          _bannerAd = null;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Watch ads as a task",
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ads Page"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display the banner ad if available
              if (_bannerAd != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: 72.0,
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              const SizedBox(height: 10),
              // Button to show interstitial ad
              ElevatedButton(
                onPressed: () {
                  if (context.read<AdmobModel>().interstitialAd == null) {
                    context.read<AdmobModel>().loadInterstitialAd();
                  } else {
                    context.read<AdmobModel>().interstitialAd!.show().then(
                      (value) {
                        // Reward the user after the interstitial ad is shown
                        rewardUser(int.parse('5'));
                      },
                    );
                  }
                },
                child: const Text("Show Interstitial Ad"),
              ),
              const SizedBox(height: 10),
              // Button to show rewarded ad
              ElevatedButton(
                onPressed: () {
                  if (context.read<AdmobModel>().rewardedAd == null) {
                    context.read<AdmobModel>().loadRewardedAd();
                  } else {
                    context.read<AdmobModel>().rewardedAd!.show(
                      onUserEarnedReward: (ad, reward) {
                        // Reward the user based on the earned reward
                        rewardUser(int.parse(reward.amount.toString()));
                      },
                    );
                  }
                },
                child: const Text("Show Rewarded Ad"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

![working terminal](readme/Screenshot%20(1099).png?raw=true)

[![Download on Google Play](https://cloud.githubusercontent.com/assets/5692567/10923351/6b688a92-8278-11e5-9973-8ffbf3c5cc52.png)](https://play.google.com/store/apps/details?id=com.blackstackhub.ebrc&hl=en-US&ah=WNIlRmUKRT1YYCEwY8gCKLCtK-k)

  
  ## TO-DO UPDATES
  
 - settings updated successfully make input not editable immediately not util user comes back
 - settings password update doesn't alert


## Features

Fetch, stream, and render data from given API. 
Minimize data.
Validate form.
Serves ads 😂😂😂


## Contribution

Whether you have updates, corrections, or any valuable input, feel free to open an issue or submit a pull request.

This app is designed to be simple, and I welcome any suggestions or improvements to enhance its functionality. Your feedback helps make this project better for everyone.

If you encounter any issues or have ideas for improvements, please don't hesitate to share them.

