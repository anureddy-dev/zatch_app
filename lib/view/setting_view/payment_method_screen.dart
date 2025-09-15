import 'package:flutter/material.dart';

// Models
class CardModel {
  final String brand;
  final String last4;
  CardModel({required this.brand, required this.last4});
}

class UpiModel {
  final String upiId;
  UpiModel({required this.upiId});
}

class WalletModel {
  final String name;
  final String? logoAsset;
  WalletModel({required this.name, this.logoAsset});
}

class PaymentData {
  List<CardModel>? cards;
  List<UpiModel>? upis;
  List<WalletModel>? wallets;

  PaymentData({this.cards, this.upis, this.wallets});

  static PaymentData getDummy() {
    return PaymentData(
      cards: [
        CardModel(brand: "VISA", last4: "2143"),
        CardModel(brand: "MasterCard", last4: "5678"),
      ],
      upis: [
        UpiModel(upiId: "xyz@ybl"),
        UpiModel(upiId: "abc@upi"),
      ],
      wallets: [
        WalletModel(name: "MobiKwik"),
        WalletModel(name: "Paytm"),
        WalletModel(name: "PhonePe"), // no asset, fallback to icon
      ],
    );
  }
}

class PaymentMethodScreen extends StatelessWidget {
  final PaymentData data;

  const PaymentMethodScreen({super.key, required this.data});

  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget cardTile(CardModel card) => Card(
      color: Color(0xFFF2F2F2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
    child: ListTile(
      leading: const Icon(Icons.credit_card, color: Colors.blue),
      title: Text('${card.brand} **** **** **** ${card.last4}'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
  );

  Widget upiTile(UpiModel upi) => Card(
    color: Color(0xFFF2F2F2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
    child: ListTile(
      leading: const Icon(Icons.account_balance_wallet, color: Colors.green),
      title: Text(upi.upiId),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
  );

  Widget walletTile(WalletModel wallet) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
    child: ListTile(
      leading: wallet.logoAsset != null
          ? SizedBox(
        width: 40,
        height: 24,
        child: Image.network(wallet.logoAsset!, fit: BoxFit.contain),
      )
          : const Icon(Icons.account_balance_wallet),

      title: Text(wallet.name),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
  );


  Widget addButton(String text, VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Color(0xFFF7FFDF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: Color(0xFFF2F2F2), width: 1),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      icon: const Icon(Icons.add, color: Colors.black),
      onPressed: onPressed,
      label: Text(text),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Payment Method"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          sectionTitle('Card'),
          ...(data.cards ?? []).map(cardTile),
          addButton('Add New Payment', () {}),
          sectionTitle('UPI'),
          ...(data.upis ?? []).map(upiTile),
          addButton('Add UPI', () {}),
          sectionTitle('Wallets'),
          ...(data.wallets ?? []).map(walletTile),
          addButton('Add Wallet', () {}),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: const Text('Select',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


