import 'package:flutter/material.dart';

class JournalCard extends StatelessWidget{
  final String title;
  final Color tagColor;
  final Widget child;

  const JournalCard({
    super.key,
    required this.title,
    required this.tagColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration:BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFECD9C9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}