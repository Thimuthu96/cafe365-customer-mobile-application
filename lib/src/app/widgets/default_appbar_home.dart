import 'package:flutter/material.dart';

class DefautAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const DefautAppBarHome({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AppBar(
        backgroundColor: const Color(0xfff9fafc),
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width / 3.8,
        leading: Image.asset(
          'assets/images/Logo.png',
          scale: 1,
        ),
        actions: [
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/search-ui");
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black54,
                  ))
            ],
          ),
          Column(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.black54,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
