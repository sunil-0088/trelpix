import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trelpix/presentation/pages/search_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.onPrimary,
            alignment: Alignment.bottomLeft,
            child: Text(
              'TrelPix',
              style: GoogleFonts.pacifico(fontSize: 35, color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(
              Platform.isIOS ? CupertinoIcons.home : Icons.home,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Platform.isIOS ? CupertinoIcons.bookmark : Icons.bookmark,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text('Bookmark'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Platform.isIOS ? CupertinoIcons.search : Icons.search,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text('Search'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
