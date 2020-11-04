class GlobalState{
  final Map<dynamic , dynamic> _data = <dynamic , dynamic>{};
  static GlobalState ins = new GlobalState();
  set(dynamic k , dynamic v ) => _data[k] = v;
  get(dynamic k) => _data[k];
}