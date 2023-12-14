import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:dice_app/single_dice.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

final randomizer = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller(
      {super.key,
      required this.isSingleDice,
      required this.isMute,
      required this.isShakeOff});

  final bool isSingleDice;
  final bool isMute;
  final bool isShakeOff;

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<DiceRoller> with WidgetsBindingObserver {
  var currentDiceRoll1 = 2;
  var currentDiceRoll2 = 2;
  late ShakeDetector detector;
  final audioPlayer = AudioPlayer();

  var isButtonDisabled = false;

  Future<void> rollDice() async {
    if (!widget.isMute) {
      audioPlayer.play(AssetSource('audio/dice_roll_sound.mp3'));
    }

    for (var i = 0; i < 10; i++) {
      setState(() {
        currentDiceRoll1 = randomizer.nextInt(6) + 1;
        currentDiceRoll2 = randomizer.nextInt(6) + 1;
      });

      await Future.delayed(const Duration(milliseconds: 100));
    }

    setState(() {
      currentDiceRoll1 = randomizer.nextInt(6) + 1;
      currentDiceRoll2 = randomizer.nextInt(6) + 1;
    });

    if (!widget.isMute) {
      audioPlayer.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        if (!widget.isShakeOff) {
          rollDice();
        }
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 234, 234, 234),
          content: Text(
            "Shake to roll dice",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );

    // Add the observer for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app pause/resume
    if (state == AppLifecycleState.paused) {
      detector.stopListening(); // Pause the ShakeDetector
    } else if (state == AppLifecycleState.resumed) {
      detector.startListening(); // Resume the ShakeDetector
    }
  }

  void disableButtonForOneSecond() {
    setState(() {
      isButtonDisabled = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        isButtonDisabled = false;
      });
    });
  }

  @override
  Widget build(context) {
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.isSingleDice
              ? SingleDice(
                  currentDiceRoll: currentDiceRoll1,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleDice(
                      currentDiceRoll: currentDiceRoll1,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SingleDice(
                      currentDiceRoll: currentDiceRoll2,
                    ),
                  ],
                ),
          const SizedBox(
            height: 20,
          ),
          if (widget.isShakeOff)
            ElevatedButton(
              onPressed: isButtonDisabled
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color.fromARGB(255, 234, 234, 234),
                          content: Text(
                            "Please wait before pressing!",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    }
                  : () {
                      disableButtonForOneSecond();
                      rollDice();
                    },
              style: ElevatedButton.styleFrom(
                maximumSize: const Size(80, 80),
                backgroundColor: const Color.fromARGB(255, 234, 234, 234),
                // Background color
                shape: const StadiumBorder(),
              ),
              child: Image.asset(
                'assets/images/two-dices.png',
                width: 60,
                height: 60,
                color: const Color.fromARGB(255, 35, 41, 60),
              ),
            )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Remove the observer for app lifecycle changes
    WidgetsBinding.instance.removeObserver(this);

    // Dispose of the ShakeDetector when the widget is disposed
    detector.stopListening();
    super.dispose();
  }
}
