import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmfinfotech_machinetest/Screens/login_screen.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/home_cubit.dart';
import '../Provider/home_state.dart';
import 'package:http/http.dart' as http;

import '../Utils/dimensions.dart';
import 'Components/snackbar.dart';

class HomePage extends StatefulWidget {
  final String fullName;
  final String email;
  final String profileUrl;
  const HomePage({
    super.key,
    required this.email,
    required this.profileUrl,
    required this.fullName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool active = false;
  RefreshController refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 80),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    widget.profileUrl,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fullName,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Text(widget.email,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    logout();
                  },
                  child: const Icon(
                    Icons.login_sharp,
                    color: Colors.grey,
                    size: 30,
                  )),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) => HomeCubit(),
          child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
            // print("SSSSS   " + state.data.toString());
            return state.loading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color(0XFFD8F1FE),
                          Color(0x00ffffff),
                          Color(0XFFD8F1FE),
                        ],
                      ),
                    ),
                    child: SmartRefresher(
                      onRefresh: () async {
                        await BlocProvider.of<HomeCubit>(context).onRefresh();
                        refreshController.refreshCompleted();
                      },
                      enablePullUp: true,
                      onLoading: () async {
                        await BlocProvider.of<HomeCubit>(context).onpullup();
                        refreshController.loadComplete();
                      },
                      controller: refreshController,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "User List",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                  Container(
                                    width: 94,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 6),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.transparent),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            active = true;
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.list_alt_outlined,
                                            size: 24,
                                            color: active
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              active = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.grid_view_outlined,
                                            size: 24,
                                            color: !active
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              active
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: state.data.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${state.data[index].firstName.toString()} ${state.data[index].lastName.toString()}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${state.data[index].email.toString()} ${state.data[index].phoneNo.toString()}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: Colors.blue),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "View Profile",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.only(top: 20),
                                      itemCount: state.data.length,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 20,
                                              crossAxisSpacing: 20),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 16),
                                          height: 144,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.data[index].firstName
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                state.data[index].lastName
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                state.data[index].email
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                state.data[index].phoneNo
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: Colors.blue),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "View Profile",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          }),
        ),
      ),
    );
  }

  logout() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String token = sh.getString("token")!;
    var res = await http.get(
        Uri.parse("https://mmfinfotech.co/machine_test/api/logout"),
        headers: {"Authorization": "Bearer $token"});
    var json = jsonDecode(res.body);
    if (json["status"]) {
      showCustomSnackBar(context,
          message: "Successfully Logged out", isError: false);
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      showCustomSnackBar(context,
          message: "Something went wrong", isError: false);
    }
  }
}
