import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../auth/loginControl.dart';
import '../composants/composants.dart';
import 'homeEventCtrl.dart';

class HomeEventPage extends ConsumerStatefulWidget {
  const HomeEventPage({super.key});

  @override
  ConsumerState<HomeEventPage> createState() => _HomeEventPageState();
}

class _HomeEventPageState extends ConsumerState<HomeEventPage> {
  final List<String> _bannerImages = [
    "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&w=1350&q=80",
    "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&w=1350&q=80",
    "https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=1350&q=80",
  ];

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

    if (user?.token != null && (state.favEvents?.isEmpty ?? true)) {
      ref
          .read(homeEventControllerProvider.notifier)
          .loadFavoriteEvents(user!.token!);
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: navBar(),
      ),
      body: state.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(),
            const SizedBox(height: 20),
            _buildSectionHeader(
              context,
              "🕒 Derniers événements",
              onSeeAll: () => context.go('/app/events'),
            ),
            const SizedBox(height: 12),
            _buildHorizontalList(
              itemCount: state.latestEvents?.length ?? 0,
              itemBuilder: (context, index) =>
                  CarteEvenementHorizontal(event: state.latestEvents![index]),
              height: 270,
            ),
            const SizedBox(height: 28),
            Text(
              "📂 Catégories",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildCategoryList(context, state.categories, user),
            const SizedBox(height: 28),
            if (user != null && state.favEvents != null) ...[
              _buildSectionHeader(
                context,
                "❤️ Événements favoris",
                onSeeAll: () {},
              ),
              const SizedBox(height: 12),
              _buildHorizontalList(
                itemCount: state.favEvents?.length ?? 0,
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CarteEvenementFavHorizontal(
                      event: state.favEvents![index]),
                ),
                height: 290,
              ),
            ],
            const SizedBox(height: 28),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/app/HomeEvent'),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomBar1(selectedIndex: 1),
    );
  }

  /// Carrousel d’images pour un accueil dynamique
  Widget _buildImageCarousel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: cs.CarouselSlider(
        options: cs.CarouselOptions(
          height: 180,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 1,
        ),
        items: _bannerImages.map((image) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(image, fit: BoxFit.cover),
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Bienvenue sur EventSpot\nDécouvrez les meilleurs événements",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                ),
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text("Voir tout"),
          ),
      ],
    );
  }

  Widget _buildHorizontalList({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    required double height,
  }) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: itemBuilder,
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List? categories, user) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories?.length ?? 0,
        itemBuilder: (context, index) {
          final cat = categories?[index];
          if (cat == null) return const SizedBox.shrink();

          final color = Colors.primaries[index % Colors.primaries.length]
              .withOpacity(0.15);
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                if (user == null) {
                  context.go('/public/intro');
                } else {
                  context.go('/event/${cat.id}');
                }
              },
              child: Container(
                width: 120,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category,
                        size: 32,
                        color: Colors.primaries[index % Colors.primaries.length]),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        cat.title ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Section info supplémentaire

}
