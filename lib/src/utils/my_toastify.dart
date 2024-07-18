import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart';

// Ejemplo de cómo mostrar un toast
void showMyToast(BuildContext context) {
  showToast(
  context,
  Toast(
    title: 'Hi!',
    description: 'This is toast',
  ),
);

}

// Llamar a esta función desde cualquier parte donde necesites mostrar un toast
// Por ejemplo, después de una acción como registrar o editar un cliente.
