import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fast Food Ordering App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: Add logic to create a food order
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateOrderScreen()),
                );
              },
              child: Text('Create Order'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Add logic to take an order
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TakeOrderScreen()),
                );
              },
              child: Text('Take Order'),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order'),
      ),
      body: Center(
        child: Text('This is the Create Order screen.'),
      ),
    );
  }
}

class TakeOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Order'),
      ),
      body: Center(
        child: Text('This is the Take Order screen.'),
      ),
    );
  }
}
