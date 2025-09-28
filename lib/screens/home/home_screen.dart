import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/custom_app_bar.dart';
import '../../components/custom_search_bar.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = './home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
            CustomAppBar(isLightMode: isLightMode),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
            CustmoSearchBar(focusNode: _focusNode, isLightMode: isLightMode, isFocused: _isFocused),
          ],
        ),
      ),
    );
  }
}
