import 'package:flutter/material.dart';
import 'package:my_app/loginforms/loginpage.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 4, 1, 32),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 52,),
              Text(
                "Welcome to ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 35,
                ),
              ),
              Text(
                "Live Locations History",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 35,
                ),
              ),
            
              SizedBox(height: 24,),
              Center(
                child: Image.asset(
                  'assets/maps.png',
                ),
              ),
              SizedBox(height: 32,), 
             
              Center(
                child: Text(
                  "      Explore your location history \n in real-time with our app. "
                  "Track your journeys, view past routes, and more!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
                SizedBox(height: 30,),
              Center(
                child: ElevatedButton(
                 onPressed: () {
   
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: Color.fromARGB(250, 14, 1, 70),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, 
                    onPrimary: Colors.white, 
                    minimumSize: Size(300, 40), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), 
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
