import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter_chat/features/chat/data/repositories/message_repository_impl.dart';
import 'package:flutter_chat/features/chat/domain/usecases/fetch_message_use_case.dart';
import 'package:flutter_chat/features/conversation/presentation/bloc/conversation_bloc.dart';
import 'package:flutter_chat/features/conversation/presentation/pages/message_page.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'core/bloc/theme_cubit.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'core/theme.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/chat/data/datasources/message_remote_datasource.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/conversation/data/datasources/conversation_remote_datasource.dart';
import 'features/conversation/data/repositories/conversations_repository_impl.dart';
import 'features/conversation/domain/usecases/fetch_conversation_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  final authRepository =
      AuthRepositoryImpl(authRemoteDatasource: AuthRemoteDatasource());
  final conversationRepository = ConversationsRepositoryImpl(
      remoteDataSource: ConversationRemoteDatasource());
  final messageRepository =
      MessageRepositoryImpl(messageRemoteDatasource: MessageRemoteDatasource());
  final fetchConversationUseCase =
      FetchConversationUseCase(conversationRepository);
  runApp(MyApp(
    authRepository: authRepository,
    fetchConversationUseCase: fetchConversationUseCase,
    messageRepository: messageRepository,
  ));
}

class MyApp extends StatelessWidget {
  final FetchConversationUseCase fetchConversationUseCase;
  final AuthRepositoryImpl authRepository;
  final MessageRepositoryImpl messageRepository;
  const MyApp({
    super.key,
    required this.authRepository,
    required this.fetchConversationUseCase,
    required this.messageRepository,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            registerUSeCase: RegisterUseCase(repository: authRepository),
            loginUSeCase: LoginUseCase(repository: authRepository),
          ),
        ),
        BlocProvider(
          create: (context) => ConversationBloc(
              fetchConversationUseCase: fetchConversationUseCase),
        ),
        BlocProvider(
          create: (context) => ChatBloc(
              fetchMessageUseCase:
                  FetchMessageUseCase(messageRepository: messageRepository)),
        ),
        // BlocProvider(
        //     create: (context) =>
        //         ChatBloc(fetchMessageUseCase: FetchMessageUseCase( , messageRepository: null))),

        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Chat',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state,
            home: SplashScreen(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/home': (context) => const ConversationPage(),
            },
          );
        },
      ),
    );
  }
}
