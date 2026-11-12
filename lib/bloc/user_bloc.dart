import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import 'package:stepik_12_5_2/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserEmptyState()) {
    on<LoadUsersEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        final users = await userRepository.fetchUsers();
        emit(UserLoadedState(users: users));
      } catch (e) {
        emit(const UserErrorState(
          message: 'Нет соединения с интернетом!\nОшибка при загрузке пользователей',
        ));
      }
    });

    on<ClearUsersEvent>((event, emit) {
      emit(UserEmptyState());
    });
  }
}