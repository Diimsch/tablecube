import 'package:flutter/material.dart';
import 'package:frontend/pages/qr_view/components/qr_view_state.dart';

// Only open this screen if platform is android or ios
class QrViewScreen extends StatefulWidget {
  const QrViewScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => QrViewState();
}
