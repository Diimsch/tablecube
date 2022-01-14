import 'package:flutter/material.dart';
import 'components/body.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    List<bool> selected = List.generate(10000, (index) => true);
    double balance = 0.0;
    bool allSelected = true;

    return Body(selected: selected, balance: balance, allSelected: allSelected);
  }
}
