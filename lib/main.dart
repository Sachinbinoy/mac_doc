import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return Container(
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.primaries[e.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(e, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  final List<T> items;
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T> extends State<Dock<T>> {
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _items.length; i++) _buildDraggableItem(i),
        ],
      ),
    );
  }

  Widget _buildDraggableItem(int index) {
    return Draggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: widget.builder(_items[index]),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: widget.builder(_items[index]),
      ),
      child: DragTarget<int>(
        onWillAcceptWithDetails: (_) => true,
        onAcceptWithDetails: (details) {
          setState(() {
            final item = _items[details.data];
            _items.removeAt(details.data);
            _items.insert(index, item);
          });
        },
        builder: (context, candidateData, rejectedData) {
          return AnimatedScale(
            scale: candidateData.isNotEmpty ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedSlide(
              offset: Offset.zero,
              duration: const Duration(milliseconds: 200),
              child: widget.builder(_items[index]),
            ),
          );
        },
      ),
    );
  }
}
