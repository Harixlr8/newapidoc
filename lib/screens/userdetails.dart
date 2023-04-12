import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDetailsPage extends StatefulWidget {
  final int id;

  const UserDetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  // final List<dynamic> _users = [];

  bool _isLoading = false;

  Future<void> _getUserDetails() async {
   

    final http.Response response = await http.get(
      Uri.parse('https://reqres.in/api/users/${widget.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
      print('No error');
    } else {
      throw Exception('Failed to load user details');

      // print('error');
      // // ignore: use_build_context_synchronously
      // showDialog(
      //   context: context,
      //   builder: (_) => AlertDialog(
      //     title: const Text('Error'),
      //     content: const Text('Some problem with the API'),
      //     actions: <Widget>[
      //       TextButton(
      //         onPressed: () => Navigator.pop(context),
      //         child: const Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
    }
  }

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.amber,
    );
  }
}
