import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../composants/composants.dart';
import 'eventCtrl.dart';
import 'eventState.dart';

class EventPage extends ConsumerStatefulWidget {
  const EventPage({super.key});

  @override
  ConsumerState<EventPage> createState() => _EventPageState();
}

class _EventPageState extends ConsumerState<EventPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final texte = _searchController.text;
    final controller = ref.read(eventControllerProvider.notifier);
    controller.rechercherEvent(texte);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Column(
          children: [
            Expanded(child: navBar()),
            const SizedBox(height: 10),
            SizedBox(height: 50, child: _buildSearchBar()),
          ],
        ),

      ),
      body: state.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : (state.nouveauEvents == null || state.nouveauEvents!.isEmpty)
          ? const Center(child: Text("Aucun événement trouvé"))
          : ListView.builder(
        itemCount: state.nouveauEvents!.length,
        itemBuilder: (context, index) {
          final event = state.nouveauEvents![index];
          return CarteEvent(event);
        },
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomBar1(selectedIndex: 1),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextField(
        controller: _searchController,
        onSubmitted: (_) => _onSearch(), // Recherche quand on appuie sur Entrée
        decoration: InputDecoration(
          hintText: 'Rechercher des événements...',
        //  prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    final controller = ref.read(eventControllerProvider.notifier);
                    controller.rechercherEvent('');
                    setState(() {}); // Pour rafraîchir l'UI du suffixIcon
                  },
                ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.deepPurple),
                onPressed: _onSearch,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
