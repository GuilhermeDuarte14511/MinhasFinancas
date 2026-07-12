import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../finance/infrastructure/sql_connect_generated/client.dart';

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>(
  (ref) => FirebaseAuthService(FirebaseAuth.instance),
);

final class FirebaseAuthService {
  const FirebaseAuthService(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User> signIn({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;
    await ensureProfile(user);
    return user;
  }

  Future<User> signUp({
    required String displayName,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final credential = await _auth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(displayName.trim());
    await user.sendEmailVerification();
    await ensureProfile(user, fallbackDisplayName: displayName.trim());
    return user;
  }

  Future<User> signInWithGoogle() async {
    final provider = GoogleAuthProvider()
      ..addScope('email')
      ..addScope('profile');
    final credential = kIsWeb
        ? await _auth.signInWithPopup(provider)
        : await _auth.signInWithProvider(provider);
    final user = credential.user!;
    await ensureProfile(user);
    return user;
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Nenhuma conta autenticada.');
    await user.sendEmailVerification();
  }

  Future<bool> reloadAndCheckEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    await user.reload();

    final refreshedUser = _auth.currentUser;
    if (refreshedUser == null || !refreshedUser.emailVerified) {
      return false;
    }

    // Renova o token para que o Data Connect receba email_verified = true.
    await refreshedUser.getIdToken(true);
    return true;
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> updateProfile({required String displayName}) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Nenhuma conta autenticada.');
    final name = displayName.trim();
    if (name.length < 3) throw StateError('Informe seu nome completo.');
    await user.updateDisplayName(name);
    await ClientConnector.instance.updateMyProfile(displayName: name).execute();
  }

  Future<void> ensureProfile(User user, {String? fallbackDisplayName}) async {
    final result = await ClientConnector.instance.getMyProfile().execute(
      fetchPolicy: QueryFetchPolicy.serverOnly,
    );
    if (result.data.userProfiles.isNotEmpty) return;

    final email = user.email?.trim().toLowerCase();
    if (email == null || email.isEmpty) {
      throw StateError('A conta autenticada não possui e-mail.');
    }
    final displayName = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : fallbackDisplayName?.trim().isNotEmpty == true
        ? fallbackDisplayName!.trim()
        : email.split('@').first;
    await ClientConnector.instance
        .createMyProfile(displayName: displayName)
        .execute();
  }
}

String friendlyAuthError(Object error) {
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'invalid-email' => 'Informe um e-mail válido.',
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' => 'E-mail ou senha incorretos.',
      'email-already-in-use' => 'Já existe uma conta com este e-mail.',
      'weak-password' => 'Escolha uma senha mais forte.',
      'user-disabled' => 'Esta conta foi desativada.',
      'too-many-requests' => 'Muitas tentativas. Aguarde alguns minutos.',
      'network-request-failed' => 'Sem conexão. Verifique sua internet.',
      'popup-closed-by-user' ||
      'web-context-canceled' => 'O acesso com Google foi cancelado.',
      _ => 'Não foi possível autenticar. Tente novamente.',
    };
  }
  return 'Não foi possível concluir o acesso. Tente novamente.';
}
