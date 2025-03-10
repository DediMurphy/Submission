import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/data/model/restaurant_detail_response.dart';

import '../../provider/detail/review_detail_provider.dart';

class BodyOfDetailScreenWidget extends StatefulWidget {
  const BodyOfDetailScreenWidget({
    super.key,
    required this.restaurant,
  });

  final RestaurantDetail restaurant;

  @override
  State<BodyOfDetailScreenWidget> createState() =>
      _BodyOfDetailScreenWidgetState();
}

class _BodyOfDetailScreenWidgetState extends State<BodyOfDetailScreenWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReviewProvider>(context, listen: false)
          .fetchReviews(widget.restaurant.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "restaurant_${widget.restaurant.id}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: widget.restaurant.imageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/placeholder.png'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurant.name,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        "${widget.restaurant.city}, ${widget.restaurant.address}",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.pink),
                    const SizedBox(width: 4),
                    Text(
                      widget.restaurant.rating.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.restaurant.description ?? "",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle(context, "Kategori:"),
            Wrap(
              spacing: 8,
              children: widget.restaurant.categories
                  .map((category) => Chip(label: Text(category.name)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle(context, "Menu Makanan:"),
            _buildMenuList<Food>(widget.restaurant.menus.foods, Icons.fastfood),
            _buildSectionTitle(context, "Menu Minuman:"),
            _buildMenuList<Drink>(
                widget.restaurant.menus.drinks, Icons.local_drink),
            Consumer<ReviewProvider>(
              builder: (context, provider, _) {
                return _buildReviewSection(context, provider.reviews);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildMenuList<T>(List<T> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => ListTile(
                leading: Icon(icon),
                title: Text((item as dynamic).name),
              ))
          .toList(),
    );
  }

  Widget _buildReviewSection(
      BuildContext context, List<Map<String, String>> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, "Ulasan Pelanggan:"),
        _buildReviewList(reviews),
        _buildReviewForm(context),
      ],
    );
  }

  Widget _buildReviewList(List<Map<String, String>> reviews) {
    if (reviews.isEmpty) {
      return const Text("Belum ada ulasan.");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: reviews
          .map((review) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(review["name"]!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review["review"]!),
                        Text(
                          review["date"]!,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildReviewForm(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tambahkan Ulasan:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reviewController,
              decoration: const InputDecoration(
                labelText: "Ulasan",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      reviewController.text.isNotEmpty) {
                    Provider.of<ReviewProvider>(context, listen: false)
                        .submitReview(
                      widget.restaurant.id,
                      nameController.text,
                      reviewController.text,
                    );

                    nameController.clear();
                    reviewController.clear();
                  }
                },
                child: const Text("Kirim Ulasan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
