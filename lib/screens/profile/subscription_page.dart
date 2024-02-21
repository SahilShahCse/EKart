import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {

  String _selectedPlan = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text('Subscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a subscription plan:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            _buildSubscriptionPlanTile('Basic Plan', 'Free'),
            _buildSubscriptionPlanTile('Standard Plan', '\$9.99/month'),
            _buildSubscriptionPlanTile('Premium Plan', '\$19.99/month'),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _subscribe(_selectedPlan),
                child: Text('Subscribe'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionPlanTile(String title, String price) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = title;
        });
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _selectedPlan == title ? Colors.blue.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(10),
          border: _selectedPlan == title
              ? Border.all(color: Colors.blue, width: 2)
              : Border.all(color: Theme.of(context).colorScheme.background, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _selectedPlan == title ? Colors.blue : null,
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _selectedPlan == title ? Colors.blue : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _subscribe(String plan) {
    if (plan.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Subscription'),
            content: Text('You have subscribed to $plan.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show an error message if no plan is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a subscription plan.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
