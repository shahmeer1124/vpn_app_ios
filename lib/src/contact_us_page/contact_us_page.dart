import 'package:contactus/contactus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';
import 'package:openvpn_flutter_example/core/res/media_res.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: ColorsConstants.mainBodyBgColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ContactUs(

          logo: const AssetImage(MediaRes.shahmeer),
          email: 'muhammadshahmeer544@gmail.com',
          companyName: 'Shahmeer Tahir',
          phoneNumber: '+923174352715',
          dividerThickness: 1,
          githubUserName: 'shahmeer1124',
          linkedinURL: 'https://pk.linkedin.com/in/muhammadshahmeertahir',
          tagLine: 'Flutter Developer',
          textColor: Colors.white,
          cardColor:Colors.white.withValues(alpha: 0.5),
          dividerColor: Colors.white,


          companyColor: Colors.white,
          taglineColor: Colors.white,
        ),
      ),
    );
  }
}
