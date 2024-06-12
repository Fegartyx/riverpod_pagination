import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pagination_riverpod/controller/paginator_controller.dart';
import 'package:pagination_riverpod/core/observer/observer.dart';

void main() {
  runApp(ProviderScope(observers: [Observer()], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riverpod Pagination',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _scrollController.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void listener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(paginatorControllerProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(paginatorControllerProvider);
    final notifier = ref.watch(paginatorControllerProvider.notifier.select(
      (value) => value.hasMore,
    ));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "List Product",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: data.when(
                  data: (prod) {
                    print(notifier);
                    return prod.match(
                      () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      (t) {
                        return t.fold(
                          (l) => l.fold(
                            (l) => Text(l),
                            (r) => Text(r),
                          ),
                          (r) => ListView.builder(
                            controller: _scrollController,
                            itemCount: r?.products.length ?? 0,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(r!.products[index].title),
                                    subtitle: Text(
                                        r.products[index].price.toString()),
                                    trailing: Image.network(
                                        r.products[index].thumbnail),
                                  ),
                                  if (index == r.limit - 1 && notifier)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: CircularProgressIndicator(),
                                    ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
