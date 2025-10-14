import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/bloc/unread_messages_bloc.dart';
import '../../blocs/state/unread_messages_state.dart';

class UnreadMessagesBadge extends StatelessWidget {
  const UnreadMessagesBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnreadMessagesBloc, UnreadMessagesState>(
      builder: (context, state) {
        if (state is UnreadCountUpdated && state.count > 0) {
          final text = state.count > 99 ? '99+' : state.count.toString();
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
