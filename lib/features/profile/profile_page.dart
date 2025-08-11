import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/profile_model.dart';
import 'data/profile_repository.dart';

final repoProvider = Provider<ProfileRepository>((_) => InMemoryProfileRepository());

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override ConsumerState<ProfilePage> createState()=>_ProfilePageState();
}
class _ProfilePageState extends ConsumerState<ProfilePage>{
  final _form=GlobalKey<FormState>();
  String nickname='', gender=''; DateTime? birthDate; bool unknownTime=false;
  String? birthTime; String birthPlace=''; String intro=''; List<String> interests=[];

  bool _isAdult(DateTime d){
    final now=DateTime.now();
    final age=now.year-d.year - ((now.month<d.month || (now.month==d.month && now.day<d.day))?1:0);
    return age>=19;
  }

  @override Widget build(BuildContext c){
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Form(key:_form, child: ListView(padding: const EdgeInsets.all(16), children:[
        TextFormField(decoration: const InputDecoration(labelText:'닉네임'),
          onSaved:(v)=>nickname=v!.trim(),
          validator:(v){ if(v==null||v.trim().length<2||v.trim().length>20) return '닉네임 2~20자'; return null; }),
        DropdownButtonFormField(items: const [
          DropdownMenuItem(value:'M',child:Text('남')),
          DropdownMenuItem(value:'F',child:Text('여'))
        ], onChanged:(v){gender=v??'';}, decoration: const InputDecoration(labelText:'성별')),
        InputDatePickerFormField(firstDate: DateTime(1900), lastDate: DateTime.now(),
          onDateSubmitted:(d)=>birthDate=d, onDateSaved:(d)=>birthDate=d),
        SwitchListTile(title: const Text('출생시각 모름'), value: unknownTime,
          onChanged:(v)=>setState(()=>unknownTime=v)),
        if(!unknownTime) TextFormField(decoration: const InputDecoration(labelText:'출생시각(HH:mm)'),
          onSaved:(v)=>birthTime=v),
        TextFormField(decoration: const InputDecoration(labelText:'출생지'), onSaved:(v)=>birthPlace=v??''),
        TextFormField(decoration: const InputDecoration(labelText:'한줄소개'), onSaved:(v)=>intro=v??''),
        const SizedBox(height:12),
        ElevatedButton(onPressed: () async {
          _form.currentState!.save();
          if(birthDate==null){ ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('생년월일 필수'))); return; }
          if(!_isAdult(birthDate!)){ ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('만 19세 이상만 가입 가능'))); return; }
          final p=Profile(nickname:nickname, gender:gender, birthDate:birthDate!,
            birthTimeUnknown:unknownTime, birthTime:birthTime, birthPlace:birthPlace, intro:intro, interests:interests);
          await ref.read(repoProvider).save(p);
          if(mounted) GoRouter.of(c).go('/feed');
        }, child: const Text('저장 후 계속')),
      ])),
    );
  }
}
