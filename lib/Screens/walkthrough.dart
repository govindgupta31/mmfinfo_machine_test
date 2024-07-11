import 'package:flutter/material.dart';

import 'login_screen.dart';

class WalkThrough extends StatelessWidget {
  PageController pageController = PageController(initialPage: 0);
  WalkThrough({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/panda.jpg",
                  height: 500,
                ),
                Padding(
                  padding: const EdgeInsets.all(10).copyWith(top: 80),
                  child: const Text(
                    "Lorem Ipsum is a site for raw text",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10).copyWith(top: 10),
                  child: const Text(
                    "Lorem Ipsum is a site for raw text",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      pageController.nextPage(
                          duration: const Duration(microseconds: 10),
                          curve: Curves.linear);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade900),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Image.asset(
                  "assets/hello.png",
                  filterQuality: FilterQuality.high,
                  height: 500,
                ),
                Padding(
                  padding: const EdgeInsets.all(10).copyWith(top: 80),
                  child: const Text(
                    "Lorem Ipsum is a site for raw text",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10).copyWith(top: 10),
                  child: const Text(
                    "Lorem Ipsum is a site for raw text",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade900),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
