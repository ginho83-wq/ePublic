import 'package:flutter/material.dart';

import 'router.dart';

class EpublicApp extends StatelessWidget {
  const EpublicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Epublic',
      routerConfig: appRouter,
    );
  }
}
