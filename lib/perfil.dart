import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'barra_navegacion.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final TextEditingController nombreController = TextEditingController(
    text: 'Usuario de Eventos',
  );

  final TextEditingController correoController = TextEditingController(
    text: 'usuario@correo.com',
  );

  final TextEditingController passwordController = TextEditingController(
    text: '123456',
  );

  final ImagePicker picker = ImagePicker();

  File? fotoPerfil;

  bool modoEdicion = false;
  bool ocultarPassword = true;

  Future<void> cambiarFoto() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar foto'),
                onTap: () async {
                  Navigator.pop(context);

                  final XFile? imagen = await picker.pickImage(
                    source: ImageSource.camera,
                  );

                  if (imagen != null) {
                    setState(() {
                      fotoPerfil = File(imagen.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar de galería'),
                onTap: () async {
                  Navigator.pop(context);

                  final XFile? imagen = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (imagen != null) {
                    setState(() {
                      fotoPerfil = File(imagen.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void editarPerfil() {
    setState(() {
      modoEdicion = true;
    });
  }

  void guardarPerfil() {
    setState(() {
      modoEdicion = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Información actualizada correctamente')),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BarraNavegacion(indiceActual: 3),
      appBar: AppBar(title: const Text('Mi perfil'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              'MI PERFIL',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: fotoPerfil != null
                  ? FileImage(fotoPerfil!)
                  : null,
              child: fotoPerfil == null
                  ? const Icon(Icons.person, size: 70, color: Colors.blue)
                  : null,
            ),

            const SizedBox(height: 10),

            TextButton.icon(
              onPressed: modoEdicion ? cambiarFoto : null,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Cambiar foto'),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: nombreController,
              enabled: modoEdicion,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: correoController,
              enabled: modoEdicion,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              enabled: modoEdicion,
              obscureText: ocultarPassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    ocultarPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      ocultarPassword = !ocultarPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (!modoEdicion)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: editarPerfil,
                  icon: const Icon(Icons.edit),
                  label: const Text('EDITAR', style: TextStyle(fontSize: 16)),
                ),
              ),

            if (modoEdicion)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: guardarPerfil,
                  icon: const Icon(Icons.save),
                  label: const Text('GUARDAR', style: TextStyle(fontSize: 16)),
                ),
              ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
