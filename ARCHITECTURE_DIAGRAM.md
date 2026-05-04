# Architecture Diagram: Form State Management

## 🏗️ Clean Architecture Flow (Preserved)

```
┌─────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                      │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  PersonalInformationScreen (StatefulWidget)                  │
│  ├── TextEditingControllers (final)                          │
│  ├── _isDataInitialized (guard flag)                         │
│  ├── _initializeFormData() (with guard)                      │
│  └── dispose() (cleanup)                                     │
│                                                               │
│  BlocBuilder<PatientAuthCubit, PatientAuthState>             │
│  ├── PatientAuthLoading → CircularProgressIndicator          │
│  ├── PatientDataSuccess → _initializeFormData() → Form       │
│  └── PatientAuthError → Error UI with Retry                  │
│                                                               │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ context.read<PatientAuthCubit>()
                        │
┌───────────────────────▼─────────────────────────────────────┐
│                      BUSINESS LOGIC LAYER                    │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  PatientAuthCubit                                            │
│  ├── meData() method                                         │
│  ├── emit(PatientAuthLoading())                              │
│  ├── call MeDataUseCase                                      │
│  └── emit(PatientDataSuccess/Error)                          │
│                                                               │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ meDataUseCase()
                        │
┌───────────────────────▼─────────────────────────────────────┐
│                      DOMAIN LAYER                            │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  MeDataUseCase                                               │
│  └── call() → authRepoInterface.meData()                     │
│                                                               │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ meData()
                        │
┌───────────────────────▼─────────────────────────────────────┐
│                      DATA LAYER                              │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  RepoImpl (implements AuthRepoInterface)                     │
│  └── meData()                                                │
│      ├── _api.get(ApiEndpoints.patientMe)                    │
│      ├── Handle wrapped/unwrapped response                   │
│      ├── MeDataModel.fromJson()                              │
│      └── return Right(model) or Left(failure)                │
│                                                               │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ HTTP GET
                        │
┌───────────────────────▼─────────────────────────────────────┐
│                      NETWORK LAYER                           │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ApiService (Dio)                                            │
│  ├── AuthInterceptor (adds Bearer token)                     │
│  └── GET /api/Auth/me                                        │
│                                                               │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ API Response
                        │
┌───────────────────────▼─────────────────────────────────────┐
│                      BACKEND API                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔄 State Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    USER OPENS SCREEN                         │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  BlocProvider already exists at MainScreen level            │
│  (Data already loaded from HomeScreen)                       │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  BlocBuilder receives PatientDataSuccess                     │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  _initializeFormData(state.meData) called                    │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  Guard Check: _isDataInitialized?                           │
├─────────────────────────────────────────────────────────────┤
│  false (first time)                                          │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  Set controller values:                                      │
│  ├── nameController.text = user.fullName                     │
│  ├── emailController.text = user.email                       │
│  └── ... other fields                                        │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  _isDataInitialized = true                                   │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  Form rendered with data                                     │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  USER EDITS FIELDS                                           │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  Widget rebuilds (scroll, setState, etc.)                    │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  _initializeFormData(state.meData) called again              │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  Guard Check: _isDataInitialized?                           │
├─────────────────────────────────────────────────────────────┤
│  true (already initialized)                                  │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  return early (no reassignment)                              │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  USER INPUT PRESERVED ✅                                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛡️ Guard Pattern Visualization

```
┌──────────────────────────────────────────────────────────────┐
│                    FIRST CALL                                 │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  void _initializeFormData(MeDataModel user) {                │
│    if (_isDataInitialized) return; // false → continue       │
│                                                               │
│    nameController.text = user.fullName;  ✅ EXECUTED         │
│    emailController.text = user.email;    ✅ EXECUTED         │
│                                                               │
│    _isDataInitialized = true;            ✅ FLAG SET         │
│  }                                                            │
│                                                               │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                    SECOND CALL (Rebuild)                      │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  void _initializeFormData(MeDataModel user) {                │
│    if (_isDataInitialized) return; // true → RETURN EARLY    │
│                                      🛡️ GUARD BLOCKS         │
│    nameController.text = user.fullName;  ❌ NOT EXECUTED     │
│    emailController.text = user.email;    ❌ NOT EXECUTED     │
│                                                               │
│    _isDataInitialized = true;            ❌ NOT REACHED      │
│  }                                                            │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

