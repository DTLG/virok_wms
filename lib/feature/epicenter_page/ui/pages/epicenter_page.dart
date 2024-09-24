import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/epicenter_page/cubit/epicenter_cubit.dart';
import 'package:virok_wms/feature/epicenter_page/ui/pages/noms_page.dart';
import 'package:virok_wms/feature/epicenter_page/ui/widget/table_widgets/row_element.dart';
import 'package:virok_wms/feature/epicenter_page/ui/widget/table_widgets/table_widgets.dart';

class EpicenterPage extends StatefulWidget {
  const EpicenterPage({super.key});

  @override
  _EpicenterPageState createState() => _EpicenterPageState();
}

class _EpicenterPageState extends State<EpicenterPage> {
  // Список для зберігання стану розгортання рядків
  List<bool> _expandedRows = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EpicenterCubit()..fetchDocuments(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Накладні Епіцентр'),
        ),
        body: BlocBuilder<EpicenterCubit, EpicenterState>(
          builder: (context, state) {
            if (state is EpicenterLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EpicenterError) {
              return Center(child: Text(state.message));
            } else if (state is EpicenterLoaded) {
              final documents = state.documents;

              // Ініціалізація списку розгортання
              if (_expandedRows.isEmpty) {
                _expandedRows = List<bool>.filled(documents.length, false);
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TableHeads(
                      children: [
                        const RowElement(flex: 1, value: 'Покупець'),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.folder_open_rounded),
                          color: Colors.transparent,
                        )
                      ],
                    ),
                    Expanded(
                      // Додаємо RefreshIndicator для pull-to-refresh
                      child: RefreshIndicator(
                        onRefresh: () async {
                          // Оновлюємо дані, викликавши метод fetchDocuments
                          context.read<EpicenterCubit>().fetchDocuments();
                        },
                        child: ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final doc = documents[index];
                            final bool isLast = index == documents.length - 1;

                            return Column(
                              children: [
                                TableElement(
                                  dataLength: documents.length,
                                  index: index,
                                  isExpanded: _expandedRows[index],
                                  rowElement: [
                                    RowElement(flex: 1, value: doc.customer),
                                    IconButton(
                                      onPressed: () async {
                                        if (await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NomsPage(
                                                        doc: doc,
                                                      )),
                                            ) ??
                                            false) {
                                          context
                                              .read<EpicenterCubit>()
                                              .fetchDocuments();
                                        }
                                      },
                                      icon:
                                          const Icon(Icons.folder_open_rounded),
                                    )
                                  ],
                                  onTap: () {
                                    setState(() {
                                      _expandedRows[index] =
                                          !_expandedRows[index];
                                    });
                                  },
                                  color: index % 2 == 0
                                      ? Colors.grey[200]
                                      : Colors.white,
                                ),
                                if (_expandedRows[index])
                                  GestureDetector(
                                    onTap: () async {
                                      // Відкриття сторінки NomsPage при натисканні на контейнер
                                      if (await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => NomsPage(
                                                      doc: doc,
                                                    )),
                                          ) ??
                                          false) {
                                        context
                                            .read<EpicenterCubit>()
                                            .fetchDocuments();
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        border: const Border(
                                          left: BorderSide(
                                              width: 1.0, color: Colors.black),
                                          right: BorderSide(
                                              width: 1.0, color: Colors.black),
                                        ),
                                        // Закруглені краї для контейнера, що випав
                                        borderRadius: isLast
                                            ? const BorderRadius.vertical(
                                                bottom: Radius.circular(10),
                                              )
                                            : BorderRadius.zero,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Номер: ${doc.number}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Дата: ${doc.date}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
