# Quick Reference: TextEditingController + Bloc Pattern

## ✅ The Correct Pattern

```dart
class _MyFormScreenState extends State<MyFormScreen> {
  // 1️⃣ Declare controllers as final
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  
  // 2️⃣ Add initialization guard
  bool _isDataInitialized = false;
  
  // 3️⃣ Create initialization method with guard
  void _initializeFormData(UserData data) {
    if (_isDataInitialized) return; // 🛡️ Guard
    
    nameController.text = data.name;
    emailController.text = data.email;
    
    _isDataInitialized = true;
  }
  
  // 4️⃣ Always dispose controllers
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
  
  // 5️⃣ Call initialization in BlocBuilder
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCubit, MyState>(
      builder: (context, state) {
        if (state is DataLoaded) {
          _initializeFormData(state.data); // ✅ Guarded initialization
          return Form(...);
        }
      }
    );
  }
}
```

---

## ❌ Common Mistakes to Avoid

### Mistake 1: Setting controller.text in build()
```dart
// ❌ WRONG
BlocBuilder<MyCubit, MyState>(
  builder: (context, state) {
    if (state is DataLoaded) {
      nameController.text = state.data.name; // ❌ Runs on every rebuild!
      return Form(...);
    }
  }
)
```

### Mistake 2: Using late var
```dart
// ❌ WRONG
late var nameController = TextEditingController();

// ✅ CORRECT
final nameController = TextEditingController();
```

### Mistake 3: No dispose method
```dart
// ❌ WRONG - Memory leak!
class _MyFormScreenState extends State<MyFormScreen> {
  final nameController = TextEditingController();
  // No dispose method
}

// ✅ CORRECT
@override
void dispose() {
  nameController.dispose();
  super.dispose();
}
```

### Mistake 4: No initialization guard
```dart
// ❌ WRONG - Overwrites user input
void _initializeFormData(UserData data) {
  nameController.text = data.name; // Runs every time!
}

// ✅ CORRECT
void _initializeFormData(UserData data) {
  if (_isDataInitialized) return; // Guard
  nameController.text = data.name;
  _isDataInitialized = true;
}
```

---

## 🎯 When to Use This Pattern

✅ **Use when:**
- Form needs to be pre-filled with API data
- User should be able to edit the pre-filled data
- Data comes from Bloc/Cubit state
- You need programmatic control over TextFields

❌ **Don't use when:**
- Form is always empty (no pre-fill needed)
- Data never changes after initial load
- Simple static forms

---

## 🔄 Alternative Patterns

### Option 1: BlocListener (More Explicit)
```dart
@override
Widget build(BuildContext context) {
  return BlocListener<MyCubit, MyState>(
    listener: (context, state) {
      if (state is DataLoaded && !_isDataInitialized) {
        _initializeFormData(state.data);
      }
    },
    child: BlocBuilder<MyCubit, MyState>(
      builder: (context, state) {
        return Form(...); // Pure UI, no side effects
      },
    ),
  );
}
```

### Option 2: initialValue (No Controllers)
```dart
// If you don't need programmatic control
TextField(
  initialValue: user.name,
  onChanged: (value) => updatedName = value,
)
```

---

## 🐛 Debugging Checklist

If form data is being reset:
- [ ] Check if controller.text is set inside build()
- [ ] Check if initialization guard exists
- [ ] Check if guard flag is being set to true
- [ ] Add print statements to verify guard is working
- [ ] Check if dispose() is implemented

If memory issues:
- [ ] Verify all controllers have dispose() calls
- [ ] Check for controller leaks with DevTools

If data not loading:
- [ ] Verify Cubit is provided correctly
- [ ] Check if meData() is being called
- [ ] Add print statements in initialization method
- [ ] Check BlocBuilder is listening to correct Cubit

---

## 📊 Performance Tips

1. **Use final, not late var**
   - `final` is initialized immediately
   - `late var` can cause null issues

2. **Always dispose controllers**
   - Prevents memory leaks
   - Releases native resources

3. **Use guard pattern**
   - Prevents unnecessary reassignments
   - Improves performance

4. **Reuse Cubit instances**
   - Don't create new BlocProvider for every screen
   - Use existing instance from parent

---

## 🎓 Key Takeaways

1. **Never set controller.text inside build()**
   - Build can be called multiple times
   - Will overwrite user input

2. **Always use initialization guard**
   - Prevents data from being reset
   - Preserves user input

3. **Always dispose controllers**
   - Prevents memory leaks
   - Flutter best practice

4. **Separate side effects from UI**
   - Use separate initialization method
   - Keep build() pure

5. **Handle all states**
   - Loading, Success, Error
   - Provide good UX

---

## 📝 Copy-Paste Template

```dart
class _MyFormScreenState extends State<MyFormScreen> {
  // Controllers
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  
  // Guard
  bool _isDataInitialized = false;
  
  // Initialize
  void _initializeFormData(MyData data) {
    if (_isDataInitialized) return;
    controller1.text = data.field1;
    controller2.text = data.field2;
    _isDataInitialized = true;
  }
  
  // Dispose
  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }
  
  // Build
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCubit, MyState>(
      builder: (context, state) {
        if (state is Loading) return LoadingWidget();
        if (state is Success) {
          _initializeFormData(state.data);
          return FormWidget();
        }
        if (state is Error) return ErrorWidget();
        return EmptyWidget();
      }
    );
  }
}
```

---

## 🚀 Production Checklist

Before deploying:
- [ ] All controllers have dispose()
- [ ] Initialization guard is implemented
- [ ] No controller.text in build()
- [ ] Error states are handled
- [ ] Loading states are shown
- [ ] Debug prints removed (or conditional)
- [ ] Memory leaks checked with DevTools
- [ ] User input preservation tested
- [ ] Form validation added (if needed)
- [ ] Save functionality implemented

---

**Remember:** The guard pattern is your friend! 🛡️
