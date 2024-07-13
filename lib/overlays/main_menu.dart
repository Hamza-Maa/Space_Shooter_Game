import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuto_test/main_app.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _titleColorAnimation;

  @override
  void initState() {
    super.initState();
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('menu_sound.mp3', volume: 0.5);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _titleColorAnimation = ColorTween(
      begin: Colors.amber,
      end: Colors.yellow,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    FlameAudio.bgm.dispose();
    super.dispose();
  }

  void _startGame(BuildContext context) {
    FlameAudio.bgm.stop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SpaceShooterGameWidget(),
      ),
    );
  }

  void _exitGame() {
    FlameAudio.bgm.stop();
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/back2.jpg'), // Path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _titleColorAnimation,
                builder: (context, child) {
                  return Text(
                    'Space \nShooter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: _titleColorAnimation.value,
                      shadows: const [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black54,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => _startGame(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.black,
                  elevation: 10,
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _exitGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.black,
                  elevation: 10,
                ),
                child: const Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