---

## 🔄 Widget Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│  1. createState()                                            │
│     └── _PersonalInformationScreenState created             │
│         ├── Controllers initialized (final)                  │
│         └── _isDataInitialized = false                       │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  2. build()                                                  │
│     └── BlocBuilder receives state                           │
│         └── _initializeFormData() called (guarded)           │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  3. User interaction / setState / Parent rebuild             │
│     └── build() called again                                 │
│         └── _initializeFormData() called (guard blocks)      │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  4. dispose()                                                │
│     └── All controllers disposed                             │
│         ├── nameController.dispose()                         │
│         ├── emailController.dispose()                        │
│         └── ... other controllers                            │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 Memory Management

```
┌─────────────────────────────────────────────────────────────┐
│                    BEFORE (Memory Leak)                      │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Screen opened                                               │
│  ├── Controllers created ✅                                  │
│  └── Stored in memory                                        │
│                                                               │
│  Screen closed                                               │
│  ├── Widget destroyed                                        │
│  └── Controllers still in memory ❌ LEAK!                    │
│                                                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    AFTER (Proper Cleanup)                    │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Screen opened                                               │
│  ├── Controllers created ✅                                  │
│  └── Stored in memory                                        │
│                                                               │
│  Screen closed                                               │
│  ├── dispose() called                                        │
│  ├── Controllers disposed ✅                                 │
│  └── Memory released ✅                                      │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Dependency Injection Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    main.dart                                 │
│  ├── WidgetsFlutterBinding.ensureInitialized()              │
│  ├── await init() // Initialize GetIt                       │
│  └── runApp(Healing())                                       │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                    injection_container.dart                  │
│  ├── sl.registerLazySingleton<ApiService>()                 │
│  ├── sl.registerLazySingleton<AuthRepoInterface>()          │
│  ├── sl.registerLazySingleton<MeDataUseCase>()              │
│  └── sl.registerFactory<PatientAuthCubit>()                 │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                    MainScreen (layout_screen.dart)           │
│  BlocProvider(                                               │
│    create: (_) => sl<PatientAuthCubit>()..meData(),         │
│    child: Scaffold with BottomNavigationBar                  │
│  )                                                            │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                    PersonalInformationScreen                 │
│  Uses existing PatientAuthCubit from MainScreen              │
│  (No new BlocProvider needed)                                │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔐 State Management Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                    PatientAuthState                          │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  PatientAuthInitial                                          │
│  ├── Initial state when Cubit is created                     │
│  └── UI: Show nothing or placeholder                         │
│                                                               │
│  PatientAuthLoading                                          │
│  ├── Emitted when API call starts                            │
│  └── UI: Show CircularProgressIndicator                      │
│                                                               │
│  PatientDataSuccess(MeDataModel meData)                      │
│  ├── Emitted when API call succeeds                          │
│  └── UI: Initialize form and show data                       │
│                                                               │
│  PatientAuthError(String message)                            │
│  ├── Emitted when API call fails                             │
│  └── UI: Show error message with retry button                │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎨 UI State Mapping

```
┌─────────────────────────────────────────────────────────────┐
│  BlocBuilder<PatientAuthCubit, PatientAuthState>            │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  if (state is PatientAuthLoading)                            │
│    └── return CircularProgressIndicator()                    │
│                                                               │
│  if (state is PatientDataSuccess)                            │
│    ├── _initializeFormData(state.meData)                     │
│    └── return Form with TextFields                           │
│                                                               │
│  if (state is PatientAuthError)                              │
│    └── return Error UI with Retry button                     │
│                                                               │
│  return SizedBox() // Empty state                            │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ Summary

This architecture ensures:
- ✅ Clean separation of concerns
- ✅ Proper state management
- ✅ No memory leaks
- ✅ User input preservation
- ✅ Error handling
- ✅ Reusable Cubit instances
- ✅ Production-ready code
