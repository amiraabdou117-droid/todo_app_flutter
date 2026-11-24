import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/core/failures/auth_failures.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/core/firebase/auth_service.dart';
import 'package:todo_app/core/network/network_info.dart';
import 'package:todo_app/features/auth/data/datasources/user_data_source.dart';
import 'package:todo_app/features/auth/data/models/user_model.dart';
import 'package:todo_app/features/auth/domain/entities/user_entity.dart';
import 'package:todo_app/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource userDataSource;
  final NetwortkInfo networkInfo;
  final AuthService authService;

  UserRepositoryImpl({
    required this.userDataSource,
    required this.networkInfo,
    required this.authService,
  });

  @override
  Future<Either<Failure, Unit>> registerUser(UserEntity user) async {
    //Adapter entity -> model
    UserModel userModel = UserModel(
      uid: user.uid,
      name: user.name,
      email: user.email,
      profileURL: user.profilURL,
      password: user.password,
    );

    if (await networkInfo.isConnected) {
      try {
        await userDataSource.registerUser(userModel);
        return const Right(unit);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return Left(RegisterUserWeakPwdFailure());
        } else if (e.code == 'email-already-in-use') {
          return Left(RegisterUserUsedEmailFailure());
        } else {
          return Left(RegisterUserFailure());
        }
      } catch (e) {
        return Left(RegisterUserFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signIn(UserEntity user) async {
    //Adapter
    UserModel userModel = UserModel(
      uid: user.uid,
      name: user.name,
      email: user.email,
      profileURL: user.profilURL,
      password: user.password,
    );

    if (await networkInfo.isConnected) {
      try {
        await userDataSource.signInUser(userModel);
        return const Right(unit);
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'user-not-found':
            return Left(SignInUserNotFoundFailure());
          // Firebase récent : invalid-credential remplace wrong-password
          // (et parfois user-not-found, pour empêcher de deviner quels
          // e-mails ont un compte).
          case 'wrong-password':
          case 'invalid-credential':
          case 'invalid-login-credentials':
            return Left(SignInWrongPwdFailure());
          default:
            return Left(SignInFailure());
        }
      } catch (e) {
        return Left(SignInFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    if (await networkInfo.isConnected) {
      await authService.signOut();
      return const Right(unit);
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUser(UserEntity user) async {
    UserModel userModel = UserModel(
      uid: user.uid,
      name: user.name,
      email: user.email,
      profileURL: user.profilURL,
      password: user.password,
    );
    if (await networkInfo.isConnected) {
      await authService.currentUser?.updateDisplayName(userModel.name);

      await authService.currentUser?.updatePhotoURL(userModel.profilURL);
      return const Right(unit);
    } else {
      return Left(OfflineFailure());
    }
  }
}