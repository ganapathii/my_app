import 'package:flutter/material.dart';
import 'package:my_app/current_location_screen.dart';
import 'package:my_app/database_helper.dart';
import 'package:my_app/loginforms/signuppage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseHelper _db = DatabaseHelper();
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
           backgroundColor: Color.fromARGB(255, 2, 1, 49),
        ),
        backgroundColor: Color.fromARGB(255, 2, 1, 49),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
               Padding(
                 padding: const EdgeInsets.all(42.0),
                 child: Image.asset('assets/locations.png',
                 scale: 2.7,
                 ),
               ),

                Form(
                  key: _formKey,
                  child: Container(
            
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromARGB(255, 235, 235, 235)),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(
                                  color: Color.fromARGB(200, 15, 15, 15),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12,),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Email",
                                  style: TextStyle(
                                    color: Color.fromARGB(218, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Enter email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              prefixIcon: Icon(Icons.mail_outline_outlined,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 14),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Password",
                                  style: TextStyle(
                                    color: Color.fromARGB(218, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Enter password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              prefixIcon: Icon(Icons.lock_outline_rounded)
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 30),
                          ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(300.0, 45.0),
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 2, 1, 49),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailController.text;
                                final password = _passwordController.text;
                                final user = await _db.getUserByEmail(email);

                                if (user != null && user.password == password) {
                                  setState(() {
                                    _status = 'Login Successful';
                                  });

                             
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CurrentLocationScreen(),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _status = 'Invalid email or password!';
                                  });

                                
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Invalid email or password',
                                        style: TextStyle(
                                          color: Colors.red
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text('LOGIN'),
                          ),

                          

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupPage()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Don\'t have an account?',
                                  style: TextStyle(color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(_status,
                          style: TextStyle(
                            color: Colors.red
                          ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


