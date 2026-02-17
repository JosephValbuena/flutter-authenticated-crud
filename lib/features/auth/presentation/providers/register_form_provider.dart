

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../shared/infrastructure/inputs/inputs.dart';

final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  return RegisterFormNotifier();
});

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier(): super(RegisterFormState());

  onNameChange( String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([newName, state.email, state.password, state.rePassword])
    );
  }

  onEmailChange( String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.name, state.password, state.rePassword])
    );
  }

  onPasswordChange( String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.name, state.email, state.rePassword])
    );
  }

  onRePasswordChange( String value) {
    final newRePassword = Password.dirty(value);
    state = state.copyWith(
      rePassword: newRePassword,
      isValid: (newRePassword == state.password) && Formz.validate([newRePassword, state.name, state.email, state.rePassword])
    );
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;

    print(state);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password])
    );
  }
}

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final Email email;
  final Password password;
  final Password rePassword;

  RegisterFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.name = const Name.pure(), 
    this.email = const Email.pure(), 
    this.password = const Password.pure(), 
    this.rePassword = const Password.pure()
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
    Email? email,
    Password? password,
    Password? rePassword  
  }) => RegisterFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    rePassword: rePassword ?? this.rePassword
  );

  @override
  String toString() {
    return '''
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      isValid: $isValid
      name: $name
      email: $email
      password: $password
      rePassword: $rePassword
    ''';
  }
}