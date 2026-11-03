from pathlib import Path
import json,hashlib
from collections import Counter
from openpyxl import load_workbook

ROOT=Path(__file__).resolve().parents[1]
def payload(rows):
 return [dict(req_id=r['req_id'],name=r['name'],description=r['description'],type=r['type'],category=r['category'],source_refs=r['source_refs'],values={k:r['extras'][k] for k in ['measurement_unit','measurement_range','default_value','indicator_type','component_function_name','function_id']}) for r in rows if r['type']=='指标']
def run():
 rs=json.loads((ROOT/'03_结构化需求清单/结构化需求清单.json').read_text())
 scope=json.loads((ROOT/'02_指标分析与指标分配/指标范围与表格对应关系.json').read_text())
 selected=[r for r in rs if r['type']=='指标' and r['extras']['in_selected_requirement_tables']]
 scenes=[r for r in rs if r['type']=='指标' and not r['extras']['in_selected_requirement_tables']]
 assert [r['req_id'] for r in selected]==scope['main_indicator_ids']
 assert [r['req_id'] for r in scenes]==scope['scenario_parameter_ids']
 assert len(selected)==36 and len(scenes)==5
 digest=hashlib.sha256(json.dumps(payload(rs),ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest()
 assert digest==scope['baseline_indicator_value_sha256'],'指标名/值/来源等发生未说明的变化'
 headers=scope['main_table_headers'];main=[]
 for name in ['指标分析表','指标分配表']:
  ws=load_workbook(ROOT/'02_指标分析与指标分配'/(name+'.xlsx'),data_only=True).active
  assert ws.max_column==8 and list(next(ws.values))==headers and ws.max_row==37
  rows=list(ws.values)[1:];main.append(rows)
  for row,r in zip(rows,selected):
   x=r['extras'];expected_owner=x['analysis_function_name'] if name=='指标分析表' else x['component_function_name']
   assert row[0]==int(r['req_id'].split('-')[1]) and row[1]==expected_owner
   assert list(row[2:])==['属性',r['name'],'-' if x['measurement_unit'] in [None,'','未提供'] else x['measurement_unit'],x['measurement_range'],'-' if x['default_value'] in [None,''] else x['default_value'],r['description']]
   assert x['parent_requirement'] in scope['selected_requirement_ids']
   assert set(x['applicable_requirement_ids'])<=set(scope['selected_requirement_ids'])
 for a,b in zip(*main):assert a[0]==b[0] and a[2:]==b[2:]
 ws=load_workbook(ROOT/'04_三个场景功能与逻辑分析/场景参数表.xlsx',data_only=True).active
 assert ws.max_row==6 and ws.max_column==8 and list(next(ws.values))==headers
 for row,r in zip(list(ws.values)[1:],scenes):
  x=r['extras'];assert row[0]==int(r['req_id'].split('-')[1]) and row[1]==x['component_function_name'] and row[3]==r['name']
  assert row[5]==x['measurement_range'] and row[6]==x['default_value'] and x['applicable_requirement_ids']==[]
 original_rows=Counter(r['extras']['original_row'] for r in selected if 'original_row' in r['extras'])
 assert set(original_rows)==set(range(2,32))
 assert all(count==(2 if row in [20,31] else 1) for row,count in original_rows.items())
 mapping=list(load_workbook(ROOT/'03_结构化需求清单/指标与JSON需求条目映射表.xlsx',data_only=True).active.values)[1:]
 assert {row[1] for row in mapping}=={r['req_id'] for r in selected+scenes}
 for row in mapping:
  assert ('场景参数表.xlsx' in row[11])==(row[1] in scope['scenario_parameter_ids'])
 assert len({r['req_id'] for r in rs})==len(rs)==75
 assert all(set(r)=={'req_id','name','description','type','category','source_refs','extras'} for r in rs)
 print(json.dumps(dict(selected_main_rows=36,main_table_fields=8,original_rows_covered=30,source_derived_rows=32,associated_pdf_rows=4,separate_scenario_rows=5,unresolved_main_rows=len(scope['unresolved_main_ids']),primary_requirement_counts=dict(Counter(r['extras']['parent_requirement'] for r in selected)),all_indicator_values_and_sources_unchanged=True,total_json_records=75),ensure_ascii=False,indent=2))
if __name__=='__main__':run()
