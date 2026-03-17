import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoinsPlans extends StatefulWidget {
  const CoinsPlans({super.key});

  @override
  State<CoinsPlans> createState() => _CoinsPlansState();
}

class _CoinsPlansState extends State<CoinsPlans> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Coin Subscription Plans",
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () => _showPlanDialog(),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              label: const Text("Create Plan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('coin_plans')
                .orderBy('amount', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("Error: ${snapshot.error}"),
                );
              if (!snapshot.hasData)
                return const Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(child: CircularProgressIndicator()),
                );

              return Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.grey[100]),
                child: DataTable(
                  headingRowHeight: 60,
                  dataRowHeight: 70,
                  horizontalMargin: 20,
                  columns: _buildColumns(),
                  rows: snapshot.data!.docs.asMap().entries.map((entry) {
                    return _buildDataRow(entry.key + 1, entry.value);
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontSize: 13,
    );
    return [
      const DataColumn(label: Text('NO.', style: style)),
      const DataColumn(label: Text('ICON', style: style)),
      const DataColumn(label: Text('COIN', style: style)),
      const DataColumn(label: Text('AMOUNT', style: style)),
      const DataColumn(label: Text('PRODUCT KEY', style: style)),
      const DataColumn(label: Text('IS ACTIVE', style: style)),
      const DataColumn(label: Text('ACTION', style: style)),
    ];
  }

  DataRow _buildDataRow(int no, DocumentSnapshot doc) {
    return DataRow(
      cells: [
        DataCell(Text("$no")),
        DataCell(
          const Icon(Icons.stars_rounded, color: Colors.amber, size: 24),
        ),
        DataCell(
          Text(
            "${doc['coins']}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Text(
            "\$${doc['amount']}",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(
            doc['productKey'],
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        DataCell(
          Switch(
            value: doc['isActive'] ?? true,
            activeColor: const Color(0xFF6C63FF),
            onChanged: (val) => _firestore
                .collection('coin_plans')
                .doc(doc.id)
                .update({'isActive': val}),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showPlanDialog(doc: doc),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deletePlan(doc.id),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- VALIDATION LOGIC ---
  void _showPlanDialog({DocumentSnapshot? doc}) {
    final TextEditingController coinController = TextEditingController(
      text: doc != null ? doc['coins'].toString() : "",
    );
    final TextEditingController amountController = TextEditingController(
      text: doc != null ? doc['amount'].toString() : "",
    );
    final TextEditingController keyController = TextEditingController(
      text: doc != null ? doc['productKey'] : "",
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(doc == null ? "Add New Plan" : "Update Plan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogField(
              coinController,
              "Enter Coins (e.g. 8000)",
              Icons.monetization_on,
              true,
            ),
            const SizedBox(height: 12),
            _dialogField(
              amountController,
              "Enter Amount (e.g. 1.0)",
              Icons.attach_money,
              true,
            ),
            const SizedBox(height: 12),
            _dialogField(
              keyController,
              "Product Key (e.g. plan_1)",
              Icons.vpn_key,
              false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
            ),
            onPressed: () async {
              // 1. Check if empty
              if (coinController.text.isEmpty ||
                  amountController.text.isEmpty ||
                  keyController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields!")),
                );
                return;
              }

              // 2. Parse numbers safely
              int? coins = int.tryParse(coinController.text);
              double? amount = double.tryParse(amountController.text);

              if (coins == null || amount == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid number format!")),
                );
                return;
              }

              // 3. Save to Firestore
              Map<String, dynamic> data = {
                'coins': coins,
                'amount': amount,
                'productKey': keyController.text.trim(),
                'isActive': doc != null ? doc['isActive'] : true,
                'updatedAt': FieldValue.serverTimestamp(),
              };

              if (doc == null) {
                await _firestore.collection('coin_plans').add(data);
              } else {
                await _firestore
                    .collection('coin_plans')
                    .doc(doc.id)
                    .update(data);
              }

              Navigator.pop(context);
            },
            child: const Text("Save Plan"),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(
    TextEditingController controller,
    String hint,
    IconData icon,
    bool isNumber,
  ) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _deletePlan(String id) =>
      _firestore.collection('coin_plans').doc(id).delete();
}
