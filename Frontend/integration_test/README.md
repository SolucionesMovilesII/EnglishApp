# Pruebas E2E (End-to-End) - English App

Este directorio contiene las pruebas de integración end-to-end para la aplicación English App, enfocándose específicamente en los flujos de **Login/Logout**.

## 📋 Contenido

- `app_test.dart` - Pruebas E2E generales de la aplicación
- `login_logout_test.dart` - Pruebas específicas de autenticación
- `test_config.dart` - Configuración y helpers para las pruebas
- `README.md` - Esta documentación

## 🧪 Pruebas Implementadas

### Login/Logout Tests (`login_logout_test.dart`)

1. **Login con credenciales válidas y logout**
   - Verifica el flujo completo de autenticación
   - Prueba la navegación exitosa al home
   - Verifica el logout y regreso a login

2. **Validación de formulario de login**
   - Prueba validación de email inválido
   - Prueba validación de contraseña muy corta
   - Verifica mensajes de error apropiados

3. **Login con Google**
   - Prueba el flujo de autenticación con Google
   - Verifica navegación exitosa
   - Prueba logout posterior

4. **Login con Apple**
   - Prueba el flujo de autenticación con Apple
   - Verifica navegación exitosa
   - Prueba logout posterior

5. **Funcionalidad "Recordarme"**
   - Prueba el checkbox de recordar sesión
   - Verifica que se mantenga la selección

6. **Navegación a "Olvidé mi contraseña"**
   - Prueba la navegación a la pantalla de recuperación
   - Verifica el regreso a login

## 🚀 Cómo Ejecutar las Pruebas

### Opción 1: Script Automatizado (Recomendado)

```powershell
# Desde el directorio raíz del proyecto
.\run_e2e_tests.ps1
```

### Opción 2: Comandos Manuales

```bash
# Limpiar y obtener dependencias
flutter clean
flutter pub get

# Ejecutar pruebas específicas de login/logout
flutter test integration_test/login_logout_test.dart

# Ejecutar todas las pruebas E2E
flutter test integration_test/app_test.dart

# Ejecutar con más detalle
flutter test integration_test/login_logout_test.dart --verbose
```

### Opción 3: Ejecutar en dispositivo específico

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter test integration_test/login_logout_test.dart -d <device_id>
```

## 📱 Requisitos Previos

1. **Flutter SDK** instalado y configurado
2. **Dispositivo conectado** o **emulador ejecutándose**
3. **Dependencias instaladas** (`flutter pub get`)

### Verificar dispositivos:
```bash
flutter devices
```

### Verificar que Flutter funciona:
```bash
flutter doctor
```

## 🔧 Configuración de Pruebas

Las pruebas utilizan el archivo `test_config.dart` que contiene:

- **Timeouts configurables**
- **Datos de prueba** (emails, contraseñas)
- **Mensajes de error esperados**
- **Identificadores de pantallas**
- **Keys de widgets**
- **Funciones helper**

### Datos de Prueba por Defecto:
- Email válido: `test@example.com`
- Email inválido: `invalid-email`
- Contraseña válida: `password123`
- Contraseña corta: `short`

## 🎯 Widgets con Keys para Testing

Los siguientes widgets tienen keys específicas para las pruebas:

- `email_field` - Campo de email
- `password_field` - Campo de contraseña
- `login_button` - Botón de login
- `google_login_button` - Botón de login con Google
- `apple_login_button` - Botón de login con Apple
- `remember_me_checkbox` - Checkbox de recordar sesión

## 📊 Interpretación de Resultados

### ✅ Prueba Exitosa
```
✓ Login with valid credentials and logout
```

### ❌ Prueba Fallida
```
✗ Login form validation
  Expected: exactly one matching node in the widget tree
  Actual: _TextFinder:<zero widgets with text "Please enter a valid email address">
```

### ⚠️ Prueba Saltada
```
⚠ Forgot password navigation (SKIPPED)
```

## 🐛 Solución de Problemas

### Error: "No devices detected"
**Solución:** Conecta un dispositivo físico o inicia un emulador

### Error: "Widget not found"
**Solución:** Verifica que las keys en los widgets coincidan con las del test

### Error: "Timeout"
**Solución:** Aumenta los timeouts en `test_config.dart`

### Error: "Package not found"
**Solución:** Ejecuta `flutter pub get`

## 📝 Agregar Nuevas Pruebas

1. **Agregar nueva prueba en `login_logout_test.dart`:**

```dart
testWidgets('Nueva funcionalidad', (WidgetTester tester) async {
  // Iniciar app
  app.main();
  await TestHelpers.waitForLoading(tester);
  
  // Tu lógica de prueba aquí
  
  // Verificaciones
  expect(find.text('Resultado esperado'), findsOneWidget);
});
```

2. **Agregar nuevas configuraciones en `test_config.dart`**

3. **Agregar nuevas keys en los widgets si es necesario**

## 📈 Métricas de Cobertura

Las pruebas actuales cubren:
- ✅ Flujo de login básico
- ✅ Validación de formularios
- ✅ Login social (Google/Apple)
- ✅ Funcionalidad de recordar sesión
- ✅ Navegación entre pantallas
- ✅ Logout

## 🔄 Integración Continua

Para integrar estas pruebas en CI/CD:

```yaml
# Ejemplo para GitHub Actions
- name: Run E2E Tests
  run: |
    flutter test integration_test/login_logout_test.dart
```

## 📞 Soporte

Si encuentras problemas con las pruebas:
1. Verifica que todos los requisitos estén cumplidos
2. Revisa los logs detallados con `--verbose`
3. Consulta la documentación de Flutter Testing
4. Verifica que las keys de los widgets estén actualizadas