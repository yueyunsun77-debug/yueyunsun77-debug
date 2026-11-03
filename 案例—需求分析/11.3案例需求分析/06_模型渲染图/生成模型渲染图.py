"""从当前增量修订的模型生成PlantUML投影视图并在本地渲染；不是SysML v2编译器。"""
from pathlib import Path
import argparse,hashlib,json,re,subprocess,os,textwrap,xml.etree.ElementTree as ET
from PIL import Image

HERE=Path(__file__).resolve().parent
ROOT=HERE.parent if HERE.name=='06_模型渲染图' else Path('/workspace/yueyunsun77-debug/案例—需求分析/11.3案例需求分析')
MODEL=ROOT/'01_系统边界与逻辑化表达/修改后的SysML模型'
OUT=ROOT/'06_模型渲染图'
P=argparse.ArgumentParser();P.add_argument('--jar',type=Path,required=True);args=P.parse_args()
EXPECTED_JAR_SHA256='96ace11f947a04a4320a413a0a2c6bad8b87daaac1869fe51e82622d812fe13c'
assert hashlib.sha256(args.jar.read_bytes()).hexdigest()==EXPECTED_JAR_SHA256,'PlantUML版本或校验和不符，需使用文档固定版本1.2026.9'
BASE='''@startuml
skinparam defaultFontName Noto Sans CJK SC
skinparam defaultFontSize 14
skinparam dpi 140
skinparam shadowing false
skinparam backgroundColor white
skinparam ArrowColor #35566C
skinparam NoteBackgroundColor #FFF5D6
skinparam NoteBorderColor #C9AD66
skinparam roundcorner 10
skinparam packageStyle rectangle
skinparam classBackgroundColor #EAF3FB
skinparam classBorderColor #496C84
skinparam activityBackgroundColor #EAF3FB
skinparam activityBorderColor #496C84
skinparam usecaseBackgroundColor #EAF3FB
hide empty members
hide circle
'''
records=[]
def wrap(s,n=24):return '\\n'.join(textwrap.wrap(s,n,break_long_words=True,break_on_hyphens=False))
def make(group,name,title,body,source,meta):
 p=OUT/group/(name+'.puml');p.parent.mkdir(parents=True,exist_ok=True)
 p.write_text(BASE+'title '+title+'\n'+body+'\n@enduml\n',encoding='utf-8')
 records.append(dict(view_type=group,stem=str(p.relative_to(ROOT).with_suffix('')),model_file=str(source.relative_to(ROOT)),model_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),**meta))

# RD: 从当前SysML读取每个原子需求的短ID、标识和doc正文；不补造derive/satisfy关系。
data={r['req_id']:r for r in json.loads((ROOT/'03_结构化需求清单/结构化需求清单.json').read_text())}
for rid in ['3.3.1.2','3.3.1.6','3.3.1.9']:
 source=MODEL/(rid+'-需求图.sysml');s=source.read_text()
 leaves=re.findall(r"requirement <'([^']+)'> (\w+) \{\s*doc /\*(.*?)\*/\s*}",s,re.S)
 body='left to right direction\nskinparam nodesep 30\nskinparam ranksep 55\n'
 body+='class "'+data[rid]['name']+'" as MAIN <<requirement>> {\n Id = '+rid+'\n}\n'
 for i,(ident,alias,doc) in enumerate(leaves):
  # 整理文档空白，数值和比较关系保留。
  text=' '.join(doc.split())
  body+='class "'+ident+'\\n'+alias+'" as R'+str(i)+' <<requirement>> {\n Text = '+wrap(text,23)+'\n}\n'
  body+='MAIN *-- R'+str(i)+' : 包含\n'
 body+='legend bottom\n原RD嵌套包含关系；保留原编号。\nXXX/TBD和标定说明保留；图中未新增deriveReqt或satisfy。\nendlegend\n'
 make('01_需求图',rid+'-需求图',rid+' '+data[rid]['name']+' — 需求图',body,source,dict(requirement_ids=[rid]+[x[0] for x in leaves],relation_semantics='原SysML需求嵌套包含'))

