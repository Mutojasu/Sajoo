import 'package:flutter/material.dart';
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});
  @override Widget build(BuildContext c){
    final items = List.generate(10,(i)=>'사용자 #$i');
    return Scaffold(appBar: AppBar(title: const Text('Feed')),
      body: ListView.builder(itemCount: items.length,itemBuilder: (_,i){
        return Card(margin: const EdgeInsets.all(12), child: ListTile(
          title: Text(items[i]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children:[
            IconButton(icon: const Icon(Icons.favorite_border),
              onPressed: ()=>ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('좋아요 보냄')))),
            IconButton(icon: const Icon(Icons.info_outline),onPressed: (){
              showModalBottomSheet(context: c, builder: (_)=>const Padding(
                padding: EdgeInsets.all(16), child: Text('궁합 점수: -- (준비중)'),
              ));
            }),
          ]),
        ));
      }));
  }
}
