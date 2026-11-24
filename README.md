# TODO APP — Flutter, Clean Architecture, Firebase

Application de gestion de tâches développée dans le cadre de l'atelier
**Cross-Platform** (DSI32, ISET Bizerte, 2026-2027).
Projet individuel réalisé par **[Ton nom]**.

## Fonctionnalités

- Inscription, connexion et déconnexion (Firebase Authentication, e-mail / mot de passe)
- Gestion des tâches : ajouter, consulter, modifier, cocher (terminée) et supprimer
- Suppression logique : la tâche reste en base avec `isDeleted = true`
- Données isolées par utilisateur (`users/{uid}/tasks` dans Firestore)
- Écran de profil (nom, e-mail, déconnexion)
- Thème clair / sombre (Material 3, police Montserrat)
- Gestion de la connexion internet et des erreurs (messages explicites)

## Architecture

Clean Architecture, avec le flux suivant :

```
Bloc → UseCase → Repository (abstract) ← RepositoryImpl → DataSource → Firebase
                      ↑
         Either<Failure, T> (dartz)
```

```
lib/
├── core/            di (get_it), router (go_router), failures, exceptions,
│                    network, strings, themes, widgets
└── features/
    ├── auth/        domain / data / presentation
    └── tasks/
        ├── domain/        entité, contrat du repository, use cases
        ├── data/          modèle, datasource Firestore, repository
        └── presentation/  blocs, écrans, widgets
```

| Couche | Rôle |
|---|---|
| Domain | Règles métier, sans dépendance à Flutter ni à Firebase |
| Data | Accès à Firestore, conversion Entité ↔ Modèle, exceptions → Failures |
| Presentation | Blocs (état) et interface (écrans, widgets) |

## Technologies

Flutter, flutter_bloc, equatable, get_it, go_router, dartz,
internet_connection_checker, firebase_core, firebase_auth, cloud_firestore.

## Lancer le projet

```
flutter pub get
flutter run
```

Le projet est relié à un projet Firebase par `lib/firebase_options.dart`
(généré avec `flutterfire configure`). Pour utiliser ton propre projet :
activer **Authentication (e-mail / mot de passe)** et **Firestore**, puis relancer
`flutterfire configure`.

## Règles Firestore

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Tests

```
flutter test
```

Tests unitaires du use case `CompleteTask` (repository simulé avec mocktail)
et du modèle `TaskModel`.