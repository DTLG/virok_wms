import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';
import '../cubit/check_basket_cubit.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();

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
          title: const Text('Корзини'),
          actions: [
            BlocBuilder<CheckBasketCubit, CheckBasketState>(
              builder: (context, state) {
                return state.basketOperation
                    ? IconButton(
                        onPressed: () {
                          createNewBasket(context);
                        },
                        icon: const Icon(Icons.add))
                    : const SizedBox();
              },
            )
          ],
        ),
        body: BlocConsumer<CheckBasketCubit, CheckBasketState>(
          listener: (context, state) {
            if (state.status.isNotFound) {
              Alerts(msg: state.errorMassage, context: context).showError();
            }
          },
          builder: (context, state) {
            if (state.status.isInitial) {
              context.read<CheckBasketCubit>().getStateBasketOperations();
              context.read<CheckBasketCubit>().getBaskets();
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.status.isFailure) {
              () async {
                await _audioPlayer.play(AssetSource('sounds/error_sound.mp3'));
              };
              return Center(
                child: WentWrong(
                  errorDescription: state.errorMassage,
                  onPressed: () {
                    context.read<CheckBasketCubit>().getBaskets();
                  },
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CheckBasketCubit>().getBaskets();
              },
              child: const Column(
                children: [BasketSearchField(), ListBaskets()],
              ),
            );
          },
        ),
      ),
    );
  }
}

class BasketSearchField extends StatefulWidget {
  const BasketSearchField({super.key});

  @override
  State<BasketSearchField> createState() => _BasketSearchFieldState();
}

class _BasketSearchFieldState extends State<BasketSearchField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          context.read<CheckBasketCubit>().searchBasket(value);
        },
        decoration: const InputDecoration(
          hintText: 'Введіть номер',
        ),
      ),
    );
  }
}

class ListBaskets extends StatelessWidget {
  const ListBaskets({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckBasketCubit, CheckBasketState>(
      builder: (context, state) {
        return Expanded(
          child: ListView.separated(
            itemCount: state.filterdBaskets.baskets.length,
            itemBuilder: (context, index) {
              final basket = state.filterdBaskets.baskets[index];
              return ListTile(
                onTap: () {
                  context
                      .read<CheckBasketCubit>()
                      .getBasket(state.filterdBaskets.baskets[index].barcode);
                  basketInfoDialog(context);
                },
                title: Text(basket.name),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              height: 0,
              indent: 15,
              endIndent: 15,
            ),
          ),
        );
      },
    );
  }
}

basketInfoDialog(BuildContext context) {
  final theme = Theme.of(context);
  Widget infoItem({required String title, required String trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.w400),
          ),
          Text(
            trailing,
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
            value: context.read<CheckBasketCubit>(),
            child: BlocBuilder<CheckBasketCubit, CheckBasketState>(
              builder: (context, state) {
                return AlertDialog(
                  iconPadding: EdgeInsets.zero,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  actionsPadding: const EdgeInsets.all(5),
                  actionsAlignment: MainAxisAlignment.center,
                  icon: DialogHead(
                      title: 'Корзина',
                      textStyle: theme.textTheme.titleLarge,
                      onPressed: () => Navigator.pop(context)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      infoItem(title: 'Корзина:', trailing: state.basket.name),
                      infoItem(
                          title: 'Стіл:', trailing: state.basket.table.name),
                      infoItem(
                          title: '№ документу:',
                          trailing: state.basket.docNumber),
                    ],
                  ),
                  actions: [
                    state.basketOperation
                        ? ElevatedButton(
                            onPressed: () {
                              context.read<CheckBasketCubit>().printBasket();
                              Navigator.pop(context);
                            },
                            child: const Text('Друк'))
                        : const SizedBox()
                  ],
                );
              },
            ),
          ));
}

createNewBasket(BuildContext context) {
  final themeManager = AdaptiveTheme.of(context);

  final theme = Theme.of(context);
  showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
            value: context.read<CheckBasketCubit>(),
            child: AlertDialog(
              iconPadding: EdgeInsets.zero,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              actionsPadding: const EdgeInsets.all(5),
              actionsAlignment: MainAxisAlignment.center,
              icon: DialogHead(
                  title: 'Нова корзина',
                  textStyle: theme.textTheme.titleLarge,
                  onPressed: () => Navigator.pop(context)),
              content: BlocBuilder<CheckBasketCubit, CheckBasketState>(
                builder: (context, state) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      state.basketType.isBasket ? 'Корзина' : 'Візок',
                      style: theme.textTheme.titleMedium!,
                    ),
                    trailing: Switch(
                        value: state.basketType.isBasket ? false : true,
                        onChanged: (value) {
                          context.read<CheckBasketCubit>().changeBusketType();
                        }),
                  );
                },
              ),
              actions: [
                BlocBuilder<CheckBasketCubit, CheckBasketState>(
                  builder: (context, state) {
                    return ElevatedButton(
                        onPressed: () async {
                          final res = await context
                              .read<CheckBasketCubit>()
                              .addBasket();
                          if (context.mounted) {
                            Navigator.pop(context);
                            if (res.isEmpty) return;

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                    duration: const Duration(seconds: 5),
                                    elevation: 5,
                                    content: Center(
                                        child: Text(
                                      'Створено - $res',
                                      style: theme.textTheme.titleSmall!
                                          .copyWith(
                                              color: themeManager.mode.isDark
                                                  ? Colors.black
                                                  : Colors.white),
                                    ))),
                              );
                          }
                        },
                        child: const Text('Створити'));
                  },
                )
              ],
            ),
          ));
}
