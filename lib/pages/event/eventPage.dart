import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../composants/composants.dart';
import 'eventCtrl.dart';
import 'eventState.dart';// Widget pour afficher l’event visuellement

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventControllerProvider);
    final controller = ref.read(eventControllerProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: PreferredSize(preferredSize: Size.fromHeight(100.0), child: navBar()),


      body: state.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: state.nouveauEvents?.length ?? 0,
        itemBuilder: (context, index) {
          final event = state.nouveauEvents?[index];
          if (event == null) return Container();
          return CarteEvent(event); // Ton widget personnalisé
        },
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomBar1(selectedIndex: 1),
    );
  }
}
