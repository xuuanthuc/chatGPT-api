import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../global/routes/navigation_service.dart';
import '../../../global/style/app_images.dart';
import '../../../global/routes/route_keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  goToHome() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    navService.pushReplacementNamed(RouteKey.chat);
  }

  @override
  void didChangeDependencies() {
    goToHome();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff454654),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: SvgPicture.asset(
                AppImages.iOpenAI,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'ChatGPT',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
