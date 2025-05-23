import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/filter_function.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/bloc/vpn_bloc.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/view/splash_view.dart';
import 'package:openvpn_flutter_example/src/vpn/presentation/widgets/extracted_widget.dart';
import 'package:uicons_pro/uicons_pro.dart';

class CountryMenuButton extends StatefulWidget {
  const CountryMenuButton({required this.vpnStateHolder, super.key});
  final VpnStateHolder vpnStateHolder;

  @override
  _CountryMenuButtonState createState() => _CountryMenuButtonState();
}

class _CountryMenuButtonState extends State<CountryMenuButton>
    with SingleTickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350), // Smooth duration
    );
    _scaleAnimation = Tween<double>(
      begin: 0.1, // Start very small
      end: 1.0, // Full size
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.decelerate),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.decelerate),
    );
  }

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _showMenu();
    } else {
      _hideMenu();
    }
  }

  void _showMenu() {
    final RenderBox button =
        _buttonKey.currentContext!.findRenderObject()! as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero);
    final Size buttonSize = button.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap anywhere to dismiss
          GestureDetector(
            onTap: _hideMenu,
            child: Container(color: Colors.transparent),
          ),
          // Positioned menu with animation
          Positioned(
            left: buttonPosition.dx,
            top: buttonPosition.dy -
                300 -
                8, // Fixed height + offset above button
            child: FadeTransition(
              opacity: _fadeAnimation!,
              child: ScaleTransition(
                scale: _scaleAnimation!,
                alignment:
                    Alignment.bottomCenter, // Grow from button's position
                child: Material(
                  color: Colors.white.withValues(alpha: 0.001),
                  elevation: 4,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 180,
                    height: 300, // Fixed height for the menu
                    decoration: BoxDecoration(
                      color: ColorsConstants.mainBodyBgColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            BlocBuilder<VpnBloc, VpnStateHolder>(
                              builder: (context, state) {
                                return Container(
                                  height: 42,
                                  width: 180,
                                  color: ColorsConstants.mainBodyBgColor,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      FilterTypeWid(
                                        state: state,
                                        filterType: FilterType.name, icon: Icons.abc,
                                      ),
                                      FilterTypeWid(
                                        state: state,
                                        filterType: FilterType.lowestPing, icon: CupertinoIcons.wifi,
                                      ),
                                      FilterTypeWid(
                                        state: state,
                                        filterType: FilterType.fastestSpeed, icon: UIconsPro.solidRounded.internet_speed_wifi,
                                      ),
                                      FilterTypeWid(
                                        state: state,
                                        filterType:
                                            FilterType.lowestConnections, icon: UIconsPro.solidRounded.plug_connection,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<VpnBloc, VpnStateHolder>(
                              builder: (context, state) {
                                return Column(
                                  children: state.vpnList
                                      .map((country) => CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            minSize: 0,
                                            onPressed: () {
                                              dispatchVpnEvent(
                                                context,
                                                ChangeSelectedVpn(
                                                  vpnNewModel: country,
                                                ),
                                              );
                                              _toggleMenu();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.2),
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              height: 50,
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    child: Icon(
                                                      CupertinoIcons.globe,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      LeftColumnText(
                                                        text: country
                                                            .countryShort,
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                      LeftColumnText(
                                                        text: country.ip,
                                                        color: Colors.white
                                                            .withValues(
                                                                alpha: 0.5),
                                                        fontSize: 8,
                                                      ),
                                                      LeftColumnText(
                                                        text: country.hostname,
                                                        color:
                                                            Colors.blueAccent,
                                                        fontSize: 8,
                                                      ),
                                                    ],
                                                  ),
                                                  const Expanded(
                                                      child: SizedBox()),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      StatusRow(
                                                        icon:
                                                            CupertinoIcons.wifi,
                                                        value:
                                                            '${country.ping} ms',
                                                        color: getPingColor(
                                                            country.ping),
                                                      ),
                                                      StatusRow(
                                                        icon: UIconsPro
                                                            .solidRounded
                                                            .internet_speed_wifi,
                                                        value:
                                                            '${(country.speed / 1000000).toStringAsFixed(0)} Mbps',
                                                        color: getSpeedColor(
                                                            country.speed /
                                                                1000000),
                                                      ),
                                                      StatusRow(
                                                        icon: UIconsPro
                                                            .solidRounded
                                                            .plug_connection,
                                                        value:
                                                            '${country.numVpnSessions}',
                                                        color: getSessionsColor(
                                                            country
                                                                .numVpnSessions),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Insert overlay and start animation
    Overlay.of(context).insert(_overlayEntry!);
    _animationController!.forward();
  }

  // Hide the overlay menu
  void _hideMenu() {
    _animationController!.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _hideMenu();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTap: _toggleMenu,
      child: Container(
        margin: EdgeInsets.only(left: 4),
        height: 21,
        width: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withValues(alpha: 0.2),
        ),
        child: const Center(
          child: Icon(
            CupertinoIcons.arrow_up_circle_fill,
            size: 13,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class FilterTypeWid extends StatelessWidget {
  const FilterTypeWid({
    required this.state,
    required this.filterType,
    required this.icon,
    super.key,
  });
  final VpnStateHolder state;
  final FilterType filterType;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 17,
            child: Checkbox(
              activeColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                side: const BorderSide(
                  width: 1.5,
                  color: Colors.green,
                ),
                value: state.filterType == filterType,
                onChanged: (val) {
                  context.read<VpnBloc>().add(
                        ChangeHotelFilter(filterType: filterType),
                      );
                }),
          ),
          Icon(
            icon,
            color: Colors.white,
            size: 13,
          )
        ],
      ),
    );
  }
}
