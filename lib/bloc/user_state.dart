import 'package:equatable/equatable.dart';
import 'package:stepik_12_5_2/models/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object?> get props => [];
}

class UserEmptyState extends UserState {}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  final List<User> users;
  const UserLoadedState({required this.users});

  @override
  List<Object?> get props => [users];
}

class UserErrorState extends UserState {
  final String message;
  const UserErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}