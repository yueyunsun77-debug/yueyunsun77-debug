from pathlib import Path
from zipfile import ZipFile
from openpyxl import load_workbook
import json,re,hashlib,itertools,collections,sys
import jsonschema

# Copy this script into the release's 检查工具 directory; run it from any working directory.
R=Path(__file__).resolve().parents[1]
if not (R/'功能抽取').exists():R=Path('/workspace/work/1123/11.23SEOV案例_优化版')
def rd(p):return json.loads((R/p).read_text())
def write(p,x):(R/p).write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n')
checks=[]
def check(name,condition,detail=''):
 checks.append({'name':name,'passed':bool(condition),'detail':detail})
 if not condition:raise AssertionError(name+': '+str(detail))
fs=rd('功能抽取/功能清单_SEOV.json');by={f['function_id']:f for f in fs};req=rd('结构化需求条目/结构化需求清单.json');bs=rd('行为模型/行为节点与转移清单.json');cases=rd('行为模型/守卫边界验证用例.json')
with ZipFile(R/'00_修改依据/11.17版本基线.zip') as z:
 baseline=json.loads(z.read('11.17SEOV案例/结构化需求条目/结构化需求清单.json'))
 oldfs=json.loads(z.read('11.17SEOV案例/功能抽取/功能清单_SEOV.json'))
 oldpool=json.loads(z.read('11.17SEOV案例/功能抽取/扩充候选功能池_201项.json'))
oldreq={q['req_id']:q for q in baseline}
jsonschema.validate(req,rd('下游导入包/需求清单.schema.json'));check('需求JSON Schema',True)
jsonschema.validate(fs,rd('下游导入包/功能清单.schema.json'));check('功能JSON Schema',True)
check('原75条需求ID保留且唯一',len(req)==75 and len({q['req_id'] for q in req})==75 and {q['req_id'] for q in req}==set(oldreq))
for q in req:
 if not q['req_id'].startswith('IND-'):continue
 old=oldreq[q['req_id']];x=q['extras'];ox=old['extras']
 check(q['req_id']+'原条款及原值保留',all(q[k]==old[k] for k in ['req_id','name','description','source_refs']) and all(x[k]==ox[k] for k in ['measurement_unit','measurement_range','default_value','function_id']), '分类变更通过legacy_type/category/indicator_type及迁移理由保留，不改变数值、比较符或来源声明')
 check(q['req_id']+'分类迁移可追溯',x['legacy_type']==old['type'] and x['legacy_category']==old['category'] and x['legacy_indicator_type']==ox['indicator_type'] and x['classification_reason'])
 check(q['req_id']+'功能分配对象有效',x['component_function_name']==(by[x['function_id']]['name'] if x['function_id'] in by else '后风窗控制（待确认）'))
check('条款性质分类统计',collections.Counter(q['type'] for q in req if q['req_id'].startswith('IND-'))=={'指标':8,'硬约束':32,'软约束':1})
head=('序号','部件/功能名称','指标类型','指标名称','度量单位','度量范围','默认值','描述')
def table(p):return list(load_workbook(R/p,data_only=False).active.values)
ind=[q for q in req if q['req_id'].startswith('IND-')];metrics=[q for q in ind if q['type']=='指标']
for prefix,qs in [('',metrics),('全部41条约束与',ind)]:
 a=table('指标分析、分配表/'+prefix+'指标分析表.xlsx');b=table('指标分析、分配表/'+prefix+'指标分配表.xlsx')
 check(prefix+'指标表八字段及两表一致',a==b and a[0]==head and len(a)==len(qs)+1)
 for row,q in zip(a[1:],qs):
  x=q['extras'];check(prefix+q['req_id']+'表JSON逐字段对应',row==(int(q['req_id'][4:]),x['component_function_name'],x['requirement_nature'],q['name'],x['measurement_unit'] or '未提供',x['measurement_range'],x['default_value'],q['description']))
check('功能ID保留与细化',len(fs)==len(by)==73 and {f['function_id'] for f in oldfs}<=set(by))
canonical={f['canonical_function_id'] for f in fs};check('规范功能及组合层级统计',len(canonical)==69 and len([f for f in fs if f['abstraction_level']=='组合功能'])==3 and len([f for f in fs if f['abstraction_level']=='叶级功能'])==66)
check('V+O及能力字段',all(f['name']==f['v']+f['o']==f['action']==f['domain_action'] and f['s'] is None and f['required_capability'] is None for f in fs))
types={t['type_id']:t for t in rd('功能抽取/概念接口类型字典.json')};ports=[]
for f in fs:
 check(f['function_id']+'模型定位有效',(R/f['source_model_path'][0]).exists())
 for direction in ['inputs','outputs']:
  for p in f[direction]:
   ports.append(p['port_id']);check(p['port_id']+'概念类型与语义角色一致',p['type_ref'] in types and p['concept']==types[p['type_ref']]['concept'] and p['semantic_role']==types[p['type_ref']]['role'])
 if f.get('child_ids'):check(f['function_id']+'子功能完整',len(f['child_ids'])>1 and all(by[c]['parent_id']==f['function_id'] for c in f['child_ids']))
