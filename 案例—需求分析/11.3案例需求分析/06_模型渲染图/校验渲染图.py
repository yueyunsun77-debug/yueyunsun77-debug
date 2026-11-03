from pathlib import Path
import hashlib,html,json,re,xml.etree.ElementTree as ET
from PIL import Image

ROOT=Path(__file__).resolve().parents[1]
def run():
 manifest=json.loads((ROOT/'06_模型渲染图/渲染与模型对应清单.json').read_text())
 views=manifest['views'];assert len(views)==8
 if 'protected_use_case' in manifest:
  for file,expected in manifest['protected_use_case']['sha256'].items():assert hashlib.sha256((ROOT/file).read_bytes()).hexdigest()==expected,('用例图应保持不变',file)
 assert [len([v for v in views if v['view_type'].startswith(str(i).zfill(2))]) for i in range(1,5)]==[3,3,1,1]
 hashes=0;rd_ids=set()
 for v in views:
  model=ROOT/v['model_file'];source=model.read_text()
  assert hashlib.sha256(model.read_bytes()).hexdigest()==v['model_sha256'],('模型已变动，需重新渲染',v['stem'])
  assert set(v['artifacts'])=={'puml','png','svg'}
  for ext,a in v['artifacts'].items():
   p=ROOT/a['file'];assert p.is_file() and p.stat().st_size==a['bytes']
   assert hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256'],('渲染文件被替换',p)
   hashes+=1
   if ext=='png':
    with Image.open(p) as im:
     assert list(im.size)==v['png_dimensions'];assert min(im.size)>100;im.verify()
   if ext=='svg':
    tree=ET.parse(p);text=''.join(tree.getroot().itertext())
    assert not any(x in text for x in ['Syntax Error','Error line','An error has occurred','This feature has been suppressed'])
    assert len(tree.findall('.//{http://www.w3.org/2000/svg}g'))>10,'SVG应含真实图形'
  puml=(ROOT/v['artifacts']['puml']['file']).read_text()
  assert (puml.startswith('@startuml') and puml.rstrip().endswith('@enduml')) or (puml.startswith('@startdot') and puml.rstrip().endswith('@enddot'))
  if v['view_type']=='01_需求图':
   ids=re.findall(r"<'([^']+)'>",source)
   assert ids==v['requirement_ids'];assert all(x in puml for x in ids);rd_ids.update(ids)
  elif v['view_type']=='02_需求活动图':
   acts=re.findall(r"\baction '([^']+)'",source)[1:]
   assert acts==v['phase_names'];flat=html.unescape(puml.replace('<BR/>','').replace('\\n',''))
   assert all(x in flat for x in acts)
   exported=ROOT/v['native_export_file'];assert hashlib.sha256(exported.read_bytes()).hexdigest()==v['native_export_sha256']
   network=v['action_network'];assert len(network['edges'])>=10
  elif v['view_type']=='03_需求用例图':
   assert re.findall(r"use case def '([^']+)'",source)==v['use_cases']
   assert re.findall(r'\brequire (\w+);',source)==v['require_aliases']
   assert all(x in puml for x in v['use_cases']+v['actors']+v['require_aliases'])
  else:
   connections=re.findall(r'\binterface (\w+) : (\w+)\s+connect ([\w.]+) to ([\w.]+);',source)
   assert len(v['parts'])==7 and len(connections)==8
   assert connections==[(x['name'],x['interface_type'],x['source'],x['target']) for x in v['connections']]
   assert all(x[0] in puml for x in connections)
   for typ,fields in v['port_type_features'].items():
    assert typ in puml and all(field in puml for field,_ in fields)
 report=json.loads((ROOT/manifest['native_report']).read_text());assert report['errors']==0 and report['warnings']==0
 for entry in report['files']:
  model=ROOT/'01_系统边界与逻辑化表达/修改后的SysML模型'/entry['file']
  assert hashlib.sha256(model.read_bytes()).hexdigest()==entry['sha256']
 assert len(rd_ids)==23,'应保留3个主需求+20个原子需求短ID'
 print(json.dumps(dict(views=8,puml=8,png=8,svg=8,verified_artifact_hashes=hashes,retained_rd_ids=23,bdd_roles=7,bdd_interfaces=8,sysml_native_validator_executed=True),ensure_ascii=False,indent=2))
if __name__=='__main__':run()
