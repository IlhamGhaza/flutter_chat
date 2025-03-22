import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'core/bloc/theme_cubit.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'core/theme.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/pages/splash_page.dart';
import 'features/chat/data/datasources/message_remote_datasource.dart';
import 'features/chat/data/repositories/message_repository_impl.dart';
import 'features/chat/domain/usecases/fetch_message_use_case.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/contact/data/datasources/contact_remote_datasource.dart';
import 'features/contact/data/repositories/contact_repository_impl.dart';
import 'features/contact/domain/usecases/add_contact_usecase.dart';
import 'features/contact/domain/usecases/delete_contact_usecase.dart';
import 'features/contact/domain/usecases/fetch_contact_usecase.dart';
import 'features/contact/presentation/bloc/contact_bloc.dart';
import 'features/conversation/data/datasources/conversation_remote_datasource.dart';
import 'features/conversation/data/repositories/conversations_repository_impl.dart';
import 'features/conversation/domain/usecases/fetch_conversation_use_case.dart';
import 'features/conversation/presentation/bloc/conversation_bloc.dart';
import 'features/conversation/presentation/pages/message_page.dart';

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
  final contactRepository = ContactRepositoryImpl(
      contactRemoteDatasource: ContactRemoteDatasource());
  
  runApp(MyApp(
    authRepository: authRepository,
    fetchConversationUseCase: fetchConversationUseCase,
    messageRepository: messageRepository,
    contactRepository: contactRepository,
  ));
}

class MyApp extends StatelessWidget {
  final FetchConversationUseCase fetchConversationUseCase;
  final AuthRepositoryImpl authRepository;
  final MessageRepositoryImpl messageRepository;
  final ContactRepositoryImpl contactRepository;
  const MyApp({
    super.key,
    required this.authRepository,
    required this.fetchConversationUseCase,
    required this.messageRepository,
    required this.contactRepository,
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
        //contact bloc
        BlocProvider(
          create: (context) => ContactBloc(
            FetchContactUseCase(contactRepository: contactRepository),
            AddContactUseCase(contactRepository: contactRepository),
            DeleteContactUseCase(contactRepository: contactRepository),
          ),
        ),
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
