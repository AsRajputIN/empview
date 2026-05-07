import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/employee_repo.dart';
import 'employee_event.dart';
import 'employee_state.dart';
import '../models/employee_model.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc({required this.repository}) : super(EmployeeInitial()) {
    on<FetchEmployees>(_onFetchEmployees);
    on<AddEmployeeEvent>(_onAddEmployee);
  }

  Future<void> _onFetchEmployees(
      FetchEmployees event,
      Emitter<EmployeeState> emit,
      ) async {
    emit(EmployeeLoading());
    try {
      final employees = await repository.fetchEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onAddEmployee(
      AddEmployeeEvent event,
      Emitter<EmployeeState> emit,
      ) async {
    final currentState = state;
    if (currentState is EmployeeLoaded) {
      try {
        final newEmployee = await repository.addEmployee(
          Employee(
            id: 0,
            name: event.employeeData['name'],
            email: event.employeeData['email'],
            position: event.employeeData['position'],
            joiningDate: DateTime.parse(event.employeeData['joining_date']),
            isActive: event.employeeData['is_active'],
            yearsOfService: event.employeeData['years_of_service'],
          ),
        );

        final updatedEmployees = List<Employee>.from(currentState.employees)
          ..add(newEmployee);
        emit(EmployeeLoaded(updatedEmployees));
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    }
  }
}