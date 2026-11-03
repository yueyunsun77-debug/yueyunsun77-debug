from pathlib import Path
from collections import Counter
import argparse,hashlib,json,re,xml.etree.ElementTree as ET
from openpyxl import load_workbook

ROOT=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser()
parser.add_argument('--source-dir',type=Path,default=ROOT/'原始文件备份',help='本地原始文件备份目录；GitHub仅发布生成成果，需从本地成果包提供此目录')
SOURCE_DIR=parser.parse_args().source_dir
def source_path(relative):
 p=Path(relative)
 return SOURCE_DIR/Path(*p.parts[1:]) if p.parts[0]=='原始文件备份' else ROOT/p
def run():
 assert SOURCE_DIR.is_dir(),'请用 --source-dir 指定本地原始文件备份目录；GitHub成果不含原始材料。'
 rs=json.loads((ROOT/'03_结构化需求清单/结构化需求清单.json').read_text())
 keys={'req_id','name','description','type','category','source_refs','extras'}
 assert rs and len({r['req_id'] for r in rs})==len(rs),'需求ID重复'
 for r in rs:
  assert set(r)==keys,('顶层结构',r['req_id'])
  assert all(isinstance(r[k],str) and r[k] for k in ['req_id','name','description','type','category'])
  assert isinstance(r['source_refs'],list) and r['source_refs'] and isinstance(r['extras'],dict)
  assert not (keys & set(r['extras'])),'通用字段重复放入extras'
  for ref in r['source_refs']:
   p=source_path(ref['file']);assert p.is_file(),ref
   if 'sheet' in ref:
    ws=load_workbook(p,data_only=True)[ref['sheet']]
    if 'row' in ref:assert 1<=ref['row']<=ws.max_row
 indicators=[r for r in rs if r['type']=='指标']
 original=next(SOURCE_DIR.glob('*需求条目.json'))
 old=json.loads(original.read_text());assert {r['req_id'] for r in old}<={r['req_id'] for r in rs}
 source=next(SOURCE_DIR.glob('*指标分配表.xlsx'))
 source_rows=list(load_workbook(source,data_only=True).active.values)[1:]
 coverage=Counter(r['extras']['original_row'] for r in indicators if 'original_row' in r['extras'])
 assert set(coverage)==set(range(2,len(source_rows)+2)),coverage
 assert all(coverage[i]==(2 if i in [20,31] else 1) for i in coverage)
 assert len(indicators)==41 and len(rs)==75
 expected=['序号','部件/功能名称','指标类型','指标名称','度量单位','度量范围','默认值','描述']
 selected=[r for r in indicators if r['extras'].get('in_selected_requirement_tables')]
 scene=[r for r in indicators if not r['extras'].get('in_selected_requirement_tables')]
 assert len(selected)==36 and len(scene)==5
 assert {r['req_id'] for r in selected}=={f'IND-{i:03d}' for i in range(1,37)}
 assert {r['req_id'] for r in scene}=={f'IND-{i:03d}' for i in range(37,42)}
 tables=[]
 for name in ['指标分析表','指标分配表']:
  wb=load_workbook(ROOT/'02_指标分析与指标分配'/(name+'.xlsx'),data_only=True)
  ws=wb.active;assert ws.max_column==8 and list(next(ws.values))==expected
  values=list(ws.values)[1:];assert len(values)==len(selected)
  for row,r in zip(values,selected):
   x=r['extras'];n=int(r['req_id'].split('-')[1])
   owner=x['analysis_function_name'] if name=='指标分析表' else x['component_function_name']
   assert list(row)==[n,owner,x['indicator_type'],r['name'],x['measurement_unit'] or '未提供',x['measurement_range'],x['default_value'],r['description']],r['req_id']
   assert x['parent_requirement'] in {r['req_id'] for r in old}
   assert r['category'] in ['功能性','非功能性','性能','安全性','可靠性']
  tables.append(values)
 for a,b in zip(*tables):assert a[0]==b[0] and a[2:]==b[2:]
 scenario_ws=load_workbook(ROOT/'04_三个场景功能与逻辑分析/场景参数表.xlsx',data_only=True).active
 assert scenario_ws.max_column==8 and list(next(scenario_ws.values))==expected
 scenario_values=list(scenario_ws.values)[1:];assert len(scenario_values)==len(scene)
 for row,r in zip(scenario_values,scene):
  x=r['extras'];assert list(row)==[int(r['req_id'].split('-')[1]),x['component_function_name'],x['indicator_type'],r['name'],x['measurement_unit'] or '未提供',x['measurement_range'],x['default_value'],r['description']]
  assert x['applicable_requirement_ids']==[]
 manifest=json.loads((ROOT/'05_整体检查与修改说明/原始证据清单.json').read_text())
 assert len(manifest)==15
 for e in manifest:
  p=source_path(e['file']);assert p.stat().st_size==e['bytes'] and hashlib.sha256(p.read_bytes()).hexdigest()==e['sha256']
 mapping=load_workbook(ROOT/'01_系统边界与逻辑化表达/物理组件与逻辑功能映射表.xlsx',data_only=True).active
 assert mapping.max_row==78 and {r[0] for r in list(mapping.values)[1:]}==set(range(1,78))
 md=ROOT/'01_系统边界与逻辑化表达/修改后的SysML模型'
 for p in SOURCE_DIR.glob('*.sysml'):
  old=p.read_text();new=(md/p.name).read_text()
  assert re.findall(r"<'([^']+)'>",old)==re.findall(r"<'([^']+)'>",new),p.name
  if 'BDD' in p.name:
   assert re.findall(r'\bflow\s+[^;]+;',old)==re.findall(r'\bflow\s+[^;]+;',new),'BDD流丢失'
   assert re.findall(r'\binterface\s+(\w+)\s*:',old)==re.findall(r'\binterface\s+(\w+)\s*:',new)
   assert len(re.findall(r'\bconnect\b',old))==len(re.findall(r'\bconnect\b',new))
  if '用例' in p.name:
   assert re.findall(r'\brequire\s+\w+;',old)==re.findall(r'\brequire\s+\w+;',new)
   assert re.findall(r"use case def '([^']+)'",old)==re.findall(r"use case def '([^']+)'",new)
  if '活动图' in p.name:
   acts=re.findall(r"\baction\s+'([^']+)'",new)
   refs=re.findall(r"(?:first|then)\s+'([^']+)'",new)
   assert set(refs)<=set(acts),p.name
   assert len(acts)>=len(re.findall(r"\baction\s+'([^']+)'",old))
   # 原主阶段保留检查在原生语义复核中；允许新增显式决策分支动作。
 for p in md.glob('*.sysml'):
  s=re.sub(r'/\*.*?\*/|//[^\n]*','',p.read_text(),flags=re.S)
  assert s.count('{')==s.count('}'),p.name
  assert not re.search(r"\bpart(?:\s+def)?\s+'?(?:压缩机|鼓风机|冷却板|温度传感器|PTC继电器)",s),p.name
 mids=set(re.findall(r"<'(IND-\d+)'>",(md/'独立指标需求.sysml').read_text()))
 assert mids=={r['req_id'] for r in indicators}
 catalogue=list(load_workbook(ROOT/'02_指标分析与指标分配/逻辑功能目录.xlsx',data_only=True).active.values)[1:]
 lookup=dict(catalogue)
 assert all(lookup[r['extras']['function_id']]==r['extras']['component_function_name'] for r in indicators)
 countfunctions=countrelations=0
 scenario_folders=[p for p in (ROOT/'04_三个场景功能与逻辑分析').glob('场景*') if p.is_dir()]
 assert len(scenario_folders)==3
 for folder in scenario_folders:
  fs=list(load_workbook(folder/'功能清单.xlsx',data_only=True).active.values)[1:]
  es=list(load_workbook(folder/'功能关系表.xlsx',data_only=True).active.values)[1:]
  ids={x[0] for x in fs};assert len(ids)==len(fs)
  for a,b,_,_ in es:assert a in ids and b in ids
  for x in fs:assert x[6] in {r['req_id'] for r in rs}
  countfunctions+=len(fs);countrelations+=len(es)
 assert countfunctions==31 and countrelations==38
 for p in ROOT.rglob('*.svg'):ET.parse(p)
 for p in ROOT.rglob('*.md'):
  for target in re.findall(r'\]\(([^)]+)\)',p.read_text()):
   if not target.startswith(('http:','https:','#')):assert (p.parent/target).exists(),(p.name,target)
 result=dict(requirements=len(rs),indicators=len(indicators),selected_table_indicators=len(selected),separate_scenario_parameters=len(scene),original_indicator_rows=len(source_rows),original_source_files=len(manifest),physical_entities=77,scenario_functions=countfunctions,scenario_relations=countrelations,original_models=8,rendered_new_diagrams=4)
 print(json.dumps(result,ensure_ascii=False,indent=2));return result
if __name__=='__main__':run()
