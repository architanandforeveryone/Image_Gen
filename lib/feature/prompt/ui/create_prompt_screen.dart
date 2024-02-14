import 'package:ai_imagegenerator/feature/prompt/bloc/prompt_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  TextEditingController controller = TextEditingController();


  final PromptBloc promptBloc=PromptBloc();

  @override
  void initState() {
    promptBloc.add(PromptInitialEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Generate Images"),
      ),
      body: BlocConsumer<PromptBloc, PromptState>(
        bloc: promptBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch(state.runtimeType)
          {
            case PromptGeneratingImageLoadState:
            return Center(child: CircularProgressIndicator());

            case PromptGeneratingImageErrorState:
            return Center(child: Text("Something Went Wrong"));

            case PromptGeneratingImageSuccessState:
            final sucessState= state as PromptGeneratingImageSuccessState;
            return  Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  
                  child: Container(
                    width: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(sucessState.uint8list) )
                ),
              )),
              Container(
                height: 240,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter Your Prompt",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: controller,
                      cursorColor: Colors.deepPurple,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 40,
                      width: double.maxFinite,
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.deepPurple)),
                          onPressed: () {
                            if(controller.text.isNotEmpty)
                            {
                              promptBloc.add(PromptEnteredEvent(
                                prompt: controller.text));
                            }
                          },
                          icon: Icon(Icons.generating_tokens),
                          label: Text("Generate")),
                    )
                  ],
                ),
              )
            ]),
          );


            default: return SizedBox() ;
          }
        },
      ),
    );
  }
}
