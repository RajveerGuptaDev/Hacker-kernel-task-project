import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductPage.dart';
import 'ProductProvider.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: productProvider.searchProducts,
              decoration: const InputDecoration(
                fillColor: Colors.blue,
                labelText: "Search Products",
                icon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: productProvider.filteredProducts.isEmpty
                ? Center(

                child: Text("No Products Found",
            style: TextStyle(
              fontSize: 20,
              color: Colors.brown,
            ),
            )
            )
                : ListView.builder(
              itemCount: productProvider.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = productProvider.filteredProducts[index];
                return ListTile(
                  leading: product['image'] != null
                      ? Image.file(File(product['image']!))
                      : Icon(Icons.image),
                  title: Text(product['name']!),
                  subtitle: Text("Price: \$${product['price']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => productProvider.deleteProduct(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(),
          ),
        ),
        child: Icon(Icons.add, size: 50,),
      ),
    );
  }
}
