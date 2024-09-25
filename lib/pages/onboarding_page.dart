import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Bienvenido a AndyQR",
          body: "Explora las funciones principales de la app.",
          image: const Center(child: Icon(Icons.qr_code, size: 100)),
        ),
        PageViewModel(
          title: "Escanea códigos QR",
          body: "Escanea y guarda tus códigos fácilmente.",
          image: const Center(child: Icon(Icons.camera_alt, size: 100)),
        ),
        PageViewModel(
          title: "Administra tu perfil",
          body: "Regístrate y personaliza tu experiencia.",
          image: const Center(child: Icon(Icons.person, size: 100)),
        ),
      ],
      onDone: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('seenOnboarding', true);
        Navigator.of(context).pushReplacementNamed('/welcome');
      },
      onSkip: () {
        //saltar y redirigir a la página de bienvenida
        Navigator.of(context).pushReplacementNamed('/welcome');
      },
      showSkipButton: true,
      skip: const Text("Saltar"),
      next: const Icon(Icons.arrow_forward),
      done:
          const Text("Empezar", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
