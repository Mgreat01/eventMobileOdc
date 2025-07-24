import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/loginControl.dart';
import '../composants/composants.dart';
import '../event/eventPage.dart';
import 'homeEventCtrl.dart';

class HomeEventPage extends ConsumerStatefulWidget {
  const HomeEventPage({super.key});

  @override
  ConsumerState<HomeEventPage> createState() => _HomeEventPageState();
}

class _HomeEventPageState extends ConsumerState<HomeEventPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final controller = ref.read(homeEventControllerProvider.notifier);
      controller.loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeEventControllerProvider);
    final loginState = ref.watch(loginControlProvider);
    final user = loginState.user;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(preferredSize: Size.fromHeight(100.0), child: navBar()),
      body: state.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF512DA8), Color(0xFF673AB7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " Bienvenue sur EventSpot",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Découvrez les meilleurs événements autour de vous dès maintenant.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "🕒 Derniers événements",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Text(
                  "Voir tout",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 270,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.latestEvents?.length ?? 0,
                itemBuilder: (context, index) {
                  final event = state.latestEvents![index];
                  return CarteEvenementHorizontal(event: event);
                },
              ),
            ),

            const SizedBox(height: 30),

            // --- Catégories ---
            const Text(
              "📂 categories",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.categories?.length ?? 0,
                itemBuilder: (context, index) {
                  final cat = state.categories?[index];
                  return cat != null
                      ? GestureDetector(
                    onTap: () {
                      if (user == null) {
                        context.go('/public/intro');
                      } else {
                        context.go('/event/${cat.id}');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Text(
                        cat.title ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  )
                      : const SizedBox.shrink();
                },
                separatorBuilder: (_, __) => const SizedBox(width: 10),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar1(selectedIndex: 1),
    );
  }
}
