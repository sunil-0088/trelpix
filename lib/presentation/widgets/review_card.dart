import 'package:flutter/material.dart';
import 'package:trelpix/domain/entities/review.dart';
import 'package:trelpix/presentation/widgets/cached_image_widget.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width - 57,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: ClipOval(
                        child: CachedImageView(
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          placeholder: Image.asset('assets/person.png'),
                          imageUrl:
                              review.authorDetails?.fullAvatarUrl ??
                              "https://avatar.iran.liara.run/public",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.author,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          review.updatedAt != null
                              ? "${review.updatedAt!.year}-${review.updatedAt!.month.toString().padLeft(2, '0')}-${review.updatedAt!.day.toString().padLeft(2, '0')}"
                              : "No date",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      review.authorDetails?.rating?.toStringAsFixed(1) ?? '0.0',
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.star, size: 15, color: Colors.yellow),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                review.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
