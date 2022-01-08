import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//
import 'src/providers/audio_player_mode.dart';
import 'src/screens/music_main_screen.dart';
import 'src/themes/theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
  ));
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioPlayerMode()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      home: MusicMainScreen(),
      theme: miTema,
    );
  }
}
