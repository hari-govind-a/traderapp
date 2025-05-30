
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traderapp/components/dropdownmenu.dart';
import 'package:traderapp/models/product.dart';
import 'package:traderapp/components/button.dart';
import 'package:traderapp/components/mytextfeild.dart';
import 'package:traderapp/services/firestoreproductoptions.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  XFile? image;
  Uint8List? file;
  String? url;
  bool flag = false;
  final List<String> options = ['Available', 'Not Available', 'Available Soon'];

  String selectedOption = 'Available';

  final TextEditingController nameTextController = TextEditingController();

  final TextEditingController priceTextController = TextEditingController();
  final TextEditingController descriptionTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final def = image != null
        ? Image.memory(file!)
        : Image.asset(
            'lib/assets/defprod.png',
          );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: const Text('ADD PRODUCTS'),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: def.image,
              ),
              IconButton(
                onPressed: uploadimage,
                icon: const Icon(Icons.camera),
              ),
              MyTextFeild(
                  hinttext: 'product name', textController: nameTextController),
              const SizedBox(
                height: 20,
              ),
              MyTextFeild(
                  hinttext: 'price', textController: priceTextController),
              const SizedBox(
                height: 20,
              ),
              DropDownWidget(
                options: options,
                selectedOption: selectedOption,
                onChanged: (p0) {
                  setState(() {
                    selectedOption = p0 ?? 'Not Available';
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextFeild(
                hinttext: 'product description',
                textController: descriptionTextController,
                maxLines: 4,
              ),
              const SizedBox(
                height: 20,
              ),
              (flag == false
                  ? MyButton(onPressed: () => onPressed(context), msg: 'save')
                  : showindicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget showindicator() {
    if (flag) {
      return const CircularProgressIndicator();
    } else {
      return const SizedBox.shrink();
    }
  }

  onPressed(BuildContext context) async {
    setState(() {
      flag = true;
    });
    if (image != null) {
      url = await FireStorage().uploadimage(image!);
    }
    final Product product = Product(
        productName: nameTextController.text,
        productPrice: double.parse(
          priceTextController.text,
        ),
        url: url,
        availability: selectedOption,
        description: descriptionTextController.text);

    FirestoreProduct().addProductInfo(product);
    navigate();
  }

  navigate() {
    Navigator.pop(context);

    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text('Product Added!'),
              backgroundColor: Colors.white,
            ));
  }

  uploadimage() async {
    XFile? img = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (img != null) {
      Uint8List filex = await img.readAsBytes();
      setState(() {
        file = filex;
        image = img;
      });
    }
  }
}
