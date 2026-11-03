"""按用户参考图调整可视化；使用PlantUML支持的@startdot布局，保持用例图原字节。"""
from pathlib import Path
import argparse,hashlib,json,re,subprocess,os,textwrap,html,math
import xml.etree.ElementTree as ET
from PIL import Image

HERE=Path(__file__).resolve().parent
ROOT=HERE.parent if HERE.name=='06_模型渲染图' else Path('/workspace/yueyunsun77-debug/案例—需求分析/11.3案例需求分析')
OUT=ROOT/'06_模型渲染图';MODEL=ROOT/'01_系统边界与逻辑化表达/修改后的SysML模型'
parser=argparse.ArgumentParser();parser.add_argument('--jar',type=Path,required=True);args=parser.parse_args()
assert hashlib.sha256(args.jar.read_bytes()).hexdigest()=='96ace11f947a04a4320a413a0a2c6bad8b87daaac1869fe51e82622d812fe13c'
manifest=json.loads((OUT/'渲染与模型对应清单.json').read_text())
original_uc=next(v for v in manifest['views'] if v['view_type']=='03_需求用例图')
uc_before={ext:hashlib.sha256((ROOT/a['file']).read_bytes()).hexdigest() for ext,a in original_uc['artifacts'].items()}
records=[];details=[]
q=lambda s:json.dumps(s,ensure_ascii=False)
def esc(s):return html.escape(s,quote=True)
def lines(s,n=17):return '<BR/>'.join(esc(x) for x in textwrap.wrap(s,n,break_long_words=True,break_on_hyphens=False))
def comment(s):return '// '+s.replace('\n',' ')+'\n'
def start(title,extra=''):
 return 'digraph G {\n'+f'graph [bgcolor="white", fontname="Noto Sans CJK SC", fontsize=20, labelloc=t, label={q(title)}, pad=0.45, nodesep=0.65, ranksep=1.0, splines=ortho, dpi=150{extra}];\n'+'node [shape=box, style="rounded,filled", fillcolor="white", color="#858585", penwidth=1.1, fontname="Noto Sans CJK SC", fontsize=14, margin="0.18,0.14"];\nedge [color="#666666", penwidth=1.0, fontname="Noto Sans CJK SC", fontsize=11, arrowsize=0.7];\n'
def save(view,body):
 p=ROOT/(view['stem']+'.puml');p.write_text('@startdot\n'+body+'}\n@enddot\n',encoding='utf-8')
 view['visual_style']='按用户参考：白底圆角细灰线、紫色小图标；保留原语义，PlantUML @startdot投影'
 view['model_sha256']=hashlib.sha256((ROOT/view['model_file']).read_bytes()).hexdigest()
 records.append(view)

rdnames={
 '3.3.1.2':['制热请求输入','环境与电池热负荷适配','电加热使能条件','电加热通断控制','电加热过温保护','加热状态反馈','舱内外温度信息获取'],
 '3.3.1.6':['AUTO请求与状态','环境与温度信息采集','自动温控协调','目标温度调节','循环操作保持AUTO','模式退出与切换','AC操作处理'],
 '3.3.1.9':['风窗请求与反馈','前风窗模式配置','空调状态反馈','模式保持与退出','除湿制冷与优先级','低电量除霜许可']}
