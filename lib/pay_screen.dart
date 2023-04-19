import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PayScreen extends StatefulWidget {
  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  TextEditingController _upiIDController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _checkVpaValidity(String vpa) async {
    if (vpa.contains("@"))
      return true;
    else
      return false;
  }

  bool _checkAmountValidity(String amount) {
    // Check if the amount is valid
    // Replace the following return statement with your validation logic
    return double.tryParse(amount) != null && double.parse(amount) > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Propzing"),
        leading: IconButton(
          icon: const ImageIcon(
            AssetImage('assets/cover.png'),
          ),
          onPressed:() {},
        ),
      ),
      body: Center(
    child:
        Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _upiIDController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Payee UPI ID",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    String upiID = _upiIDController.text.trim();
                    String amount = _amountController.text.trim();

                    if (upiID.isEmpty || amount.isEmpty) {
                      _showAlert("Invalid Inputs", "Please enter Payee UPI ID and amount.");
                      return;
                    }

                    bool isVpaValid = await _checkVpaValidity(upiID);
                    bool isAmountValid = _checkAmountValidity(amount);

                    if (!isVpaValid) {
                      _showAlert("Invalid VPA", "Please enter a valid Payee UPI ID.");
                      return;
                    }

                    if (!isAmountValid) {
                      _showAlert("Invalid Amount", "Please enter a valid amount.");
                      return;
                    }

                    String url = "upi://pay?pa=$upiID&pn=Payee&tn=Payment&am=$amount&cu=INR";

                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      _showAlert("Error","Failed to open UPI app. Please check your inputs.");
                    }
                    },
                  child: const Text("Pay"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
