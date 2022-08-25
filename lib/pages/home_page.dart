import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math show Random;
const name = ['Foo',"Baz","Bar","Asliddin"];

extension RandomElement<T> on Iterable<T>{
  T getRandomElement() => elementAt(
    math.Random().nextInt(length)
  );
}

 class NamesCubit extends Cubit<String?> {
   NamesCubit() : super(null);

   void pickRandomName(){
     emit(name.getRandomElement());
   }


}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context,snapshot){
          final button = TextButton(onPressed: (){
           return cubit.pickRandomName();
          },
              child: Text("Pick a random name"));
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? ''),
                  button
                ],
              );
            case ConnectionState.done:
              return const SizedBox();

          }
        },

      ),
    );
  }
}