data={r['req_id']:r for r in json.loads((ROOT/'03_结构化需求清单/结构化需求清单.json').read_text())}
for v in manifest['views']:
 if v['view_type']!='01_需求图':continue
 source=ROOT/v['model_file'];s=source.read_text();rid=re.search(r"requirement def <'([^']+)'>",s)[1]
 leaves=re.findall(r"requirement <'([^']+)'> (\w+) \{\s*doc /\*(.*?)\*/",s,re.S)
 b=start(rid+' '+data[rid]['name']+' · 需求图',', layout=neato, overlap=false, notranslate=true')
 title=f'<FONT COLOR="#8070AC">▣</FONT> «requirement def»<BR/><B>{esc(data[rid]["name"])}</B><BR/>{rid} · 系统需求'
 b+='MAIN [pos="0,0!", shape=plain, label=<<TABLE BORDER="1" COLOR="#858585" CELLBORDER="0" CELLSPACING="0" CELLPADDING="10" STYLE="ROUNDED"><TR><TD>'+title+'</TD></TR><TR><TD BORDER="1" SIDES="T"><I>doc</I><BR/>原需求层次保留</TD></TR></TABLE>>];\n'
 positions=[(-4.5,3.3),(0,4.7),(4.5,3.3),(-4.7,0.2),(4.7,0.2),(-3.0,-3.4),(3.0,-3.4)] if len(leaves)==7 else [(-4.5,3.3),(0,4.7),(4.5,3.3),(-4.7,-0.2),(4.7,-0.2),(0,-3.7)]
 for i,((ident,alias,doc),(x,y),name) in enumerate(zip(leaves,positions,rdnames[rid])):
  label='<FONT COLOR="#8070AC">▣</FONT> «requirement»<BR/>'+ident+'<BR/>'+lines(name,14)+'<BR/><FONT POINT-SIZE="11">系统需求</FONT>'
  b+=f'R{i} [pos="{x},{y}!", width=2.6, height=0.95, label=<{label}>];\n'
  b+=f'MAIN -> R{i} [dir=both, arrowtail=diamond, arrowhead=none];\n'
  b+=comment(ident+' | '+alias+' | '+' '.join(doc.split()))
  details.append(dict(requirement_id=ident,display_name=name,model_alias=alias,text=' '.join(doc.split()),source_model=v['model_file']))
 b+=comment('连线保留原SysML嵌套包含含义；中心端菱形不表示新增deriveReqt/satisfy。详细doc见需求条目明细。')
 v['display_names']=dict(zip([x[0] for x in leaves],rdnames[rid]));save(v,b)

# 从官方原生解析后的视图导出读取动作、决策节点和实际successions。
AUDIT=ROOT/'05_整体检查与修改说明/SysML原生校验'
native_report=json.loads((AUDIT/'修改后原生诊断.json').read_text())
assert native_report['errors']==0 and native_report['warnings']==0
validated={r['file']:r['sha256'] for r in native_report['files']}
for model in MODEL.glob('*.sysml'):
 assert hashlib.sha256(model.read_bytes()).hexdigest()==validated[model.name],('模型已改动，先运行原生校验与导出',model.name)
