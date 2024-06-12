import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BooksApp Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LeadsPage(),
    );
  }
}

class LeadsPage extends StatefulWidget {
  @override
  _LeadsPageState createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  List<dynamic> _leads = [];
  List<dynamic> _filteredLeads = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeads();
  }

  Future<void> _fetchLeads() async {
    try {
      final leads = await ApiService.getLeads('6668baaed6a4670012a6e406');
      setState(() {
        _leads = leads;
        _filteredLeads = leads;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error
    }
  }

  void _filterLeads(String query) {
    final filtered = _leads.where((lead) {
      final firstName = lead['firstName'] ?? '';
      final lastName = lead['lastName'] ?? '';
      final fullName = '$firstName $lastName';
      return fullName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredLeads = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade900,
        title: Text('Flutter Tutorial', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[850],
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500,),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  hintText: "List view Search"
              ),

              onChanged: _filterLeads,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLeads.length,
              itemBuilder: (context, index) {
                final lead = _filteredLeads[index];
                final firstName = lead['firstName'] ?? '';
                final lastName = lead['lastName'] ?? '';
                final email = lead['email'] ?? '';
                final imageURL = lead['imageURL'] ?? '';

                return ListTile(
                  title: Text('$firstName $lastName', style: TextStyle(color: Colors.white),),
                  subtitle: Text(email, style: TextStyle(color: Colors.white.withOpacity(.7)),),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(imageURL),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}