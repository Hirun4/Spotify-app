import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/configs/assets/app_vectors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_homeTopCard()],
        ),
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: Container(
        height: 188,
        child: Stack(
          children: [
            SvgPicture.asset(AppVectors.homeTopCard),
          ],
        ),
      ),
    );
  }
}
