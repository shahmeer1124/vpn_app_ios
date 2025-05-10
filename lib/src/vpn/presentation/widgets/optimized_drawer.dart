import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';
import 'package:openvpn_flutter_example/core/res/media_res.dart';
import 'package:openvpn_flutter_example/src/contact_us_page/contact_us_page.dart';
import 'package:openvpn_flutter_example/src/network_info/presentation/view/network_info_view.dart';
import 'package:openvpn_flutter_example/src/speed_test/presentation/views/speed_test_main.dart';
import 'package:openvpn_flutter_example/src/vpn/domain/entities/drawer_item_model.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:uicons_pro/uicons_pro.dart'; // Replace with your actual UIconsPro import

class OptimizedDrawer extends StatelessWidget {
  const OptimizedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      DrawerItem(
        title: 'Speed Test',
        icon: UIconsPro.solidRounded.internet_speed_wifi,
        iconColor: Colors.blueAccent,
        onTap: () {
          context.read<VpnBloc>().drawerController.hideDrawer();
          Navigator.of(context).pushNamed(SpeedTestScreen.routeName);
        },
      ),
      DrawerItem(
        title: 'Network Information',
        icon: UIconsPro.solidRounded.network,
        iconColor: Colors.blueAccent,
        onTap: () {
          context.read<VpnBloc>().drawerController.hideDrawer();
          Navigator.of(context).pushNamed(NetworkInfoScreen.routeName);
        },
      ),
      DrawerItem(
        title: 'Privacy Policy',
        icon: Icons.privacy_tip,
        iconColor: Colors.blueAccent,
        onTap: () {
          context.read<VpnBloc>().drawerController.hideDrawer();
          Navigator.of(context).pushNamed(NetworkInfoScreen.routeName);
        },
      ),
      DrawerItem(
        title: 'Terms & Conditions',
        iconColor: Colors.blueAccent,
        icon: UIconsPro.solidRounded.document,
        onTap: () {
          context.read<VpnBloc>().drawerController.hideDrawer();
        },
      ),
      DrawerItem(
        title: 'Contact Us',
        iconColor: Colors.blueAccent,
        icon: Icons.contact_mail,
        onTap: () {
          context.read<VpnBloc>().drawerController.hideDrawer();
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (context) => const ContactUsPage(),
          ));
        },
      ),
    ];

    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 120,
              height: 120,
              margin: const EdgeInsets.only(top: 24, bottom: 34),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,

              ),
              child: Center(child: Image.asset(MediaRes.appIcon),),
            ),
            ...drawerItems.map((item) => ListTile(
                  leading: Icon(
                    item.icon,
                    color: Colors.white,
                    size: 25,
                  ),
                  title: Text(
                    item.title,
                    style: appstyle(18, Colors.white, FontWeight.w500),
                  ),
                  onTap: item.onTap,
                )),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class AdvanceDrawerBackDrop extends StatelessWidget {
  const AdvanceDrawerBackDrop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorsConstants.mainBodyBgColor, Colors.black],
        ),
      ),
    );
  }
}
