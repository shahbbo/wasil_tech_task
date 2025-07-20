import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/cart/presentation/bloc/cart_cubit.dart';
import 'features/products/presentation/bloc/product_cubit.dart';
import 'features/products/presentation/pages/product_list_page.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(create: (_) => di.sl<ProductCubit>()),
        BlocProvider(create: (_) => di.sl<CartCubit>()),
      ],
      child: MaterialApp(
        title: 'Product List App',
        home: const ProductListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
