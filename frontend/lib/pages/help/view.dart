import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hilfe'),
        ),
        body: Markdown(
          padding: EdgeInsets.all(32.0),
          data: '''
# Spielprinzip
Der wesentliche Aufbau sowie die Spielregeln sind schnell erklärt. Zunächst wählt der Gegenspieler (Computer oder Mensch) eine Farbkombination aus, die aus einer Menge von Farben verteilt auf Löcher platziert werden. Wichtig dabei ist der Hinweis, dass abhängig von den Einstellungen Farben auch mehrfach in einer zu erratenden Farbkombination verwendet werden dürfen oder Löcher frei bleiben. Im Extremfall ist sogar eine Farbkombination gestattet, die nur aus einer oder keiner Farbe besteht.

Nun wählst du aus dem Menü die gewünschten Farben aus, und legst diese in die Steckplätze (Löcher). Korrekturen einer Farbkombination dürfen jederzeit vorgenommen werden. Sobald du im Menübereich die Schaltfläche zum Bestätigen angeklickt hast, wertet der Computer deine jeweils zuletzt gesteckte Farbkombination aus.

Für jede Position, die sowohl in der Farbe als auch in der Position korrekt von dir gesteckt (oder frei gelassen) worden ist, zeigt dir der Computer einen weißen Kreis unter deinem Versuch an. Für jede Farbe (oder frei gelassenes Loch), die jedoch noch an einer falschen Position gesteckt worden ist, wird ein schwarzer Kreis angezeigt.

Deine Aufgabe besteht nun darin, durch geschicktes und kluges Kombinieren herauszufinden, welche Farbkombination sich der Gegenspieler jeweils ausgedacht hat. Dabei wirst du im Laufe der Zeit eigene Strategien entwickeln, die deinen individuellen Denkgewohnheiten möglichst angepasst werden sollten. Du gewinnst das Spiel, wenn du die Farbkombination vor Erreichen der Spielzug-Grenze herausfindest.

*Anleitung übernommen von [lerntipp.com](https://www.lerntipp.com/mastermind/) und angepasst.*

# Einstellungen

## Anzahl der Farben

Du kannst die Anzahl der zur Verfügung stehenden Farben für die Farbkombination einschränken oder erweitern. Erhöhe die Anzahl, um das Spiel schwieriger zu machen.

## Anzahl der Steckplätze (Löcher)

Du kannst die Größe der Farbkombinationen verändern, die du erraten musst. Erhöhe die Anzahl, um das Spiel schwieriger zu machen.

## Steckplätze können leer bleiben

Wählst du diese Option aus, muss nicht allen Steckplätze einer Farbbombination eine Farbe zugeordnet sein. Diese Option erhöht den Schwierigkeitsgrad des Spiels. Unabhängig von der nächsten Option sind immer mehrere leere Steckplätze möglich.

## Farben können mehrfach verwendet werden

Wählst du diese Option aus, kann eine Farbe mehrfach in der zu erratenden Farbkombination vorkommen. Diese Option erhöht den Schwierigkeitsgrad des Spiels.
                ''',
        ),
      ),
    );
  }
}