check('端口ID唯一',len(ports)==len(set(ports)))
check('后风窗不混入可执行功能','LF-025' not in by and len(rd('功能抽取/待确认功能占位.json'))==1)
pool=rd('功能抽取/扩充候选功能池_201项.json');check('201项候选原数据完整保留',pool==oldpool and len(pool)==201)
screen=rd('功能抽取/201项候选功能筛选结论.json');check('201项候选逐项筛选',len(screen)==201 and {x['candidate_id'] for x in screen}=={x['function_id'] for x in pool} and all(x['conditions'] and x['reason'] for x in screen))
tree=rd('功能抽取/功能树.json');treeids=set(tree['nodes'])
check('功能树端点有效',all(set(n['children'])<=treeids for n in tree['nodes'].values()))
check('分解关系端点有效',all(r['source'] in treeids and r['target'] in treeids for r in rd('功能抽取/功能关系.json')))
check('六份行为模型与199条转移',len(bs)==6 and sum(len(b['transitions']) for b in bs)==199)

def parse_model_edges(p):
 edges=[]
 for line in p.read_text().splitlines():
  m=re.fullmatch(r"\s*first (start|done|'[^']+')(?:(?: if )(.*))? then (start|done|'[^']+');\s*",line)
  if m:edges.append({'source':m.group(1).strip("'"),'guard':m.group(2),'target':m.group(3).strip("'")})
 return edges
for b in bs:
 actual=parse_model_edges(R/b['model_file']);expect=[{k:e[k] for k in ['source','guard','target']} for e in b['transitions']]
 check(b['root_id']+'转移真实存在于SysML',actual==expect,'不是只检查JSON：逐条对照实际SysML中的first/if/then')
 nodes={n['name']:n for n in b['nodes']};nodeids=set(nodes)|{'start','done'}
 check(b['root_id']+'所有转移端点存在',all(e['source'] in nodeids and e['target'] in nodeids for e in actual))
 check(b['root_id']+'行为功能引用有效',all(set(n['function_refs'])<=set(by) for n in b['nodes']))
 check(b['root_id']+'显式反馈闭环',any(e['type']=='feedback' and e['target']=='获取本周期快照' for e in b['transitions']))
 reachable={'start'}
 for _ in range(len(nodeids)):
  old=set(reachable);reachable|={e['target'] for e in actual if e['source'] in reachable}
  if old==reachable:break
 check(b['root_id']+'无结构孤立节点',reachable==nodeids)
 for name,n in nodes.items():
  if n['kind']=='decide':check(b['root_id']+'决策节点有显式守卫：'+name,all(e['guard'] for e in actual if e['source']==name) and sum(e['source']==name for e in actual)>=2)

# Evaluate only the supported guard-expression subset; no control law or vehicle dynamics is executed.
def guard(expression,snapshot,projection=None):
 expression=re.sub(r"'获取本周期快照'\.(\w+)",lambda m:'snapshot['+repr(m.group(1))+']',expression)
 expression=re.sub(r"'协调发动机启动'\.(\w+)",lambda m:'projection['+repr(m.group(1))+']',expression)
 expression=re.sub(r'\b\w+::(\w+)\b',lambda m:repr(m.group(1)),expression)
 return bool(eval(expression,{'__builtins__':{}},{'snapshot':snapshot,'projection':projection or {'startCompleted':False}}))
case_results=[]
for c in cases:
 b=next(b for b in bs if b['root_id']==c['root_id']);edges=parse_model_edges(R/b['model_file']);reachable={'start'}
 for _ in range(len(b['nodes'])+3):
  before=set(reachable)
  for e in edges:
   if e['source'] not in reachable:continue
   if e['target']=='获取本周期快照' and e['source']!='start' and e['source']!='初始化驾驶循环与空调请求':continue
   if e['guard'] is None or guard(e['guard'],c['snapshot_overrides']):reachable.add(e['target'])
  if reachable==before:break
 missing=set(c['required_nodes'])-reachable;unexpected=set(c['forbidden_nodes'])&reachable
 passed=not missing and not unexpected;case_results.append({'case_id':c['case_id'],'name':c['name'],'passed':passed,'missing':sorted(missing),'unexpected':sorted(unexpected),'reachable_nodes':sorted(reachable),'scope':'解析实际SysML守卫的单周期可达性；fork/join只检查可达路径，不模拟并发调度或热动力学'})
 check(c['case_id']+'边界路径',passed,{'missing':sorted(missing),'unexpected':sorted(unexpected)})

