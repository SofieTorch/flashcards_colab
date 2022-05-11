import 'package:flashcards_colab/app/app.dart';
import 'package:flashcards_colab/decks/decks.dart';
import 'package:flashcards_colab/l10n/l10n.dart';
import 'package:flashcards_colab/study/study.dart';
import 'package:flashcards_colab/teams/teams.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRouter.profile,
                ),
                icon: const Icon(MdiIcons.accountCircle),
              ),
            )
          ],
        ),
        body: const TabBarView(
          children: [
            StudyPage(),
            TeamsPage(),
            DecksPage(),
          ],
        ),
      ),
    );
  }
}
