import 'package:dice_app/dice_roller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiceApp(),
    ),
  );
}

class DiceApp extends StatefulWidget {
  const DiceApp({super.key});

  @override
  State<DiceApp> createState() => _DiceAppState();
}

class _DiceAppState extends State<DiceApp> {
  bool isSingleDice = false;
  bool isMute = false;
  bool isShakeOff = false;

  void switchDice() {
    setState(() {
      isSingleDice = !isSingleDice;
    });
  }

  void muteAudio() {
    setState(() {
      isMute = !isMute;
    });
  }

  void shakeOff() {
    setState(() {
      isShakeOff = !isShakeOff;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 41, 60),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 41, 60),
        elevation: 0, // Remove the shadow
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    const Icon(
                      Icons.change_circle_outlined,
                      color: Colors.black,
                    ),
                    isSingleDice
                        ? const Text("Two Dices")
                        : const Text("One Dice")
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: isMute
                    ? const Row(
                        children: [
                          Icon(
                            Icons.volume_up,
                            color: Colors.black,
                          ),
                          Text("Unmute"),
                        ],
                      )
                    : const Row(
                        children: [
                          Icon(
                            Icons.volume_off,
                            color: Colors.black,
                          ),
                          Text("Mute"),
                        ],
                      ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: isShakeOff
                    ? const Row(
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/phone-shake.png'),
                            color: Colors.black,
                          ),
                          Text("Shake On"),
                        ],
                      )
                    : const Row(
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/phone-shake-off.png'),
                            color: Colors.black,
                          ),
                          Text("Shake Off"),
                        ],
                      ),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              switchDice();
            } else if (value == 1) {
              muteAudio();
            } else if (value == 2) {
              shakeOff();
            }
          }),
        ],
      ),
      body: Center(
        child: DiceRoller(
          isSingleDice: isSingleDice,
          isMute: isMute,
          isShakeOff: isShakeOff,
        ),
      ),
    );
  }
}