# Guard partitions are independently enumerated at boundaries; do not accept overlapping or uncovered choices.
coverage=[]
domains={'operation':['temperature','circulation','airflow','distribution','frontDefrost','ac','autoRepeat','noChange'],'requestKind':['frontDefrost','frontDemist','rearUnspecified','unresolved'],'soc':[9.9,10.0,10.1],'targetTemperature':[0.0,1.0],'cabinTemperature':[0.0,1.0],'heaterTemperature':[-1.0,0.0,1.0],'cutOffTemperature':[0.0],'recoveryTemperature':[0.0],'maxValidCellTemperature':[34.9,35.0,35.1],'elapsedSeconds':[0.0,119.999,120.0,1319.999,1320.0]}
for b in bs:
 for n in b['nodes']:
  if n['kind']!='decide':continue
  ee=[e for e in parse_model_edges(R/b['model_file']) if e['source']==n['name']]
  variables=sorted({v for e in ee for v in re.findall(r"'获取本周期快照'\.(\w+)",e['guard'])})
  projection=any('startCompleted' in e['guard'] for e in ee);combinations=0;failures=[]
  for values in itertools.product(*(domains.get(v,[False,True]) for v in variables)):
   for started in ([False,True] if projection else [False]):
    snapshot=dict(zip(variables,values));hits=[e for e in ee if guard(e['guard'],snapshot,{'startCompleted':started})];combinations+=1
    if len(hits)!=1:failures.append({'snapshot':snapshot,'startCompleted':started,'matching_guards':len(hits)})
  coverage.append({'root':b['root_id'],'decision':n['name'],'boundary_combinations':combinations,'passed':not failures,'failures':failures[:5]})
  check(b['root_id']+'守卫互斥与覆盖：'+n['name'],not failures,str(combinations)+'组逻辑/等值边界组合；非标定值')

# Import bundle copies and native static report must match the actual delivered model bytes.
models=rd('下游导入包/模型导入清单.json')
check('19份独立模型及导入副本',len(models)==19 and len({m['source'] for m in models})==19)
for m in models:
 data=(R/m['source']).read_bytes();check(m['source']+'导入副本及摘要一致',data==(R/'下游导入包'/m['bundle_file']).read_bytes() and hashlib.sha256(data).hexdigest()==m['sha256'])
native=rd('修改说明与检查/SysML静态校验报告.json');check('原生SysML静态校验结果',native['errors']==native['warnings']==0 and native['total_files']==19)
for m in models:
 report=next(x for x in native['files'] if x['file']==m['bundle_file']);check(m['source']+'与原生校验摘要一致',report['sha256']==m['sha256'])
check('下游实际验证未虚报',rd('下游导入包/工具验证状态.json')['status']=='未实际导入源理工具')
for source,target in [('功能抽取/功能清单_SEOV.json','功能清单_SEOV.json'),('结构化需求条目/结构化需求清单.json','结构化需求清单.json'),('行为模型/行为节点与转移清单.json','行为节点与转移清单.json')]:check(source+'导入JSON一致',(R/source).read_bytes()==(R/'下游导入包'/target).read_bytes())
broken=[]
for p in R.rglob('*.md'):
 if '00_修改依据' in p.parts:continue
 for link in re.findall(r'\]\(([^)]+)\)',p.read_text()):
  if not link.startswith(('https:','http:','#','<D:')) and not (p.parent/link.split('#')[0]).exists():broken.append([str(p.relative_to(R)),link])
check('文档内部链接有效',not broken,broken)
write('修改说明与检查/守卫与边界验证报告.json',{'passed':all(x['passed'] for x in case_results+coverage),'case_count':len(case_results),'decision_count':len(coverage),'boundary_combinations':sum(x['boundary_combinations'] for x in coverage),'cases':case_results,'guard_partition_coverage':coverage,'limitations':['不是源理工具执行结果','单周期守卫可达性验证不执行控制算法、并发调度或车辆/热动力学','验证用假设阈值不是产品标定，不能回写需求参数']})
write('修改说明与检查/数据一致性检查报告.json',{'date':'2026-11-23','baseline':'11.17版本基线.zip','passed':all(x['passed'] for x in checks),'check_count':len(checks),'counts':{'requirements':75,'legacy_IND_records':41,'metrics':8,'hard_constraints':32,'soft_constraints':1,'function_records':73,'canonical_functions':69,'composite_functions':3,'leaf_functions':66,'candidate_pool':201,'behaviour_models':6,'transitions':199,'sysml_models':19},'checks':checks,'not_verified':['源理工具实际导入','完整整车与热管理仿真','缺失标定与专家采用确认']})
print('PASS',len(checks),'data/model checks;',len(case_results),'boundary cases;',len(coverage),'decision partitions;',sum(x['boundary_combinations'] for x in coverage),'guard combinations')
