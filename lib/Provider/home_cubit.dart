import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmfinfotech_machinetest/Models/userlist_model.dart';
import 'package:mmfinfotech_machinetest/Provider/home_state.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState()) {
     apiCall();
  }

  apiCall({page=1}) async {
    if(page ==1){emit(state.copyWith(loading: true));}
    SharedPreferences sh = await SharedPreferences.getInstance();
    String token = sh.getString("token")!;
    var res = await http.get(
      Uri.parse("https://mmfinfotech.co/machine_test/api/userList?page=$page"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    emit(state.copyWith(page: state.page+1));
    if(res.statusCode == 200){
      var data =await jsonDecode(res.body);
      List json =await jsonDecode(res.body)["userList"];
     List data2 = json.map((json) =>UserListModel.fromJson(json)).toList();
     emit(state.copyWith(lastpage: data["lastPage"]));
     emit(state.copyWith(data: data2));
     emit(state.copyWith(loading: false));
    }
  }

  onpullup() async{
    if(state.lastpage >= state.page) {
      emit(state.copyWith(page: state.page + 1));
      apiCall(page: state.page);
    }else{}
  }
  onRefresh(){
    emit(state.copyWith(page: 1));
    apiCall(page: state.page);
  }

}
