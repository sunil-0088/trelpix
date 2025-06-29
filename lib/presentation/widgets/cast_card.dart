import 'package:flutter/material.dart';
import 'package:trelpix/domain/entities/cast.dart';
import 'package:trelpix/presentation/widgets/cached_image_widget.dart';

class CastCard extends StatelessWidget {
  const CastCard({super.key, required this.cast});
  final Cast cast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child:
                cast.fullProfileUrl == null || cast.fullProfileUrl!.isEmpty
                    ? const Center(
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    )
                    : ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: CachedImageView(imageUrl: cast.fullProfileUrl!),
                    ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              cast.name,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              cast.character ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
