import 'package:flutter/material.dart';
import 'chat_gpt_helper.dart';

class DebugPanel extends StatefulWidget {
  final String apiKey;
  const DebugPanel({super.key, required this.apiKey});

  @override
  DebugPanelState createState() => DebugPanelState();
}

class DebugPanelState extends State<DebugPanel> {
  final List<String> logs = [];
  final TextEditingController inputCtrl = TextEditingController();
  late final ChatGPTHelper gpt;

  @override
  void initState() {
    super.initState();
    gpt = ChatGPTHelper(apiKey: widget.apiKey);
  }

  void addLog(String msg) {
    setState(() {
      logs.add("[${DateTime.now().toIso8601String()}] $msg");
      if (logs.length > 200) logs.removeAt(0);
    });
  }

  Future<void> askGPT(String prompt) async {
    addLog("You: $prompt");
    final res = await gpt.ask(prompt);
    addLog("GPT: $res");
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text("Debug & ChatGPT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: logs.map((l) => Text(l, style: const TextStyle(color: Colors.greenAccent, fontSize: 12))).toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(hintText: "Ask GPT or type log...", hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                    onSubmitted: (v) {
                      if (v.trim().isEmpty) return;
                      askGPT(v.trim());
                      inputCtrl.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    final v = inputCtrl.text.trim();
                    if (v.isEmpty) return;
                    askGPT(v);
                    inputCtrl.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
