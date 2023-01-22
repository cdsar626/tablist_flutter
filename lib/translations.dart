import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'init': 'Initializing',
      'username': 'Username',
      'log_in' : 'Log in',
      'happy_msg01': 'Hello @username, have a nice day. :)',
      'log_out': 'Tap here to log out.',
      'pause': 'Pause',
      'abandon': 'Abandon',
      'progress': 'Progress: @num',
      'historyProgressUpdate': 'Progress has been updated',
      'historyStatusUpdate': 'Status updated to: @status',
    },
    'es': {
      'init': 'Inicializando',
      'username': 'Usuario',
      'log_in': 'Ingresar',
      'happy_msg01': 'Hola @username, ten feliz día. :)',
      'log_out': 'Tap aquí para cerrar sesión.',
      'pause': 'Pausar',
      'abandon': 'Abandonar',
      'progress': 'Progreso: @num',
      'historyProgressUpdate': 'Se actualizó progreso',
      'historyStatusUpdate': 'Se actualizó estado a: @status',
    },
  };
}