import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_clean/models/auth.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final TextEditingController emailController = TextEditingController();
    final auth = Provider.of<Auth>(context, listen: false);

    Future<void> _resetPassword() async {
      try {
        await auth.resetPassword(emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email de recuperação enviado!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar email: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ), // Ícone de seta para voltar
          onPressed: () {
            Navigator.of(context).pop(); // Retorna à tela anterior
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Image.asset(
                    'lib/assets/img/mind_clean.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Esqueceu a senha?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: deviceSize.width * 0.45,
                  child: Text(
                    'Informe seu email abaixo para receber a senha',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  child: Container(
                    width: deviceSize.width * 0.90,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: deviceSize.width * 0.80,
                          child: ElevatedButton(
                            onPressed: _resetPassword,
                            child: Text(
                              'Enviar',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
