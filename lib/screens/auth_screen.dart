import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  String? _error;
  bool _loading = false;

  Future<void> _submit(AuthProvider auth) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_isLogin) {
        await auth.signInWithEmail(
            _emailController.text, _passwordController.text);
      } else {
        await auth.signUpWithEmail(
            _emailController.text, _passwordController.text);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message ?? 'Erreur d\'authentification';
      });
    } catch (e) {
      setState(() {
        _error = 'Une erreur inconnue est survenue.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Dog Training AI',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v != null && v.contains('@')
                          ? null
                          : 'Email invalide',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration:
                          const InputDecoration(labelText: 'Mot de passe'),
                      obscureText: true,
                      validator: (v) => v != null && v.length >= 6
                          ? null
                          : '6 caractères min.',
                    ),
                    const SizedBox(height: 16),
                    if (_error != null) ...[
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                    ],
                    ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _submit(auth);
                              }
                            },
                      child: _loading
                          ? const CircularProgressIndicator()
                          : Text(_isLogin ? 'Connexion' : 'Créer un compte'),
                    ),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                      child: Text(_isLogin
                          ? 'Créer un compte'
                          : 'Déjà inscrit ? Connexion'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Connexion avec Google'),
                onPressed: _loading
                    ? null
                    : () async {
                        setState(() {
                          _loading = true;
                          _error = null;
                        });
                        try {
                          await auth.signInWithGoogle();
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            _error = e.message ?? 'Erreur Google Sign-In';
                          });
                        } catch (e) {
                          setState(() {
                            _error = 'Une erreur inconnue est survenue.';
                          });
                        } finally {
                          if (mounted) {
                            setState(() {
                              _loading = false;
                            });
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
