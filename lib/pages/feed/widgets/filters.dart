
  // Container _filters() {
  //   return Container(
  //     margin: EdgeInsets.only(right: 5),
  //     child: IconButton(
  //       icon: filter
  //           ? Icon(
  //               Icons.filter_alt,
  //               color: Theme.of(context).primaryColor,
  //             )
  //           : Icon(
  //               Icons.filter_alt_outlined,
  //               color: Theme.of(context).primaryColor,
  //             ),
  //       onPressed: _displayFilters,
  //     ),
  //   );
  // }

  //   void _displayFilters() {
  //   if (!filter) {
  //     showModalBottomSheet(
  //         context: context,
  //         isScrollControlled: true,
  //         builder: (context) {
  //           return Padding(
  //             padding: const EdgeInsets.only(bottom: 48.0, top: 20),
  //             child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: currentUser.groups
  //                     .map((group) => tileGroup(group))
  //                     .toList()),
  //           );
  //         });
  //   } else {
  //     setState(() {
  //       filter = false;
  //       postsDisplayed = posts;
  //     });
  //   }
  // }

  //   void _filterGroups(Group group) {
  //   setState(() {
  //     filter = true;
  //     postsDisplayed = posts
  //         .where((p) => p.group.where((g) => g.id == group.id).isNotEmpty)
  //         .toList();
  //     print(postsDisplayed);
  //   });
  //   Navigator.pop(context);
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(
  //         "Vous venez de filtrer les posts par ${group.name} ! Pour désactiver le filtre, appuyez à nouveau sur l'entonnoir"),
  //     backgroundColor: Colors.blue[300],
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10))),
  //     behavior: SnackBarBehavior.floating,
  //   ));
  // }

  //   GestureDetector tileGroup(Group group) {
  //   return GestureDetector(
  //       onTap: () {
  //         _filterGroups(group);
  //       },
  //       child: _cardGroup(group));
  // }
