import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetGuardianPage extends StatefulWidget {
  const SetGuardianPage({Key? key}) : super(key: key);

  @override
  State<SetGuardianPage> createState() => _SetGuardianPageState();
}

class _SetGuardianPageState extends State<SetGuardianPage> {
  TextEditingController _guardianController = TextEditingController();
  List<String> _sharedUsers = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text('Set Guardian'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Add Guardian',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _guardianController,
                    decoration: InputDecoration(
                      hintText: 'Enter guardian email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addGuardian,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Shared Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _sharedUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_sharedUsers[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeSharedUser(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addGuardian() {
    String newGuardian = _guardianController.text.trim();
    if (newGuardian.isNotEmpty) {
      setState(() {
        _sharedUsers.add(newGuardian);
        _guardianController.clear();
      });
    }
  }

  void _removeSharedUser(int index) {
    setState(() {
      _sharedUsers.removeAt(index);
    });
  }
}
