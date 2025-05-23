// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:traderapp/retailerpages/others/loadsuppliers.dart';
import 'package:traderapp/services/firestoreconnectionoptions.dart';
import 'package:traderapp/retailerpages/tabs/insights.dart';

class RetHomePage extends StatefulWidget {
  const RetHomePage({super.key});

  @override
  State<RetHomePage> createState() => _RetHomePageState();
}

class _RetHomePageState extends State<RetHomePage>
    with TickerProviderStateMixin {
  Stream<QuerySnapshot>? supplierStream =
      FirestoreConnection().readSupplierList();

  @override
  Widget build(BuildContext context) {
    TabController controller = TabController(length: 2, vsync: this);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: TabBar(
            unselectedLabelColor: Theme.of(context).colorScheme.secondary,
            controller: controller,
            tabs: const [
              Text(
                'Suppliers',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Insights',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        Expanded(
            child: Container(
          child: TabBarView(controller: controller, children: [
            Container(child: ListSuppliers().allSuppliers(supplierStream)),
            const Insights(),
          ]),
        ))
      ],
    );
  }
}
