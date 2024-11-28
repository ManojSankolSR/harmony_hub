import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:harmony_hub/Widgets/CustomSnackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Aboutscreen extends StatelessWidget {
  const Aboutscreen({super.key});

  Future _launchGpay({required BuildContext context}) async {
    String upiUrl =
        "upi://pay?pa=manojsankol6361@oksbi&p n=Payee Name&tn=Payment Message&cu=INR";
    await launchUrl(Uri.parse(upiUrl));
    // .then((value) {
    //   print(value);
    // }).catchError((err) => print(err));
    // if (await canLaunchUrlString(upiUrl)) {

    // } else {
    //   Customsnackbar(
    //       title: "No UPI App Found",
    //       subTitle: "Please Install An UPI Supported Paymant App To Proceed",
    //       context: context,
    //       type: ContentType.warning);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("About"),
          centerTitle: true,
          backgroundColor: isLightMode ? Colors.white : Colors.black,
        ),
        body: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: Image.asset(
                    height: 400,
                    color: isLightMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    "assets/splash.png")),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: isLightMode
                        ? [
                            Colors.white60,
                            Colors.white70,
                          ]
                        : [Colors.black87, Colors.black87]),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    // physics: ScrollPhysics(),

                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 30, right: 20, top: 20, bottom: 20),
                        height: 150,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          shape: BoxShape.circle,
                          color: isLightMode ? Colors.black : Colors.white,
                        ),
                        child: Image.asset(
                          fit: BoxFit.contain,
                          "assets/splash.png",
                          color: isLightMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Harmony Hub",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "v1.0.0",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "This Is An Open-Source Music App And Can Be Found On",
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                          onPressed: () async {
                            await launchUrlString(
                                'https://github.com/ManojSankolSR/harmony_hub');
                          },
                          child: Image.asset(
                              color: isLightMode
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade200,
                              height: 35,
                              "assets/GitHub_Logo.png")),
                      const Text(
                        "If You Liked My Work \nShow Some ❤️ And 🌟 the Repositry",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                          onPressed: () async {
                            await launchUrlString(
                                'https://buymeacoffee.com/manoj_sankol_sr');
                          },
                          child: Image.asset(
                              height: 50, "assets/BuymeCoffee.png")),
                      const Text(
                        "OR",
                        textAlign: TextAlign.center,
                      ),
                      TextButton.icon(
                          onPressed: () async {
                            await _launchGpay(context: context);
                          },
                          label: const Text("Gpay"),
                          icon:
                              Image.asset(height: 40, "assets/gpay-icon.png")),
                      const Text(
                        "Sponsor This Project",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Made With 💜 By Manoj Sankol",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
