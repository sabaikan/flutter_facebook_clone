import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String name;
  final String firstName;
  final String lastName;
  final String emailOrPhone;
  final String birthday;
  final String gender;
  final String avatarUrl;
  final String coverUrl;
  final String bio;
  final int friendsCount;
  final int postsCount;
  final bool isLoggedIn;

  UserModel({
    this.name = 'Ok E',
    this.firstName = 'Ok',
    this.lastName = 'E',
    this.emailOrPhone = '',
    this.birthday = '24 September 2002',
    this.gender = 'Nonbiner',
    this.avatarUrl = '',
    this.coverUrl = '',
    this.bio = 'Teman yang memiliki kesamaan',
    this.friendsCount = 4300,
    this.postsCount = 1,
    this.isLoggedIn = true,
  });

  String get formattedFriendsCount {
    if (friendsCount >= 1000) {
      final k = (friendsCount / 1000).toStringAsFixed(1).replaceAll('.', ',');
      return '$k rb teman';
    }
    return '$friendsCount teman';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'firstName': firstName,
        'lastName': lastName,
        'emailOrPhone': emailOrPhone,
        'birthday': birthday,
        'gender': gender,
        'avatarUrl': avatarUrl,
        'coverUrl': coverUrl,
        'bio': bio,
        'friendsCount': friendsCount,
        'postsCount': postsCount,
        'isLoggedIn': isLoggedIn,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] ?? 'Ok E',
        firstName: json['firstName'] ?? 'Ok',
        lastName: json['lastName'] ?? 'E',
        emailOrPhone: json['emailOrPhone'] ?? '',
        birthday: json['birthday'] ?? '24 September 2002',
        gender: json['gender'] ?? 'Nonbiner',
        avatarUrl: json['avatarUrl'] ?? '',
        coverUrl: json['coverUrl'] ?? '',
        bio: json['bio'] ?? 'Teman yang memiliki kesamaan',
        friendsCount: json['friendsCount'] ?? 4300,
        postsCount: json['postsCount'] ?? 1,
        isLoggedIn: json['isLoggedIn'] ?? true,
      );

  UserModel copyWith({
    String? name,
    String? firstName,
    String? lastName,
    String? emailOrPhone,
    String? birthday,
    String? gender,
    String? avatarUrl,
    String? coverUrl,
    String? bio,
    int? friendsCount,
    int? postsCount,
    bool? isLoggedIn,
  }) {
    return UserModel(
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      bio: bio ?? this.bio,
      friendsCount: friendsCount ?? this.friendsCount,
      postsCount: postsCount ?? this.postsCount,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class AuthProvider extends ChangeNotifier {
  static final AuthProvider instance = AuthProvider();

  static AuthProvider of(BuildContext context, {bool listen = false}) {
    try {
      return Provider.of<AuthProvider>(context, listen: listen);
    } catch (_) {
      return AuthProvider.instance;
    }
  }

  static const _currentAccountKey = 'fb_current_account';
  static const _registeredAccountsKey = 'fb_registered_accounts';

  UserModel _currentUser = UserModel();
  List<Map<String, dynamic>> _registeredAccounts = [];

  UserModel get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser.isLoggedIn;
  List<Map<String, dynamic>> get registeredAccounts => List.unmodifiable(_registeredAccounts);

  Future<void> initStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawCurrent = prefs.getString(_currentAccountKey);
      if (rawCurrent != null && rawCurrent.isNotEmpty) {
        final Map<String, dynamic> map = jsonDecode(rawCurrent);
        _currentUser = UserModel.fromJson(map);
      }

      final rawAccounts = prefs.getString(_registeredAccountsKey);
      if (rawAccounts != null && rawAccounts.isNotEmpty) {
        final List<dynamic> list = jsonDecode(rawAccounts);
        _registeredAccounts = list.cast<Map<String, dynamic>>();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing AuthProvider storage: $e');
    }
  }

  Future<void> registerUser({
    required String name,
    String firstName = '',
    String lastName = '',
    String emailOrPhone = '',
    String birthday = '24 September 2002',
    String gender = 'Laki-laki',
    String password = '',
  }) async {
    final finalName = name.trim().isEmpty ? 'Pengguna Baru' : name.trim();

    _currentUser = UserModel(
      name: finalName,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      emailOrPhone: emailOrPhone.trim(),
      birthday: birthday,
      gender: gender,
      avatarUrl: '',
      coverUrl: '',
      bio: 'Baru bergabung di Facebook',
      friendsCount: 0,
      postsCount: 0,
      isLoggedIn: true,
    );

    // Save to list of registered accounts
    _registeredAccounts.removeWhere((acc) => acc['emailOrPhone'] == emailOrPhone && emailOrPhone.isNotEmpty);
    _registeredAccounts.add({
      'name': finalName,
      'firstName': firstName,
      'lastName': lastName,
      'emailOrPhone': emailOrPhone,
      'birthday': birthday,
      'gender': gender,
      'password': password,
      'avatarUrl': '',
      'coverUrl': '',
      'bio': 'Baru bergabung di Facebook',
      'friendsCount': 0,
      'postsCount': 0,
    });

    notifyListeners();
    await _persist();
  }

  Future<void> loginUser({
    required String name,
    String emailOrPhone = '',
    String gender = 'Laki-laki',
  }) async {
    // Check if this account was registered before
    Map<String, dynamic>? match;
    for (final acc in _registeredAccounts) {
      if ((emailOrPhone.isNotEmpty && acc['emailOrPhone'] == emailOrPhone) ||
          (acc['name'] == name && name.isNotEmpty)) {
        match = acc;
        break;
      }
    }

    if (match != null) {
      _currentUser = UserModel(
        name: match['name'] ?? name,
        firstName: match['firstName'] ?? '',
        lastName: match['lastName'] ?? '',
        emailOrPhone: match['emailOrPhone'] ?? emailOrPhone,
        birthday: match['birthday'] ?? '24 September 2002',
        gender: match['gender'] ?? gender,
        avatarUrl: match['avatarUrl'] ?? '',
        coverUrl: match['coverUrl'] ?? '',
        bio: match['bio'] ?? 'Baru bergabung di Facebook',
        friendsCount: match['friendsCount'] ?? 0,
        postsCount: match['postsCount'] ?? 0,
        isLoggedIn: true,
      );
    } else {
      final derivedName = name.trim().isNotEmpty
          ? name.trim()
          : (emailOrPhone.contains('@') ? emailOrPhone.split('@')[0] : (emailOrPhone.isNotEmpty ? emailOrPhone : 'intelecta.tech'));

      _currentUser = UserModel(
        name: derivedName,
        emailOrPhone: emailOrPhone,
        gender: gender,
        avatarUrl: derivedName == 'intelecta.tech' ? 'images/intelecta_avatar.jpg' : '',
        coverUrl: '',
        isLoggedIn: true,
      );
    }

    notifyListeners();
    await _persist();
  }

  Future<void> updateProfile({
    String? name,
    String? bio,
    String? gender,
    String? birthday,
  }) async {
    _currentUser = _currentUser.copyWith(
      name: name,
      bio: bio,
      gender: gender,
      birthday: birthday,
    );
    notifyListeners();
    await _persist();
  }

  Future<void> logout() async {
    _currentUser = _currentUser.copyWith(isLoggedIn: false);
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentAccountKey, jsonEncode(_currentUser.toJson()));
    } catch (_) {}
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentAccountKey, jsonEncode(_currentUser.toJson()));
      await prefs.setString(_registeredAccountsKey, jsonEncode(_registeredAccounts));
    } catch (e) {
      debugPrint('Error persisting AuthProvider data: $e');
    }
  }
}
