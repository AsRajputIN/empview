import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../repo/employee_repo.dart';
import '../viewmodels/employee_viewmodel.dart';
import '../models/employee_model.dart';
import 'employee_add_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(
        repository: EmployeeRepository(),
      )..add(FetchEmployees()),
      child: const EmployeeListPage(),
    );
  }
}

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = EmployeeViewModel(
      employeeBloc: BlocProvider.of<EmployeeBloc>(context),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.fetchEmployees(),
          ),
        ],
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(

        builder: (context, state) {
          if (viewModel.isLoading(state)) {
            return const Center(child: CircularProgressIndicator());
          }

          final error = viewModel.getError(state);
          if (error != null) {
            return Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchEmployees(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final employees = viewModel.getEmployees(state);
          if (employees.isEmpty) {
            return const Center(
              child: Text('No employees found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              final shouldHighlight = employee.shouldHighlight;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                color: shouldHighlight ? Colors.green[50] : Colors.white,
                child: Container(
                  decoration: shouldHighlight
                      ? BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  )
                      : null,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: shouldHighlight ? Colors.green : Colors.blue,
                      child: Text(
                        employee.name[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      employee.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: shouldHighlight ? Colors.green[800] : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Position: ${employee.position}'),
                        Text('Email: ${employee.email}'),
                        Text(
                          'Joining Date: ${_formatDate(employee.joiningDate)}',
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: employee.isActive ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                employee.isActive ? 'Active' : 'Inactive',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 8,
                            //     vertical: 2,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     color: Colors.grey[300],
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            //   child: Text(
                            //     '${employee.yearsOfService} years',
                            //     style: const TextStyle(fontSize: 12),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    trailing: shouldHighlight
                        ? const Icon(Icons.verified, color: Colors.green)
                        : null,
                    isThreeLine: true,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          // Get the existing bloc
          final employeeBloc = BlocProvider.of<EmployeeBloc>(context);

          // Pass the bloc to the add screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeAddScreen(employeeBloc: employeeBloc),
            ),
          );

          // Refresh the list if employee was added
          if (result == true) {
            viewModel.fetchEmployees();
          }
        },
        child: const Icon(Icons.add,color: Colors.blueAccent,),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }


}