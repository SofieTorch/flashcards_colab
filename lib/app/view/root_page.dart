import 'package:flashcards_colab/l10n/l10n.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appbarTitle),
          bottom: TabBar(
            indicatorWeight: 4,
            tabs: [
              Tab(text: l10n.studyTabLabel),
              Tab(text: l10n.teamsTabLabel),
              Tab(text: l10n.decksTabLabel),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
