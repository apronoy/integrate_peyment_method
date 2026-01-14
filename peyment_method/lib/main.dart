import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:peyment_method/fetchdata/availableScreen.dart';

 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51S7Im3Jy6xrDDgiXC5uPZDKkBZLViVOYxTnDA1KogrPMXyHDORSLuUA8QF0sC6BywuxzP4bNYsqvRlZSN4fMIoEw00V4oMIlRs';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: AircraftScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final token='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzY4MTAwNzgzLCJpYXQiOjE3NjgwNzE5ODMsImp0aSI6ImJhZmM5YTM1OThiNzRmYzQ4MGRkODFlMzVlZmJlZDkwIiwidXNlcl9pZCI6IjM2In0.eISCjlU17mCsoG_slyBaZFvL8R-wyFSZ5K01ySsek5w';
  bool isloading = false;
  final Dio dio = Dio(
    BaseOptions(baseUrl: 'https://overrigged-botanically-lila.ngrok-free.dev'),
  );

  Future makePayment() async {
    setState(() {
      isloading = true;
    });

    try {
      final response = await dio.post(
        'https://overrigged-botanically-lila.ngrok-free.dev/booked/api/payment/',
        
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':'Bearer $token',
          },
        ),
        data: {
          "booking_id": 123,
          "amount": 1000000,
          "operator_id": "102",
          "aircraft_id": "2123",
          "flight_date": "2026-01-05T10:30:00Z",
          "passengers": 2,
          "form": "Dhaka",
          "to": "Feni",
          "currency": "usd",
          
        },
      );
      if (response.statusCode != 201) {
        throw Exception('Server error :${response.data}');
      }

      final clientSecret = response.data['client_secret'];

     await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret:clientSecret,
          merchantDisplayName: 'Pronoy',
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment is successful')));
    } catch (e) {
      print('The error is $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('error $e')));
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isloading
            ? CircularProgressIndicator()
            : ElevatedButton(onPressed: makePayment, child: Text('Pay Now')),
      ),
    );
  }
}