# ACT: 读取原有阶段名称；在相应阶段内展开其doc已明示条件/模式差异。
for rid in ['3.3.1.2','3.3.1.6','3.3.1.9']:
 source=MODEL/(rid+'-需求活动图.sysml');s=source.read_text()
 actions=re.findall(r"\baction '([^']+)'",s)[1:]
 phase=lambda i:':'+wrap(actions[i],26)+';\n'
 part=lambda i:'partition "'+wrap(actions[i],28)+'" {\n'
 body='start\n'
 if rid=='3.3.1.2':
  body+=phase(0)+phase(1)
  body+=part(2)+'''if (全部使能条件满足？) then (是)
:允许电加热输出;
else (否)
:禁止/保持关闭电加热输出;
endif
}
note right
空气输送已开启；目标温度 > 室内温度；
高压可用；整车无故障；SOC > 10%。
end note
'''
  body+=part(3)+'''if (已触发且尚未解除过温保护？) then (是)
if (温度 <= 恢复XXX℃？) then (是)
:重新允许加热\n（仍须满足全部使能条件）;
else (否)
:保持保护禁止状态;
endif
else (否)
if (电加热温度 >= 上限XXX℃？) then (是)
:停止电加热输出；进入保护状态;
else (否)
:按当前许可控制加热;
endif
endif
}
note right
温度上限/恢复阈值待标定；
电加热温度按50 ms检测（SL29 4.6.3.5）。
持续监测，不表示只检测一次。
end note
'''+phase(4)
 elif rid=='3.3.1.6':
  body+=''.join(phase(i) for i in range(4))
  body+=part(4)+'''switch (AUTO内的用户操作)
case (温度 / 循环)
:保持AUTO；更新对应设置;
case (风量 / 吹风模式)
:退出AUTO；其余指定项仍自动;
case (前除霜)
:进入前除霜状态;
case (AC)
:关闭制冷请求；转速请求=0;
:AUTO反馈Close；\n风量、温度、模式、循环仍自动;
case (AUTO再次操作)
:原文invalid；具体交互待确认;
endswitch
}
'''+phase(5)
  body+='note right\n目标温度<16℃为LO，>30℃为HI；\n每次调节0.5℃，不补造默认温度。\nend note\n'
 else:
  body+=phase(0)+phase(1)
  body+='if (有依据的前除霜/前除雾请求？) then (是)\n'+phase(2)
  body+='note right\n对应风口、最大风量、外循环；\n外循环90%待定；温度保持。\nend note\n'
  body+=phase(3)
  body+='note right\n环境温度决定AC请求；除湿转速最低1000 r/min待标定。\nSL29优先级/低SOC许可按其适用条件，XX阈值未定；\n不把场景二35℃移作仲裁门限。\nend note\n'
  body+=phase(4)+phase(5)
  body+='else (后风窗等缺少依据)\n:停留在待确认处理；\n不套用前风窗控制配置;\nendif\n'
 body+='stop\nlegend bottom\n保留原阶段顺序；阶段内部按当前SysML动作doc展开。\n这是一次评估/处理片段，终点不表示全系统持续调节或监测停止。\n未规定的控制算法、周期和标定值不补造。\nendlegend\n'
 make('02_需求活动图',rid+'-需求活动图',rid+' '+data[rid]['name']+' — 需求活动图',body,source,dict(phase_names=actions,projection='原阶段主链＋动作doc明示规则展开；不是原平台执行仿真'))

# UC: 原3用例、两类参与者和objective require映射保持不变。
source=next(MODEL.glob('*需求用例图.sysml'));s=source.read_text()
ucs=re.findall(r"use case def '([^']+)'",s)
actors=re.findall(r"actor \w+ : '([^']+)'",s);actors=list(dict.fromkeys(actors))
subject=re.search(r"subject \w+ : '([^']+)'",s)[1]
body='left to right direction\n'
for i,actor in enumerate(actors):body+='actor "'+actor+'" as A'+str(i)+'\n'
body+='rectangle "'+subject+'" {\n'
for i,uc in enumerate(ucs):body+='usecase "'+uc+'" as UC'+str(i)+'\n'
body+='}\n'
for i,_ in enumerate(ucs):
 for j,_ in enumerate(actors):body+='A'+str(j)+' -- UC'+str(i)+'\n'
 rid=['3.3.1.2','3.3.1.6','3.3.1.9'][i]
 body+='note right of UC'+str(i)+'\n对应需求 '+rid+'\nobjective require req'+rid.replace('.','')[1:]+'\nend note\n'
