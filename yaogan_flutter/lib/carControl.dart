class carControl {
  final int o;//保留位，大于1表示激活，车运行时必须为0
  final int v;//速度，电机运行的相对速度
  final int c;//平移角度
  final int d;//自转方向大于0 顺时针，等于0逆时针
  final int r;//自传速率（毫秒每转）最低为1200
  final int a;//计划旋转角度

  carControl(this.o, this.v,this.c,this.d,this.r,this.a);

  carControl.fromJson(Map<String, int> json)
      : o = json['o'],
        v = json['v'],
        c = json['c'],
        d = json['d'],
        r = json['r'],
        a = json['a'];

  Map<String, int> toJson() =>
      {
        'o': o,
        'v': v,
        'c': c,
        'd': d,
        'r': r,
        'a': a,
      };
  String JsontoString()
      {
        String str = "{";
        str = str+"'o':"+o.toString()+",'v':"+v.toString()+",'c':"+c.toString()+",'d':"+d.toString()+",'r':"+r.toString()+",'a':"+a.toString()+"}";
//        print(str);
    return str;
      }
}