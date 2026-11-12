import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepik_12_5_2/repositories/user_repository.dart';
import 'package:stepik_12_5_2/bloc/user_bloc.dart';
import 'package:stepik_12_5_2/bloc/user_event.dart';
import 'package:stepik_12_5_2/bloc/user_state.dart';
import 'package:stepik_12_5_2/models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Предоставляем Repository через RepositoryProvider
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User List App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const UserScreen(),
      ),
    );
  }
}

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Создаем Bloc и передаем ему репозиторий
      create: (context) => UserBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Список пользователей (в сети)'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            // Панель с кнопками управления
            const ActionButtonsBar(),
            const SizedBox(height: 16),
            const Divider(height: 1),
            // Основной контент, меняющийся в зависимости от стейта
            Expanded(
              child: BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UserEmptyState) {
                    return const Center(
                      child: Text(
                        'Список пуст. Нажмите кнопку загрузки.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (state is UserLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is UserLoadedState) {
                    return UserListView(users: state.users);
                  }
                  if (state is UserErrorState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off, size: 64, color: Colors.redAccent),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Виджет кнопок Загрузить / Очистить
class ActionButtonsBar extends StatelessWidget {
  const ActionButtonsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              BlocProvider.of<UserBloc>(context).add(LoadUsersEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.download),
            label: const Text('Загрузить'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              BlocProvider.of<UserBloc>(context).add(ClearUsersEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.clear),
            label: const Text('Очистить'),
          ),
        ],
      ),
    );
  }
}

// Виджет списка пользователей
class UserListView extends StatelessWidget {
  final List<User> users;

  const UserListView({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text('${user.id}'),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('Email: ${user.email}'),
              Text('Телефон: ${user.phone}'),
            ],
          ),
          isThreeLine: true,
        );
      },
    );
  }
}