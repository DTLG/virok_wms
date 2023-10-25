import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/check_basket/check_basket_repository/models/basket_info.dart';
import 'package:virok_wms/feature/check_basket/cubit/check_basket_cubit.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Кошик'),
      ),
      body: Column(
        children: [
          BarcodeInput(),
          BlocBuilder<CheckBasketCubit, CheckBasketState>(
            builder: (context, state) {
              if (state.status.isSuccess) {
                return BasketInfo(
                  basket: state.basket,
                );
              }
              return Center();
            },
          )
        ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        autofocus: true,
        onSubmitted: (value) {
          context.read<CheckBasketCubit>().getBasket(value);
        },
        decoration: const InputDecoration(
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
          title: Text('Назва кошика:',style: theme.textTheme.headlineSmall,),
          trailing: Text(basket.basket,style: theme.textTheme.headlineMedium!.copyWith(color: Colors.black),),
        ),
        ListTile(
          title: Text('Стіл:',style: theme.textTheme.headlineSmall,),
          trailing: Text(basket.table.name,style: theme.textTheme.headlineMedium!.copyWith(color: Colors.black),),
        ),
        ListTile(
          title: Text('Штрихкод столу:',style: theme.textTheme.headlineSmall,),
          trailing: Text(basket.table.barcode, style: theme.textTheme.headlineMedium!.copyWith(color: Colors.black),),
        ),
      ],
    );
  }
}
