import 'package:encurtalinkapp/core/themes/colors/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'home_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Short Links",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, child) {
          return Padding(
            padding: Dimens.of(context).edgeInsetsScreenSymmetric,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Input de URL
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: "Cole sua URL aqui",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Botão de encurtar
                FilledButton(
                  onPressed: () {
                    final url = _urlController.text.trim();
                    if (url.isNotEmpty) {
                      vm.createShortLink(url);
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Insira uma URL válida'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Encurtar"),
                ),
                const SizedBox(height: 24),
                // Lista de links ou shimmer
                Expanded(
                  child: ListenableBuilder(
                    listenable: vm,
                    builder: (context, _) {
                      if (vm.isLoading) {
                        return _buildShimmerList();
                      }

                      if (vm.shortLinks.isEmpty) {
                        return const Center(
                          child: Text("Nenhum link encurtado ainda."),
                        );
                      }

                      return ListView.builder(
                        itemCount: vm.shortLinks.length,
                        itemBuilder: (context, index) {
                          final item = vm.shortLinks[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(item.shortUrl),
                              subtitle: Text(item.originalUrl),
                              trailing: IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () async {
                                  await Clipboard.setData(ClipboardData(text: item.shortUrl));
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder:
          (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
    );
  }
}
