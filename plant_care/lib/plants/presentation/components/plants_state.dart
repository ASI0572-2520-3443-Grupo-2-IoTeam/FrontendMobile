part of 'plants_cubit.dart';

abstract class PlantsState extends Equatable {
  const PlantsState();

  @override
  List<Object?> get props => [];
}

class PlantsInitial extends PlantsState {}

class PlantsLoading extends PlantsState {}

class PlantsLoaded extends PlantsState {
  final List<Plant> plants;

  const PlantsLoaded({required this.plants});

  @override
  List<Object?> get props => [plants];
}

class PlantsError extends PlantsState {
  final String message;

  const PlantsError({required this.message});

  @override
  List<Object?> get props => [message];
}
