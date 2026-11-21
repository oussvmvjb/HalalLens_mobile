import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/application/auth_controller.dart';
import '../../../shared/widgets/placeholder_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider);
    final user = session.valueOrNull;
    return PlaceholderPage(
      title: 'HalalLens',
      description:
          session.hasError
              ? 'Could not check your account session. ${session.error}'
              : user == null
              ? 'Scan a product or log in to your account.'
              : 'Signed in as ${user.fullName}.',
      links: {
        if (user == null) 'Log in or sign up': '/authentication',
        'Scan a barcode': '/scanner',
        'Product': '/product',
        'Analysis': '/analysis',
        'Scan history': '/history',
        if (user != null) 'Profile': '/profile',
      },
    );
  }
}
