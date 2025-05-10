import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';
import 'package:openvpn_flutter_example/src/speed_test/presentation/cubit/speed_test_cubit.dart';

class SpeedTestAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SpeedTestAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        'Speed Test',
        style: appstyle(
          19,
          Colors.white,
          FontWeight.w700,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          height: 35,
          width: 35,
          child: BlocBuilder<SpeedTestCubit, SpeedTestState>(
            builder: (context, state) {
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.read<SpeedTestCubit>().reset();
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  size: 25,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}