import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import '../check_basket_repository/models/basket_info.dart';
import '../cubit/check_basket_cubit.dart';

class ChackBasketPage extends StatelessWidget {
  const ChackBasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckBasketCubit(),
      child: const ChackBasketView(),
    );
  }
}

class ChackBasketView extends StatelessWidget {
  const ChackBasketView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Кошик'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 91, 79, 179)),
                    maximumSize: MaterialStatePropertyAll(Size.fromWidth(90)),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
                child: Text('Очистити',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white)),
                onPressed: () {
                  context.read<CheckBasketCubit>().clear();
                },
              ),
            )
          ],
        ),
        body: Column(
          children: [
            const BarcodeInput(),
            BlocBuilder<CheckBasketCubit, CheckBasketState>(
              builder: (context, state) {
                if (state.status.isSuccess) {
                  return state.basket.basket.isNotEmpty
                      ? BasketInfo(
                          basket: state.basket,
                        )
                      : const Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.error_outline_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Кошик не знайдено',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            )
                          ],
                        );
                }
                if (state.status.isFailure) {
                  return Expanded(
                    child: Center(
                        child: WentWrong(
                      errorDescription: state.errorMassage,
                      buttonTrue: false,
                    )),
                  );
                }
                if (state.status.isLoading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const Center();
              },
            )
          ],
        ),
      ),
    );
  }
}

class BarcodeInput extends StatefulWidget {
  const BarcodeInput({super.key});

  @override
  State<BarcodeInput> createState() => _BarcodeInputState();
}

class _BarcodeInputState extends State<BarcodeInput> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.select((CheckBasketCubit cubit) => cubit.state);
    state.status.isInitial ? controller.clear() : controller;
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        autofocus: cameraScaner ? false : true,
        onSubmitted: (value) {
          context.read<CheckBasketCubit>().getBasket(value);
        },
        decoration: InputDecoration(
          suffixIcon: cameraScaner
              ? CameraScanerButton(
                  scan: (value) {
                    context.read<CheckBasketCubit>().getBasket(value);
                  },
                )
              : null,
          hintText: 'Відскануйте штрихкод',
        ),
      ),
    );
  }
}

class BasketInfo extends StatelessWidget {
  const BasketInfo({super.key, required this.basket});

  final BasketData basket;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          title: Text(
            'Назва кошика:',
            style: theme.textTheme.titleLarge,
          ),
          trailing: Text(
            basket.basket,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        ListTile(
          title: Text(
            'Стіл:',
            style: theme.textTheme.titleLarge,
          ),
          trailing: Text(
            basket.table.name,
            style: theme.textTheme.headlineSmall,

          ),
        ),
        ListTile(
          title: Text(
            'Штрихкод столу:',
            style: theme.textTheme.titleLarge,
          ),
          trailing: Text(
            basket.table.barcode,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        ListTile(
          title: Text(
            'Номер документу:',
            style: theme.textTheme.titleLarge,
          ),
          trailing: Text(
            basket.docNumber,
            style: theme.textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }
}
