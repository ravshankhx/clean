import 'package:clean/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: buildBody(context),
    );
  }
}

BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<NumberTriviaBloc>(),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return const MessageDisplay(message: "Start Searching");
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  print(state.trivia.number);
                  print(state.trivia.number);
                  return TriviaDisplay(
                    numberTrivia: state.trivia,
                  );
                } else if (state is Error) {
                  return MessageDisplay(message: state.message);
                }
                return Container();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TriviaControlsState()
          ],
        ),
      ),
    ),
  );
}

class TriviaControlsState extends StatefulWidget {
  const TriviaControlsState({
    super.key,
  });

  @override
  State<TriviaControlsState> createState() => _TriviaControlsStateState();
}

class _TriviaControlsStateState extends State<TriviaControlsState> {
  String? inputStr = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: "Input a number"),
          onChanged: (value) {
            inputStr = value;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).accentColor,
                ),
                onPressed: dispatchConcrete,
                child: Text("Search"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: Theme.of(context).accentColor,
                // ),
                onPressed: dispatchRandom,
                child: Text("Get Random Trivia"),
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForConcreteNumber(inputStr!),
    );
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForRandomNumber(),
    );
  }
}