graphs={g['req_id']:g for g in json.loads((AUDIT/'显式动作关系索引.json').read_text())}
norm=lambda x: re.sub(r"[\s']+",'',html.unescape(x))
labels={'heatingEnableChoice':'使能条件判断','overtemperatureChoice':'是否达到过温上限','protectionMemoryChoice':'原保护是否激活','recoveryChoice':'是否达到恢复条件','enableMerged':'使能分支合并','protectionMerged':'保护分支合并','autoActiveChoice':'AUTO是否激活','userOperationChoice':'用户操作分类','operationMerged':'操作分支合并','feedbackMerged':'状态反馈路径合并','supportedFrontRequest':'请求是否有前风窗依据'}
translations={'heatingAllowed':'全部加热使能条件满足','not heatingAllowed':'任一加热使能条件不满足','heaterTemperature >= cutOffTemperature':'加热温度 ≥ 待标定上限','heaterTemperature < cutOffTemperature':'加热温度 < 待标定上限','protectionWasActive':'原保护已激活','not protectionWasActive':'原保护未激活','heaterTemperature <= recoveryTemperature':'加热温度 ≤ 待标定恢复温度','heaterTemperature > recoveryTemperature':'加热温度 > 待标定恢复温度',"'处理请求并反馈AUTO状态'.autoModeActive":'AUTO已激活',"not '处理请求并反馈AUTO状态'.autoModeActive":'AUTO未激活','operation == AutoOperation::temperature or operation == AutoOperation::circulation':'温度或循环操作','operation == AutoOperation::airflow or operation == AutoOperation::distribution':'风量或吹风模式操作','operation == AutoOperation::frontDefrost':'前除霜操作','operation == AutoOperation::ac':'AC操作','operation == AutoOperation::autoRepeat':'再次AUTO操作','operation == AutoOperation::noChange':'无新增操作','requestKind == WindscreenRequestKind::frontDefrost or requestKind == WindscreenRequestKind::frontDemist':'有依据的前除霜或前除雾请求','requestKind == WindscreenRequestKind::rearUnspecified or requestKind == WindscreenRequestKind::unresolved':'后风窗或依据不足请求'}
translations={norm(k):v for k,v in translations.items()}
for v in manifest['views']:
 if v['view_type']!='02_需求活动图':continue
 rid=Path(v['model_file']).name.split('-')[0];source=(ROOT/v['model_file']).read_text();g=graphs[rid]
 native_path=AUDIT/'官方视图导出'/(Path(v['model_file']).stem+'.puml');native=native_path.read_text()
 pairs=re.findall(r'^rec usage "([^"\n]+)" as (E\d+).*?action',native,re.M)
 actions={alias:name for name,alias in pairs if name!='需求活动执行流程'}
 choices={alias:name for name,alias in re.findall(r'^choice "([^"\n]+)" as (E\d+)',native,re.M)}
 aliases={**actions,**choices};network=[]
 for src,dst,guard in re.findall(r'^(E\d+|\[\*\])\s+-->\s+(E\d+|\[\*\])[^\n:]*?(?: : \[(.*)\])? *$',native,re.M):
  network.append(dict(source=('start' if src=='[*]' else aliases[src]),target=('done' if dst=='[*]' else aliases[dst]),guard=guard or ''))
 assert set(actions.values())==set(g['actions'])
 assert set(choices.values())==set(g['decision_nodes']+g['merge_nodes'])
 expected={(e['source'],e['target'],norm(e['guard'])) for e in g['successions']}
 actual={(e['source'],e['target'],norm(e['guard'])) for e in network}
 assert actual==expected,(rid,actual^expected)
 ids={name:'N'+str(i) for i,name in enumerate(['start']+list(actions.values())+list(choices.values())+['done'])}
 b=start(rid+' '+data[rid]['name']+' · 需求活动图',', rankdir=TB, ranksep=0.6, dpi=130, splines=polyline')
 for name,ident in ids.items():
  if name in ['start','done']:
   b+=ident+' [shape=circle, width=0.16, height=0.16, fixedsize=true, style=filled, fillcolor="'+('#666666' if name=='start' else 'white')+'", peripheries='+('1' if name=='start' else '2')+', label=""];\n'
  elif name in choices.values():
   b+=ident+' [shape=diamond, style=filled, width=1.8, height=0.6, fontsize=11, label='+q(labels[name])+'];\n'
  else:
   b+=ident+' [width=2.4, height=0.65, label=<<FONT COLOR="#8070AC">▣</FONT> «action»<BR/>'+lines(name,12)+'>];\n'
 for e in network:
  guard=e['guard'];display=translations.get(norm(guard),guard)
  b+=ids[e['source']]+' -> '+ids[e['target']]+' [arrowhead=vee'+(', label='+q('\n'.join(textwrap.wrap(display,14))) if guard else '')+'];\n'
  b+=comment('successions: '+e['source']+' -> '+e['target']+' ['+guard+']')
 note='一次评估快照；抽象动作不代表实车仿真。'
 if rid=='3.3.1.2':note+='\n全部使能：送风开启、目标温度>舱温、高压可用、无整车故障、SOC>10%。\n保护状态由调用方输入，阈值XXX待标定；最终许可受使能与保护共同约束。'
 if rid=='3.3.1.6':note+='\n请求处理动作输出AUTO激活状态；重复AUTO操作策略待确认。'
 if rid=='3.3.1.9':note+='\n后风窗等依据不足请求单独待确认，不进入前风窗配置链。'
 b+='NOTE [shape=note, fontsize=11, label='+q(note)+'];\n'+ids['done']+' -> NOTE [style=invis];\n'
 v['phase_names']=re.findall(r"\baction '([^']+)'",source)[1:]
 v['projection']='官方SysML v2 Pilot原生导出的successions与guard逐条交叉核对；参考样式重排'
 v['action_network']=dict(nodes=ids,edges=network)
 v['native_export_file']=str(native_path.relative_to(ROOT));v['native_export_sha256']=hashlib.sha256(native_path.read_bytes()).hexdigest()
 save(v,b)

