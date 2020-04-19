import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ArCoreController arCoreController;
  var objName = 0;
  final textController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suvojitar"),
      ),
      body: ArCoreView(onArCoreViewCreated: _onArCoreViewCreated, enableTapRecognizer: true),
    );
  }


  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    controller.onPlaneTap = _onPlaneTap;
  }

  void onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('This is $name')),
    );
  }

  _onPlaneTap(List<ArCoreHitTestResult> hits) => _onHitDetected(hits.first);


  _onHitDetected(ArCoreHitTestResult plane) {
    
    final material = ArCoreMaterial(
        color: Colors.purple);
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.2,
    );

    this.objName = this.objName + 1;
    arCoreController.addArCoreNodeWithAnchor(
      ArCoreNode(
        name: this.objName.toString(),
        shape: sphere,
        position: plane.pose.translation,
        rotation: plane.pose.rotation,
      ),
    );
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

}
