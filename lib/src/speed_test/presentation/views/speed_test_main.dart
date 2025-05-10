import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';
import 'package:openvpn_flutter_example/src/speed_test/presentation/cubit/speed_test_cubit.dart';
import 'package:openvpn_flutter_example/src/speed_test/presentation/widgets/speed_test_widget.dart';
import 'package:uicons_pro/uicons_pro.dart';

class SpeedTestScreen extends StatelessWidget {
  const SpeedTestScreen({super.key});
  static const routeName = '/speed_test_screen';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpeedTestCubit(
        internetSpeedTest: FlutterInternetSpeedTest(),
        vsync: Navigator.of(context),
      ),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: const SpeedTestAppBar(),
          backgroundColor: ColorsConstants.mainBodyBgColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(child: SizedBox()),
                BlocBuilder<SpeedTestCubit, SpeedTestState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              state.displayRate.toStringAsFixed(1),
                              style: appstyle(
                                130,
                                state.testInProgress
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : Colors.white,
                                FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                state.unitText,
                                style: appstyle(
                                  40,
                                  state.testInProgress
                                      ? Colors.white.withValues(alpha: 0.5)
                                      : Colors.white,
                                  FontWeight.w700,
                                ),
                              ),
                            ),
                            AnimatedBuilder(
                              animation:
                                  context.read<SpeedTestCubit>().glowAnimation!,
                              builder: (context, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: !state.testInProgress
                                          ? Colors.green
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (state.testInProgress)
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.yellow
                                                    .withValues(alpha: 0.3),
                                                blurRadius: context
                                                    .read<SpeedTestCubit>()
                                                    .glowAnimation!
                                                    .value,
                                                spreadRadius: context
                                                        .read<SpeedTestCubit>()
                                                        .glowAnimation!
                                                        .value /
                                                    2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: state.testInProgress
                                                ? Colors.yellow
                                                : Colors.white,
                                          ),
                                          color: state.testInProgress
                                              ? Colors.yellow
                                              : Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: state.testInProgress
                                              ? () {
                                                  context
                                                      .read<SpeedTestCubit>()
                                                      .internetSpeedTest
                                                      .cancelTest();
                                                  context
                                                      .read<SpeedTestCubit>()
                                                      .reset();
                                                }
                                              : () => context
                                                  .read<SpeedTestCubit>()
                                                  .startTest(),
                                          icon: Icon(
                                            state.testInProgress
                                                ? UIconsPro.solidRounded.pause
                                                : UIconsPro
                                                    .solidRounded.refresh,
                                            color: !state.testInProgress
                                                ? Colors.green
                                                : Colors.black,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const Expanded(child: SizedBox()),
                BlocBuilder<SpeedTestCubit, SpeedTestState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SafeArea(
                          child: Text(
                            'Test Status: ${state.speedTestStatuses == SpeedTestStatuses.initial ? 'Ready' : state.speedTestStatuses == SpeedTestStatuses.connecting ? 'Connecting' : 'Testing'}',
                            style: appstyle(
                                12,
                                Colors.white.withValues(alpha: 0.6),
                                FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 20,)
                       
                      ],
                    );
                  },
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
