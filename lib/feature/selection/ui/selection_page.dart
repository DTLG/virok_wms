import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/selection/cubit/selection_cubit.dart';
import 'package:virok_wms/feature/selection/extension.dart';
import 'package:virok_wms/ui/widgets/went_wrong.dart';

import '../../../ui/widgets/alerts.dart';
import 'widgets/widgets.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SelectionCubit(),
        child: BlocListener<SelectionCubit, SelectionState>(
          listenWhen: (previous, current) {
            return current.status.isNotFound;
          },
          listener: (context, state) {
            if (state.status.isNotFound) {
              Alerts(
                      msg: state.noms.status.statusError,
                      context: context,
                      icon: state.noms.status == 0 ? false : true)
                  .showError();
            }
          },
          child: const SelectionView(),
        ));
  }
}

class SelectionView extends StatelessWidget {
  const SelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Завдання на відбір',
          style: TextStyle(fontSize: 18),
        ),
        actions: const [SendButton()],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () {
          return context.read<SelectionCubit>().getNoms();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            children: [
              const ContainerInput(),
              const SizedBox(
                height: 8,
              ),
              // const TableHead(),
              BlocBuilder<SelectionCubit, SelectionState>(
                builder: (context, state) {
                  final noms = state.noms.noms;
                  if (state.status.isInitial) {
                    context.read<SelectionCubit>().getNoms();
                  }
                  if (state.status.isSuccess || state.status.isNotFound) {
                    return CustomTable(
                      orders: [],
                    );
                  }

                  if (state.status.isFailure) {
                    return WentWrong(
                      onPressed: () {
                        context.read<SelectionCubit>().getNoms();
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
