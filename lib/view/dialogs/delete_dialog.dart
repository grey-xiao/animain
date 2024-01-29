import 'package:animain/bloc/anime_bloc.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/util/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({
    super.key,
    this.anime,
    required this.single,
    required this.animeBloc,
    required this.onSubmit,
  });
  final AnimeBloc animeBloc;
  final Anime? anime;
  final bool single;
  final ValueChanged<bool> onSubmit;

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnimeBloc, AnimeState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(deleteMsgString),
          showCloseIcon: true,
        ));
      },
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              )),
          GestureDetector(
              onTap: () async {
                widget.single
                    ? widget.animeBloc.add(DeleteAnime(anime: widget.anime!))
                    : widget.animeBloc.add(const DeleteAll());
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                "DELETE",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              )),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20.0,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.only(
          top: 10.0,
        ),
        title: Center(
          child: Text(
            widget.single
                ? "Delete ${widget.anime!.title}?"
                : "Delete all records?",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
