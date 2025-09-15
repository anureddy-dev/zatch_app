import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  final String title;

  const PolicyScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Lorimipsum Lori",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                  "Quisque dictum augue arcu, hendrerit lobortis neque malesuada sit amet. "
                  "Quisque scelerisque est massa in convallis. Vivamus ut gravida elit. "
                  "In pulvinar, mauris non commodo ultricies, est orci gravida leo, "
                  "id mattis eros odio at ante. Nunc varius cursus mauris congue sagittis. "
                  "Donec lacinia, sem blandit eleifend condimentum, justo velit fermentum "
                  "sem, sed ullamcorper arcu purus vel enim. Maecenas at orci vitae ante "
                  "rutrum dictum in quis est. Donec hendrerit, dui at ultrices volutpat, "
                  "risus dui iaculis magna, eu rutrum ligula mi nec lacus. "
                  "Sed sagittis enim a sagittis rhoncus. Vestibulum sollicitudin ante non "
                  "ipsum aliquet sollicitudin.",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              "Lorimipsum Lori",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                  "Quisque dictum augue arcu, hendrerit lobortis neque malesuada sit amet. "
                  "Quisque scelerisque est massa in convallis. Vivamus ut gravida elit. "
                  "In pulvinar, mauris non commodo ultricies, est orci gravida leo, "
                  "id mattis eros odio at ante. Nunc varius cursus mauris congue sagittis. "
                  "Donec lacinia, sem blandit eleifend condimentum, justo velit fermentum "
                  "sem, sed ullamcorper arcu purus vel enim.",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
