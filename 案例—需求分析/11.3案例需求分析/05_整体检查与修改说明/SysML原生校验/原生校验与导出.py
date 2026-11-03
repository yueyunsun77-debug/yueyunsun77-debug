from pathlib import Path
import argparse,json,hashlib,sys,time

P=argparse.ArgumentParser()
P.add_argument('--model-dir',type=Path,required=True)
P.add_argument('--report',type=Path,required=True)
P.add_argument('--jar',type=Path,default=Path('/workspace/tools/sysml-pilot/package/share/jupyter/kernels/sysml/jupyter-sysml-kernel-0.63.1-all.jar'))
P.add_argument('--library',type=Path,default=Path('/workspace/tools/sysml-pilot/package/share/jupyter/kernels/sysml/sysml.library'))
P.add_argument('--bridge-dir',type=Path,default=Path('/workspace/tools/sysml-pilot/python-runtime'))
P.add_argument('--export-dir',type=Path)
args=P.parse_args();sys.path.insert(0,str(args.bridge_dir))
import jpype
jpype.startJVM('-Xmx3g',classpath=[str(args.jar)],convertStrings=True)
C=jpype.JClass('org.omg.sysml.interactive.SysMLInteractive')
I=jpype.JClass('org.eclipse.xtext.util.CancelIndicator')
M=jpype.JClass('org.eclipse.xtext.validation.CheckMode')
context=C.createInstance();context.loadLibrary(str(args.library))
validator_field=C.class_.getDeclaredField('validator');validator_field.setAccessible(True)
validator=validator_field.get(context)
resources=[]
for p in sorted(args.model_dir.glob('*.sysml')):
 context.next('.sysml');context.parse(p.read_text(encoding='utf-8'))
 r=context.getResource();context.addResourceToIndex(r);resources.append((p,r))
results=[]
for p,r in resources:
 issues=[]
 for issue in validator.validate(r,M.ALL,I.NullImpl):
  issues.append(dict(severity=str(issue.getSeverity()),line=issue.getLineNumber(),column=issue.getColumn(),message=str(issue.getMessage()),code=str(issue.getCode()),syntax_error=bool(issue.isSyntaxError())))
 result=dict(file=p.name,sha256=hashlib.sha256(p.read_bytes()).hexdigest(),errors=sum(i['severity']=='ERROR' for i in issues),warnings=sum(i['severity']=='WARNING' for i in issues),issues=issues)
 results.append(result);print(p.name,'errors',result['errors'],'warnings',result['warnings'],flush=True)
report=dict(engine='OMG SysML v2 Pilot Implementation / Xtext IResourceValidator CheckMode.ALL',distribution='jupyter-sysml-kernel 0.63.1 (conda-forge)',jar_sha256=hashlib.sha256(args.jar.read_bytes()).hexdigest(),normative_library_files=sum(1 for p in args.library.rglob('*') if p.is_file()),validation_kind='local native parser, linking, types and implemented static semantic rules; not vehicle simulation',files=results,total_files=len(results),errors=sum(r['errors'] for r in results),warnings=sum(r['warnings'] for r in results))
args.report.parent.mkdir(parents=True,exist_ok=True);args.report.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('TOTAL',report['errors'],'errors',report['warnings'],'warnings',flush=True)
if args.export_dir and not report['errors']:
 args.export_dir.mkdir(parents=True,exist_ok=True)
 def L(xs):
  values=jpype.JClass('java.util.ArrayList')()
  for x in xs: values.add(x)
  return values
 for p,r in resources:
  source=p.read_text()
  if '需求活动图' in p.name:
   package=__import__('re').search(r"package ('[^']+')",source)[1]
   view=__import__('re').search(r"view ('[^']+')",source)[1]
   result=context.view(package+'::'+view,L([]),L(['PUMLCODE']),L([]))
  elif p.name.endswith('-需求图.sysml'):
   package=__import__('re').search(r"package (\w+)",source)[1]
   req=__import__('re').search(r"requirement def <'[^']+'> (\w+)",source)[1]
   result=context.viz(L([package+'::'+req]),L(['TREE']),L(['PUMLCODE']),L([]))
  elif 'BDD图' in p.name:
   result=context.viz(L(["'热管理三条需求外部环境图BDD'::'热管理控制外部环境'"]),L(['INTERCONNECTION']),L(['PUMLCODE']),L([]))
  else:continue
  assert not result.hasException(),result.formatException()
  code=result.getPlantUML();assert code and code.startswith('@startuml'),result.getText()
  # 移除进程内随机psysml超链接，只影响点击目标，不更改模型关系。
  code=__import__('re').sub(r'\[\[psysml:[^\]]*\]\]', '', code)
  code='\n'.join(line.rstrip() for line in code.splitlines())+'\n'
  (args.export_dir/(p.stem+'.puml')).write_text(code,encoding='utf-8')
sys.exit(1 if report['errors'] else 0)
