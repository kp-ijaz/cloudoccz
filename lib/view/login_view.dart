import 'dart:ui';
import 'package:cloudocz/view/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloudocz/bloc/auth/auth_bloc.dart';
import 'package:cloudocz/bloc/auth/auth_event.dart';
import 'package:cloudocz/bloc/auth/auth_state.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  void login(BuildContext context) {
    final email = _emailController.text;
    final password = _passwordController.text;
    BlocProvider.of<LoginBloc>(context).add(SubmitLoginEvent(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          _buildBackground(),
          _buildLoginForm(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Center(
        child: OverflowBox(
          maxWidth: double.infinity,
          child: Transform.translate(
            offset: const Offset(200, 100),
            child: Image.asset(
              "assets/Backgrounds/spline.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_emailController, "Email", Icons.email),
            const SizedBox(height: 20),
            _buildTextField(_passwordController, "Password", Icons.lock,
                obscureText: true),
            const SizedBox(height: 30),
            _buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(token: state.token),
            ),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is LoginLoading) {
          return const CircularProgressIndicator();
        }
        return ElevatedButton(
          onPressed: () => login(context),
          child: const Text("Login"),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      },
    );
  }
}
