
// مشروع Flutter مبسط لتطبيق Twins Gym

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void main() => runApp(TwinsGymApp());

class TwinsGymApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Twins Gym',
      theme: ThemeData(primarySwatch: Colors.green),
      home: PlayerListPage(),
    );
  }
}

class Player {
  final int id;
  final String name;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final File? image;

  Player({
    required this.id,
    required this.name,
    required this.amount,
    required this.startDate,
    required this.endDate,
    this.image,
  });

  bool get isActive => endDate.isAfter(DateTime.now());
}

class PlayerListPage extends StatefulWidget {
  @override
  _PlayerListPageState createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  List<Player> players = [];
  int nextId = 1;

  void _addPlayer() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    final newPlayer = Player(
      id: nextId,
      name: 'لاعب $nextId',
      amount: 300.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
      image: File(pickedImage.path),
    );

    setState(() {
      players.add(newPlayer);
      nextId++;
    });
  }

  Color getRowColor(bool isActive) {
    return isActive ? Colors.yellow.shade100 : Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('قائمة اللاعبين')),
      backgroundColor: Colors.green.shade50,
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlayer,
        child: Icon(Icons.person_add),
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlayerCardPage(player: player),
              ),
            ),
            child: Card(
              color: getRowColor(player.isActive),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: player.image != null
                      ? FileImage(player.image!)
                      : null,
                  backgroundColor: Colors.grey,
                ),
                title: Text(player.name),
                subtitle: Text(
                  'من ${DateFormat('yyyy/MM/dd').format(player.startDate)} إلى ${DateFormat('yyyy/MM/dd').format(player.endDate)}',
                ),
                trailing: Icon(
                  player.isActive ? Icons.check_circle : Icons.cancel,
                  color: player.isActive ? Colors.green : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlayerCardPage extends StatelessWidget {
  final Player player;

  const PlayerCardPage({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = player.isActive;
    final cardColor = isActive ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(title: Text('كارت اللاعب')),
      body: Center(
        child: Card(
          color: cardColor.shade100,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (player.image != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(player.image!),
                  ),
                SizedBox(height: 20),
                Text(
                  player.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('الاشتراك: ${player.amount} جنيه'),
                Text(
                  'من ${DateFormat('yyyy/MM/dd').format(player.startDate)} إلى ${DateFormat('yyyy/MM/dd').format(player.endDate)}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
