import 'package:flutter/material.dart';
import 'package:trelpix/domain/entities/review.dart';
import 'package:trelpix/presentation/widgets/cached_image_widget.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    final authorImage = review.authorDetails?.fullAvatarUrl;
    final imageUrl =
        (authorImage != null && authorImage.isNotEmpty)
            ? authorImage
            : "https://avatar.iran.liara.run/public";

    return Card(
      margin: const EdgeInsets.only(right: 15, bottom: 10),
      elevation: 2,
      child: Container(
        width: MediaQuery.of(context).size.width - 57,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade800,
                        child: ClipOval(
                          child: CachedImageView(
                            imageUrl: imageUrl,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            placeholder: Image.asset('assets/person.png'),
                            errorWidget: Image.asset('assets/person.png'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.author.isNotEmpty
                                  ? review.author
                                  : "Anonymous",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
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
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      review.authorDetails?.rating?.toStringAsFixed(1) ?? '0.0',
                      style: const TextStyle(
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

            const SizedBox(height: 12),

            Text(
              review.content.isNotEmpty
                  ? review.content
                  : 'No review content available.',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
