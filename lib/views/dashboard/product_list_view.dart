import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_printer/controllers/product_list_controller.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  ProductListController get controller => Get.find<ProductListController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductListController>(
      init: controller,
      builder: (_) {
        final products = controller.products;
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: products.isEmpty
              ? const Center(child: Text('No Products Found'))
              : GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Number of columns
                    crossAxisSpacing: 8.0, // Horizontal spacing
                    mainAxisSpacing: 8.0, // Vertical spacing
                    childAspectRatio: 3 / 2, // Aspect ratio of each grid item
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        // Toggle the product status
                        final newStatus = product.status == 'publish' ? 'draft' : 'publish';
                        controller.products.where((p) => p.id == product.id).first.status = newStatus;
                        controller.toggleProductStatus(
                          isActive: newStatus == 'publish',
                          productId: product.id ?? 0,
                        );
                        controller.update();
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '#${product.id ?? ''}',
                                style: const TextStyle(fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                product.name ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Status',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  Switch(
                                    value: product.status == 'publish',
                                    onChanged: (value) {
                                      controller.products.where((p) => p.id == product.id).first.status = value ? 'publish' : 'draft';
                                      controller.toggleProductStatus(
                                        isActive: value,
                                        productId: product.id ?? 0,
                                      );
                                      controller.update();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
