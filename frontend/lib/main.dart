import 'package:fe_simple/domain/providers/blog_post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/pages/home_page.dart';
import 'presentation/pages/create_post_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlogPostProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blog Tracker',
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/create': (context) => const CreatePostPage(),
        },
      ),
    );
  }
}
