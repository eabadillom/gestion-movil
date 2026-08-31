import 'package:flutter/material.dart';

const colorSeed = Color(0xff424CB8);
const scaffoldBackgroundColor = Color.fromARGB(255, 247, 247, 248);

const Color _customColor = Color( 0xFF5C11D4 ); 
const colorList = <Color> [
  _customColor,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.green,
  Colors.orange,
  Colors.pink,
  Colors.white,
];

class AppTheme {
  final int selectedColor;
  final bool isDarkmode;

  AppTheme({
    this.selectedColor = 0,
    this.isDarkmode = false,
  })  : assert(selectedColor >= 0, 'Selected color must be greater than 0'),
        assert(selectedColor < colorList.length,
            'Selected color must be less than ${colorList.length}');

  ThemeData getTheme() {
    // Definimos los azules que querías
    const Color azulClaroApp = Color.fromARGB(255, 92, 155, 228);
    const Color azulMedioOscuro = Color(0xFF1A237E); // Un azul profundo para modo Dark

    return ThemeData(
      useMaterial3: true,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,
      colorSchemeSeed: colorList[selectedColor],
      scaffoldBackgroundColor: isDarkmode ? const Color(0xFF121212) : scaffoldBackgroundColor,

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: "MontserratAlternates",
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontFamily: "MontserratAlternates",
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          fontFamily: "MontserratAlternates",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Configuración de AppBar automática
      appBarTheme: AppBarTheme(
        // Aquí ocurre la magia del cambio de azul
        backgroundColor: isDarkmode ? azulMedioOscuro : azulClaroApp,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: "MontserratAlternates",
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Blanco siempre resalta bien en estos azules
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Configuración de Botones
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontFamily: "MontserratAlternates",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      
      // Configuración de ExpansionTile (para tus secciones de plantas)
      expansionTileTheme: ExpansionTileThemeData(
        collapsedIconColor: isDarkmode ? Colors.white70 : Colors.black54,
        iconColor: isDarkmode ? Colors.blueAccent : azulClaroApp,
        textColor: isDarkmode ? Colors.white : Colors.black,
      ),
    );
  }

  // Método para copiar el estado y actualizar el tema
  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkmode,
  }) =>
      AppTheme(
        selectedColor: selectedColor ?? this.selectedColor,
        isDarkmode: isDarkmode ?? this.isDarkmode,
      );
}
