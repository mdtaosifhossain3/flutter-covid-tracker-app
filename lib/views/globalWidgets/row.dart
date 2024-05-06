import 'package:flutter/material.dart';

class ReusableRow extends StatelessWidget {
  final String? title;
  final String? value;
  const ReusableRow({super.key, this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value!, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