# BDD方形端口：每个原端口是真实可连接的HTML table PORT，而不是新增物理实体。
v=next(x for x in manifest['views'] if x['view_type']=='04_需求外部环境BDD图')
s=(ROOT/v['model_file']).read_text()
defs={name:ports for name,ports in re.findall(r"part def '([^']+)' \{(.*?)\n    }",s,re.S)}
parts=[(a,n) for a,n in re.findall(r"\bpart (\w+) : '([^']+)';",s) if n!='热管理控制外部环境']
connections=re.findall(r'\binterface (\w+) : (\w+)\s+connect ([\w.]+) to ([\w.]+);',s)
portdata={a:re.findall(r'port (\w+) : (~?\w+);',defs[n]) for a,n in parts}
portnames={'requestIn':'用户请求输入','requestOut':'用户请求输出','statusIn':'状态显示接收','statusOut':'控制状态反馈','vehicleStateIn':'整车状态输入','stateOut':'整车状态输出','sensorDataIn':'温度环境输入','dataOut':'温度环境输出','actuatorCommandOut':'调节指令输出','commandIn':'调节指令接收','cabinEffectOut':'抽象调节效果输出','effectIn':'抽象效果接收'}
outputs={x for _,_,x,_ in connections};pos={'SYS':(0,0),'CAN':(0,5),'IVI':(-4.8,5),'VEHICLE':(-6.2,0.8),'SENSORS':(-6.2,-2.3),'ACTUATORS':(6.2,0.8),'CABIN_WINDSCREEN':(6.2,-2.3)}
b=start('热管理三条需求 · 外部环境模型',', layout=neato, overlap=true, notranslate=true, splines=line')
b+='subgraph cluster_context {label="热管理逻辑控制外部环境"; color="#858585"; penwidth=1.1;\n'
positions={'SYS':(0,0,3.8,3.0),'IVI':(0,4.6,3.6,0.9),'CAN':(0,2.8,3.6,0.9),'VEHICLE':(-6.2,0.8,3.7,1.0),'SENSORS':(-6.2,-1.2,3.7,1.0),'ACTUATORS':(6.2,0.8,3.7,1.0),'CABIN_WINDSCREEN':(6.2,-1.2,3.7,1.0)}
pins={
 'SYS.requestIn':(-0.65,1.5), 'SYS.statusOut':(0.65,1.5),
 'SYS.vehicleStateIn':(-1.9,0.6), 'SYS.sensorDataIn':(-1.9,-0.6),
 'SYS.actuatorCommandOut':(1.9,0.6), 'SYS.cabinEffectOut':(1.9,-0.6),
 'IVI.requestOut':(-0.65,4.15), 'IVI.statusIn':(0.65,4.15),
 'CAN.requestIn':(-0.65,3.25), 'CAN.statusOut':(0.65,3.25),
 'CAN.requestOut':(-0.65,2.35), 'CAN.statusIn':(0.65,2.35),
 'VEHICLE.stateOut':(-4.35,0.8),'SENSORS.dataOut':(-4.35,-1.2),
 'ACTUATORS.commandIn':(4.35,0.8),'CABIN_WINDSCREEN.effectIn':(4.35,-1.2)}
labels={
 'SYS.requestIn':(-1.9,1.85),'SYS.statusOut':(1.9,1.85),
 'CAN.requestOut':(-1.9,2.05),'CAN.statusIn':(1.9,2.05),
 'CAN.requestIn':(-1.9,3.55),'CAN.statusOut':(1.9,3.55),
 'IVI.requestOut':(-1.9,3.9),'IVI.statusIn':(1.9,3.9),
 'SYS.vehicleStateIn':(-2.8,0.25),'SYS.sensorDataIn':(-2.8,-0.25),
 'SYS.actuatorCommandOut':(2.8,0.25),'SYS.cabinEffectOut':(2.8,-0.25),
 'VEHICLE.stateOut':(-3.8,1.15),'SENSORS.dataOut':(-3.8,-1.55),
 'ACTUATORS.commandIn':(3.8,1.15),'CABIN_WINDSCREEN.effectIn':(3.8,-1.55)}
for alias,name in parts:
 x,y,w,h=positions[alias];display={'CABIN_WINDSCREEN':'cabin'}.get(alias,alias.lower())
 label='<FONT COLOR="#8070AC">▣</FONT> «part»<BR/>'+display+' : '+lines(name,13)
 b+=alias+f' [pos="{x},{y}!", width={w}, height={h}, fixedsize=true, label=<'+label+'>];\n'
 for port,typ in portdata[alias]:
  key=alias+'.'+port;px,py=pins[key];lx,ly=labels[key];pid=alias+'__'+port
  b+=pid+f' [shape=box, style=filled, pos="{px},{py}!", width=0.12, height=0.12, fixedsize=true, margin=0, label=""];\n'
  b+=pid+'_label'+f' [shape=plain, pos="{lx},{ly}!", fontsize=11, label='+q(portnames[port])+'];\n'
  b+=comment(key+' : '+typ+'；方形端口为原part上的端口，不是新增外部角色')
for alias,typ,a,c in connections:
 aa,ap=a.split('.');cc,cp=c.split('.')
 src=aa+'__'+ap;dst=cc+'__'+cp;xy1=pins[a];xy2=pins[c]
 if xy1[0]==xy2[0] or xy1[1]==xy2[1]:
  b+=src+' -> '+dst+' [dir=none];\n'
 else:
  mid=(xy1[0]+xy2[0])/2;g1=alias+'_bend1';g2=alias+'_bend2'
  for guide,x,y in [(g1,mid,xy1[1]),(g2,mid,xy2[1])]:b+=guide+f' [shape=point, pos="{x},{y}!", width=0, height=0, style=invis, label=""];\n'
  b+=src+' -> '+g1+' -> '+g2+' -> '+dst+' [dir=none];\n'
 b+=comment(alias+' : '+typ+' connect '+a+' to '+c)
