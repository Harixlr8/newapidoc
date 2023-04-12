import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newapidoc/screens/userdetails.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<dynamic> _users = [];
  int _currentPage = 1;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  late int totalPages;

  Future<bool> _getUsers({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
    } else {
      if (_currentPage >= totalPages) {
        refreshController.loadNoData();
        return true;
      }
    }

    final http.Response response = await http.get(
      Uri.parse('https://reqres.in/api/users?page=$_currentPage&per_page=10'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> users = responseData['data'];

      totalPages = responseData['total'];
      if (isRefresh) {
        _users.addAll(users);
      } else {}
      _currentPage++;

      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _getUsers();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          onRefresh: () async {
            final result = await _getUsers(isRefresh: true);
            if (result) {
              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            final result = await _getUsers();
            if (result) {
              refreshController.loadComplete();
            } else {
              refreshController.loadFailed();
            }
          },
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.black,
              );
            },
            itemCount: _users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = _users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['avatar']),
                ),
                title: Text('${user['first_name']} ${user['last_name']}'),
                subtitle: Text(user['email']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserDetailsPage(
                        id: user['id'],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
