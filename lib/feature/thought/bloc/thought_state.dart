part of 'thought_bloc.dart';

@immutable
sealed class ThoughtState {}

final class ThoughtInitial extends ThoughtState {}
final class ThoughtSuccess extends ThoughtState {
  final List<dynamic> data;
  ThoughtSuccess(this.data);
}
final class ThoughtError extends ThoughtState {
  final String msg;
  ThoughtError(this.msg);
}