body+='legend bottom\n保留原参与者、3个用例及需求追溯；未新增include/extend。\n风窗用例中，后风窗控制细节仍待补充依据。\nendlegend\n'
# req3312等原标识直接从模型取出，避免字符串推算错误。
reqaliases=re.findall(r'\brequire (\w+);',s)
for i,alias in enumerate(reqaliases):
 wrong='req'+['3.3.1.2','3.3.1.6','3.3.1.9'][i].replace('.','')[1:]
 body=body.replace('objective require '+wrong+'\n','objective require '+alias+'\n')
make('03_需求用例图','综合-需求用例图','热管理三条需求 — 综合用例图',body,source,dict(use_cases=ucs,actors=actors,require_aliases=reqaliases))

# BDD: 从实际SysML解析原7个角色的端口及8条interface connect，不发明端口。
source=next(MODEL.glob('*BDD图.sysml'));s=source.read_text()
partdefs={name:ports for name,ports in re.findall(r"part def '([^']+)' \{(.*?)\n    }",s,re.S)}
parts=re.findall(r"\bpart (\w+) : '([^']+)';",s)
parts=[(alias,name) for alias,name in parts if name!='热管理控制外部环境']
connections=re.findall(r'\binterface (\w+) : (\w+)\s+connect ([\w.]+) to ([\w.]+);',s)
ports={}
for name,chunk in re.findall(r'port def (\w+) \{(.*?)\n    }',s,re.S):
 ports[name]=re.findall(r'out attribute (\w+) : (\w+);',chunk)
body='left to right direction\nskinparam nodesep 70\nskinparam ranksep 90\n'
for alias,name in parts:
 body+='class "'+name+'" as '+alias+(' <<system>>' if alias=='SYS' else ' <<external role>>')+' {\n'
 for port,typ in re.findall(r'port (\w+) : (~?\w+);',partdefs[name]):body+=' '+port+' : '+typ+'\n'
 body+='}\n'
for alias,typ,start,end in connections:
 a,ap=start.split('.');b,bp=end.split('.')
 body+=a+' --> '+b+' : '+alias+'\\n'+typ+'\\n'+ap+' → '+bp+'\n'
body+='legend bottom left\n端口特征（均保留原接口语义）\n'
for name,fields in ports.items():
 body+=''+name+':\n'+'\n'.join(', '.join(k+':'+t for k,t in fields[i:i+2]) for i in range(0,len(fields),2))+'\n'
body+='----\n~表示原模型共轭端口；箭头表示原interface connect的信息流向。\n物理部署/供货归属不由本黑盒图裁定；不展开CAN内部转发。\nendlegend\n'
make('04_需求外部环境BDD图','综合-需求外部环境BDD图','热管理逻辑控制服务 — 外部环境 BDD',body,source,dict(parts=parts,connections=[dict(name=a,interface_type=t,source=x,target=y) for a,t,x,y in connections],port_type_features=ports))

env={**os.environ,'PLANTUML_LIMIT_SIZE':'16384','XDG_CACHE_HOME':'/workspace/.cache'}
files=[str(ROOT/(r['stem']+'.puml')) for r in records]
for fmt in ['png','svg']:
 subprocess.run(['java','-Djava.awt.headless=true','-jar',str(args.jar),'-charset','UTF-8','-failfast2','-t'+fmt,*files],check=True,env=env)
for r in records:
 r['artifacts']={}
 for ext in ['puml','png','svg']:
  p=ROOT/(r['stem']+'.'+ext);assert p.is_file() and p.stat().st_size>0
  r['artifacts'][ext]=dict(file=str(p.relative_to(ROOT)),bytes=p.stat().st_size,sha256=hashlib.sha256(p.read_bytes()).hexdigest())
  if ext=='svg':
   tree=ET.parse(p)
   text=''.join(tree.getroot().itertext())
   assert 'Syntax Error' not in text and 'Error line' not in text
  if ext=='png':
   with Image.open(p) as im:r['png_dimensions']=list(im.size);im.verify()
manifest=dict(tool='PlantUML 1.2026.9',jar_sha256=hashlib.sha256(args.jar.read_bytes()).hexdigest(),source_type='当前SysML文本投影，ACT含doc规则可视化展开；不代表SysML编译通过',views=records)
(OUT/'渲染与模型对应清单.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
print('Rendered',len(records),'views,',len(records)*3,'artifacts')
for r in records:print(r['stem'],r['png_dimensions'])
