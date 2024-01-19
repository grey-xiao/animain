import 'package:animain/bloc/anime_bloc.dart';
import 'package:animain/controller/anime_controller.dart';
import 'package:animain/model/anime_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class DeleteDialog extends StatefulWidget{
  const DeleteDialog({super.key, required this.anime, required this.animeDB, required this.callback, required this.mode, required this.onSubmit});
  
  final Anime? anime;
  final AnimeController animeDB;
  final VoidCallback callback;
  final String mode;
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
    return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            
            )
          ),
          GestureDetector(
            onTap: () async {
              context.read<AnimeBloc>().add(DeleteAnime(anime: widget.anime!));

              widget.mode == 'single' ? 
              await widget.animeDB.delete(widget.anime!.id!)
              : await widget.animeDB.deleteAll();

              widget.callback();
              Navigator.of(context).popUntil((route) => route.isFirst);
            } ,
            child: const Text("DELETE",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ),
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
                widget.mode == 'single' ?
                "Delete ${widget.anime!.title}?"
                : "Delete all records?",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
          );
  }
}