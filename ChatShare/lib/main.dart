import 'package:chatshare/core/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatshare/core/socket_service.dart';
import 'package:chatshare/di_container.dart';
import 'package:chatshare/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:chatshare/core/theme.dart';
import 'package:chatshare/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chatshare/features/auth/presentation/pages/login_page.dart';
import 'package:chatshare/features/auth/presentation/pages/register_page.dart';
import 'package:chatshare/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:chatshare/features/conversation/presentation/bloc/conversations_bloc.dart';
import 'package:chatshare/features/conversation/presentation/pages/conversations_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final socketService = SocketService();
  await socketService.initSocket();

  // Setting up dependencies
  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            registerUseCase: sl(),
            loginUseCase: sl(),
          ),
        ),
        BlocProvider(
          create: (_) => ConversationsBloc(
            fetchConversationsUseCase: sl(),
          ),
        ),
        BlocProvider(
          create: (_) => ChatBloc(
            fetchMessagesUseCase: sl(),
            fetchDailyQuestionUseCase: sl(),
          ),
        ),
        BlocProvider(
          create: (_) => ContactsBloc(
            fetchContactsUseCase: sl(),
            addContactUseCase: sl(),
            checkOrCreateConversationUseCase: sl(),
            fetchRecentContactUseCase: sl(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Chat Share',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/conversationPage': (context) => ConversationsPage(),
        },
      ),
    );
  }
}
