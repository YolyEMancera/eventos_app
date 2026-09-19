import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarPasswordController =
      TextEditingController();

  final ImagePicker picker = ImagePicker();

  File? fotoPerfil;

  bool ocultarPassword = true;
  bool ocultarConfirmarPassword = true;

  // Seleccionar una foto desde la galería
  Future<void> seleccionarGaleria() async {
    final XFile? imagen = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imagen != null) {
      setState(() {
        fotoPerfil = File(imagen.path);
      });
    }
  }

  // Tomar una foto con la cámara
  Future<void> tomarFoto() async {
    final XFile? imagen = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (imagen != null) {
      setState(() {
        fotoPerfil = File(imagen.path);
      });
    }
  }

  // Mostrar las opciones de cámara o galería
  void seleccionarFoto() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  tomarFoto();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar de galería'),
                onTap: () {
                  Navigator.pop(context);
                  seleccionarGaleria();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Validar y registrar usuario
  void registrarUsuario() {
    String nombre = nombreController.text.trim();
    String correo = correoController.text.trim();
    String password = passwordController.text;
    String confirmarPassword = confirmarPasswordController.text;

    if (nombre.isEmpty ||
        correo.isEmpty ||
        password.isEmpty ||
        confirmarPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
        ),
      );
      return;
    }

    if (password != confirmarPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuario registrado correctamente'),
      ),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    passwordController.dispose();
    confirmarPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              'CREAR CUENTA',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // Foto de perfil
            GestureDetector(
              onTap: seleccionarFoto,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade100,
                backgroundImage:
                    fotoPerfil != null ? FileImage(fotoPerfil!) : null,
                child: fotoPerfil == null
                    ? const Icon(
                        Icons.person,
                        size: 65,
                        color: Colors.blue,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 10),

            TextButton.icon(
              onPressed: seleccionarFoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Agregar foto de perfil'),
            ),

            const SizedBox(height: 20),

            // Nombre
            TextField(
              controller: nombreController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ingresa tu nombre',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Correo
            TextField(
              controller: correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'ejemplo@correo.com',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Contraseña
            TextField(
              controller: passwordController,
              obscureText: ocultarPassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    ocultarPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      ocultarPassword = !ocultarPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Confirmar contraseña
            TextField(
              controller: confirmarPasswordController,
              obscureText: ocultarConfirmarPassword,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    ocultarConfirmarPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      ocultarConfirmarPassword =
                          !ocultarConfirmarPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Botón registrar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: registrarUsuario,
                child: const Text(
                  'REGISTRARSE',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              '¿Ya tienes una cuenta?',
              style: TextStyle(fontSize: 15),
            ),

            TextButton(
  onPressed: () {
    Navigator.pushNamed(context, '/login');
  },
  child: const Text('Iniciar sesión'),
),
          ],
        ),
      ),
    );
  }
}