for name,fields in v['port_type_features'].items():b+=comment(name+' '+', '.join(k+':'+t for k,t in fields))
b+=comment('保留原7个角色、6种端口类型及8个interface connect；原技术特征见外部接口明细。布局不裁定物理归属。')
b+='}\n'
save(v,b)

# 用例图所有格式不写入、不重新渲染。
records.append(original_uc);records.sort(key=lambda r:(r['view_type'],r['stem']))
env={**os.environ,'PLANTUML_LIMIT_SIZE':'16384','XDG_CACHE_HOME':'/workspace/.cache'}
targets=[str(ROOT/(v['stem']+'.puml')) for v in records if v['view_type']!='03_需求用例图']
for target in targets:
 content=Path(target).read_text();dot=content.split('@startdot',1)[1].rsplit('@enddot',1)[0]
 for ext in ['png','svg']:
  artifact=Path(target).with_suffix('.'+ext)
  result=subprocess.run(['dot','-T'+ext,'-o',str(artifact)],input=dot,text=True,capture_output=True)
  assert result.returncode==0,result.stderr
  if ext=='png':
   with Image.open(artifact) as check:check.verify()
  else:
   tree=ET.parse(artifact);assert len(tree.findall('.//{http://www.w3.org/2000/svg}g'))>10,'空SVG或工具提示占位'
for view in records:
 if view['view_type']=='03_需求用例图':continue
 for ext in ['puml','png','svg']:
  p=ROOT/(view['stem']+'.'+ext);assert p.is_file() and p.stat().st_size>0
  view['artifacts'][ext]=dict(file=str(p.relative_to(ROOT)),bytes=p.stat().st_size,sha256=hashlib.sha256(p.read_bytes()).hexdigest())
  if ext=='png':
   with Image.open(p) as im:view['png_dimensions']=list(im.size);im.verify()
  if ext=='svg':
   tree=ET.parse(p);assert 'Syntax Error' not in ''.join(tree.getroot().itertext())
assert all(hashlib.sha256((ROOT/original_uc['artifacts'][e]['file']).read_bytes()).hexdigest()==h for e,h in uc_before.items())
manifest['views']=records;manifest['visual_revision']='按用户三张参考图调整RD/ACT/BDD；UC字节不变；2026-11-03'
manifest['source_type']='SysML v2 Pilot 0.63.1原生检查通过；ACT原生视图关系核对；参考布局投影；UC原样保留'
manifest['renderer']='Graphviz dot 2.42.4直接渲染@startdot中的DOT，避免PlantUML对SVG的功能提示占位'
manifest['native_report']='05_整体检查与修改说明/SysML原生校验/修改后原生诊断.json'
(OUT/'渲染与模型对应清单.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
(OUT/'需求条目明细.json').write_text(json.dumps(details,ensure_ascii=False,indent=2)+'\n')
md='# 需求条目明细\n\n需求图改为参考图的简洁卡片；原doc正文完整保留在本表及SysML中，不因图形精简而删除要求。\n\n|需求ID|图中名称|原模型标识|原doc|\n|---|---|---|---|\n'
for d in details:md+='|'+d['requirement_id']+'|'+d['display_name']+'|'+d['model_alias']+'|'+d['text']+'|\n'
(OUT/'需求条目明细.md').write_text(md)
md='# 外部接口明细\n\nBDD按参考图显示方形端口及中文角色，接口定义及特征仍以当前SysML为准。未添加参考图中的BMS、电驱或远控等不属于原三需求模型的角色。\n\n|接口ID|接口类型|来源端口|目标端口|\n|---|---|---|---|\n'
for a,t,x,y in connections:md+='|'+a+'|'+t+'|'+x+'|'+y+'|\n'
md+='\n## 端口特征\n\n'
for t,fields in v['port_type_features'].items():md+='- '+t+'：'+', '.join(k+':'+typ for k,typ in fields)+'\n'
(OUT/'外部接口明细.md').write_text(md)
print('Restyled 7 sets (21 files); use case puml/png/svg unchanged.')
for view in records:print(view['stem'],view['png_dimensions'])
