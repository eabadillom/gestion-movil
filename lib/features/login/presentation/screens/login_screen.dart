import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/loggers/logger_singleton.dart';
import 'package:gestion_movil/features/login/presentation/providers/login_provider.dart';
import 'package:gestion_movil/features/login/presentation/providers/login_form_provider.dart';
import 'package:gestion_movil/features/shared/shared.dart';

final LoggerSingleton log = LoggerSingleton.getInstance('LoginScreen');

class LoginScreen extends StatelessWidget 
{
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                Image.asset(
                  'assets/images/login.png',
                  width: 400,
                  height: 200,
                  colorBlendMode: BlendMode.darken,
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inventory, color: Colors.blueAccent, size: 28),
                      SizedBox(width: 8),
                      Text(
                        "Sistema de Inventarios",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.receipt, color: Colors.blueAccent, size: 28),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: size.height - 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: const _LoginForm(),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget 
{
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}


class _LoginFormState extends ConsumerState<_LoginForm> 
{

  @override
  void initState() 
  {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final estadoActual = ref.read(loginProvider);
      
      if (estadoActual.errorMessage.isNotEmpty) {
        CustomSnackBarCentrado.mostrar(
          context,
          mensaje: estadoActual.errorMessage,
          tipo: SnackbarTipo.error,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final loginForm = ref.watch(loginFormProvider);

    ref.listen<LoginState>(loginProvider, (previous, next)
    {
      if(next.errorMessage.isEmpty) return;

      if(previous?.errorMessage == next.errorMessage) return;

      CustomSnackBarCentrado.mostrar(
        context,
        mensaje: next.errorMessage,
        tipo: SnackbarTipo.error,
      );
    });
    
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Inicia Sesión', style: textStyles.titleLarge ),
          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Num. Empleado',
            keyboardType: TextInputType.name,
            onChanged: ref.read(loginFormProvider.notifier).onNumeroEmpleadoChange,
            errorMessage: loginForm.isFormPosted ? loginForm.numeroEmpleado.errorMessage : null,
          ),
          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Usuario',
            keyboardType: TextInputType.name,
            onChanged: ref.read(loginFormProvider.notifier).onNameChange,
            errorMessage: loginForm.isFormPosted ? loginForm.nombre.errorMessage : null,
          ),
          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Contraseña',
            isPasswordField: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
            errorMessage: loginForm.isFormPosted ? 
            loginForm.contrasenia.errorMessage : null,
          ),
    
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Ingresar',
              buttonColor: Colors.lightBlueAccent,
              onPressed: () 
              {
                ref.read(loginFormProvider.notifier).onFormSubmit();
              },
            )
          ),
                    
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}