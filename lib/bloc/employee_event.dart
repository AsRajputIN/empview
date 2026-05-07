import 'package:equatable/equatable.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmployees extends EmployeeEvent {}

class AddEmployeeEvent extends EmployeeEvent {
  final Map<String, dynamic> employeeData;

  const AddEmployeeEvent(this.employeeData);

  @override
  List<Object?> get props => [employeeData];
}