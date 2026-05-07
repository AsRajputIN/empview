import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../models/employee_model.dart';

class EmployeeViewModel {
  final EmployeeBloc employeeBloc;

  EmployeeViewModel({required this.employeeBloc});

  Stream<EmployeeState> get stateStream => employeeBloc.stream;

  void fetchEmployees() {
    employeeBloc.add(FetchEmployees());
  }

  List<Employee> getEmployees(EmployeeState state) {
    if (state is EmployeeLoaded) {
      return state.employees;
    }
    return [];
  }

  bool isLoading(EmployeeState state) {
    return state is EmployeeLoading;
  }

  String? getError(EmployeeState state) {
    if (state is EmployeeError) {
      return state.message;
    }
    return null;
  }
}