import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/bloc/genai_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe/data/chat_content.dart';
import 'package:recipe/service_locator/service_locator.dart';
import 'package:recipe/widgets/chat_bubble_widget.dart';
import 'package:recipe/widgets/message_box_widget.dart';
import 'splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const FirebaseOptions options = FirebaseOptions(
    apiKey: 'AIzaSyDyVyta1Yt9A9pQQROGokaBUlk3x3tNi-Q',
    appId: '1:583812852104:android:8cd05843a4b1162ff6723d',
    messagingSenderId: '583812852104',
    projectId: 'recipe-e7e90',
    databaseURL: 'https://recipe-e7e90-default-rtdb.firebaseio.com',
  );
  await Firebase.initializeApp(options: options);
  ServiceLocator.instance.initialise();
  runApp(BlocProvider<GenaiBloc>(
    create: (context) => GenaiBloc(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.asset(
                'assets/image.jpeg', // Path to your avatar image
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: const Text("M STEAK"),
          backgroundColor: Colors.brown,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/background.jpeg', // path to your background image
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<GenaiBloc, GenaiState>(
                      builder: (context, state) {
                        final List<ChatContent> data = [];

                        if (state is MessagesUpdate) {
                          data.addAll(state.contents);
                        }

                        return ListView(
                          children: data.map((e) {
                            final bool isMine = e.sender == Sender.user;
                            return ChatBubble(
                              isMine: isMine,
                              photoUrl: null,
                              message: e.message,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  MessageBox(
                    onSendMessage: (value) {
                      context.read<GenaiBloc>().add(SendMessageEvent(value));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}