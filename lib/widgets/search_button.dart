import 'package:flutter/material.dart';

class SearchButton extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const SearchButton({
    super.key,
    required this.onSearch,
  });

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_isSearching) {
      return Row(
        children: [
          SizedBox(
            width: 180, // batas lebar agar tidak melewati AppBar
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: widget.onSearch,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _controller.clear();
                widget.onSearch(""); // reset hasil pencarian bila perlu
              });
            },
          ),
        ],
      );
    } 
    
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        setState(() => _isSearching = true);
      },
    );
  }
}
