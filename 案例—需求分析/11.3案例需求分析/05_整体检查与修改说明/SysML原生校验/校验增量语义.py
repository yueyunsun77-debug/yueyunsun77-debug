from pathlib import Path
from collections import Counter
import hashlib,html,json,re
A=Path(__file__).resolve().parent;R=A.parents[1];M=R/'01_系统边界与逻辑化表达/修改后的SysML模型'
report=json.loads((A/'修改后原生诊断.json').read_text());assert report['total_files']==11 and report['errors']==report['warnings']==0
for entry in report['files']:assert hashlib.sha256((M/entry['file']).read_bytes()).hexdigest()==entry['sha256']
baseline={
'3.3.1.2':['接收制热请求并读取目标温度','检查电加热使能条件','根据使能条件控制电加热通断','监测电加热温度并执行过温保护','反馈电加热状态与功率信息'],
'3.3.1.6':['接收AUTO模式请求','处理请求并反馈AUTO状态','采集环境与温度信号','协调热量与空气调节服务','处理用户操作与模式切换','更新控制输出并持续反馈状态'],
'3.3.1.9':['接收风窗除霜或除雾请求','识别前除霜、前除雾或后风窗请求','配置风口、风量与循环状态','确定AC与制冷能力请求','实施热量与空气调节','反馈模式与空调状态']}
norm=lambda x:re.sub(r"[\s']+",'',html.unescape(x))
summary=[]
for g in json.loads((A/'显式动作关系索引.json').read_text()):
 rid=g['req_id'];source=(R/g['model_file']).read_text();actions=set(g['actions']);decisions=set(g['decision_nodes']);merges=set(g['merge_nodes'])
 assert all(x in actions for x in baseline[rid]),'原主阶段不得丢失'
 assert set(re.findall(r"\baction '([^']+)'",source)[1:])==actions
 assert set(re.findall(r'\bdecide (\w+);',source))==decisions
 assert set(re.findall(r'\bmerge (\w+);',source))==merges
 edges=g['successions'];nodes=actions|decisions|merges|{'start','done'}
 indegree=Counter(e['target'] for e in edges);outdegree=Counter(e['source'] for e in edges)
 for n in actions:
  assert indegree[n]==1,(rid,n,'互斥汇入必须显式merge，防止隐式同步')
  assert outdegree[n]==1,(rid,n,'分支必须经decide')
 for n in decisions:assert indegree[n]==1 and outdegree[n]>=2 and all(e['guard'] for e in edges if e['source']==n)
 for n in merges:assert indegree[n]>=2 and outdegree[n]==1
 assert indegree['start']==0 and outdegree['start']==1 and outdegree['done']==0
 reached={'start'}
 while True:
  next_nodes=reached|{e['target'] for e in edges if e['source'] in reached}
  if next_nodes==reached:break
  reached=next_nodes
 assert reached==nodes
 native=(A/'官方视图导出'/(rid+'-需求活动图.puml')).read_text()
 aliases={a:n for n,a in re.findall(r'^rec usage "([^"\n]+)" as (E\d+).*?action',native,re.M) if n!='需求活动执行流程'}
 aliases.update({a:n for n,a in re.findall(r'^choice "([^"\n]+)" as (E\d+)',native,re.M)})
 actual=set()
 for src,dst,guard in re.findall(r'^(E\d+|\[\*\])\s+-->\s+(E\d+|\[\*\])[^\n:]*?(?: : \[(.*)\])? *$',native,re.M):
  actual.add(('start' if src=='[*]' else aliases[src],'done' if dst=='[*]' else aliases[dst],norm(guard or '')))
 assert actual=={(e['source'],e['target'],norm(e['guard'])) for e in edges}
 # 原生guard回投源模型，避免图上条件独立于实际source。
 for e in edges:
  src=e['source'] if e['source'] in decisions|merges|{'start','done'} else "'"+e['source']+"'"
  dst=e['target'] if e['target'] in decisions|merges|{'start','done'} else "'"+e['target']+"'"
  statement='first '+src+(' if '+e['guard'] if e['guard'] else '')+' then '+dst+';'
  assert statement in source
 summary.append(dict(requirement=rid,original_phases=len(baseline[rid]),actions=len(actions),decisions=len(decisions),merges=len(merges),successions=len(edges),unintended_action_joins=0))
ids=[x for p in M.glob('*-需求图.sysml') for x in re.findall(r"<'([^']+)'>",p.read_text())];assert len(ids)==len(set(ids))==23
result=dict(native_files=11,errors=0,warnings=0,original_requirement_ids=23,activities=summary,scope='原生静态检查及结构/关系复核；非模型执行或实车仿真')
(A/'增量语义复核结果.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(result,ensure_ascii=False,indent=2))
