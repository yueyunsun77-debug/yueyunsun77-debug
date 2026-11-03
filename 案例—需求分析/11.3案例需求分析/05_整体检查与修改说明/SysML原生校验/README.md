# SysML v2 原生检查与增量修正

本轮以 GitHub 已发布版本 c47d5f3 为基线，保留原需求编号、原高层动作、用例和外部接口，仅对已有模型增量修正。三条需求仍为 3.3.1.2、3.3.1.6、3.3.1.9；指标分析表、指标分配表及其数值不变。

## 实际检查结果

采用 [OMG SysML v2 Pilot Implementation](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation) 的 jupyter-sysml-kernel 0.63.1、配套标准库与 Xtext IResourceValidator CheckMode.ALL，在本地执行原生解析、引用链接、类型及该版本已实现的静态语义检查。

- 修改前：11 份模型，100 条错误诊断，0 警告。错误均在 BDD：Boolean/Real 缺少 ScalarValues 导入，产生类型未解析及连带诊断；不是 100 个独立设计错误。
- 修改后：11 份模型，0 错误、0 警告。逐文件 SHA256 与诊断见 [修改后原生诊断](修改后原生诊断.json)，原诊断见 [修改前原生诊断](修改前原生诊断.json)。
- 官方导出器生成 7 份 [原生视图 PlantUML](官方视图导出)，可与参考样式图交叉核对；其中活动图实际 successions、guard、起止、决策和合并节点逐条比对。导出的 psysml 随机会话超链接已移除，模型关系不变。
- 用例模型也参加了原生检查；其 puml/png/svg 保持原字节，沿用用户确认的图形。

## 修正内容与理由

1. BDD 显式引入 `ScalarValues::*`；保留 7 个角色、6 种端口类型、25 个属性、8 条接口连接，未将示例图片中的额外系统加入当前模型。
2. 制热活动：建立使能决策、过温决策、既有保护状态与恢复判断；通过 merge 汇合互斥路径。保护前态由调用方传入，下一快照保护态及最终加热许可为类型化表达式。上限、恢复温度作为无默认值输入，仍为 XXX 待标定；最终许可同时受使能与保护约束。
3. AUTO 活动：正式区分激活与未激活；按温度/循环、风量/模式、前除霜、AC、重复 AUTO、无新操作建立互斥分支。状态反馈前增加显式 merge，避免互斥路径直接汇入同一动作产生隐式同步。重复 AUTO 的具体处理保持待确认。
4. 风窗活动：有依据的前除霜/前除雾进入原配置链；后风窗、冲突或依据不足请求进入待确认路径。请求枚举用于内部分析分类，未定义新的外部 CAN 报文。
5. 在原 5 个子需求内部补充类型化约束：制热使能、过温保护、LO/HI 与 0.5℃调节、AUTO 内 AC 操作、SOC<10% 的前除霜许可例外。保留原 doc 和短 ID；不把未给出的阈值、策略或默认值补成设计决定。
6. 渲染保留圆角卡片、白底、紫色标记与中心式需求/外部环境布局。活动控制流采用实线箭头，决策/合并采用菱形；图中中文条件与原生 guard 一一对应。修复上版 SVG 被 PlantUML 功能提示占位的问题，直接通过 Graphviz 输出真实矢量图。

逐行差异见 [增量差异](增量差异)；显式关系见 [动作关系索引](显式动作关系索引.json)。

## 复现

工具发行包：[conda-forge jupyter-sysml-kernel 0.63.1](https://conda.anaconda.org/conda-forge/noarch/jupyter-sysml-kernel-0.63.1-pyhd8ed1ab_0.conda)。包 SHA256：`8da665d2b2131dcfbde62d32926864d0d03a62393ffdf4598efa64e0bc4b2251`。解包后使用其中的 jar 与整套 sysml.library；实际 jar SHA256 记在诊断 JSON。需要 Java 21、Python 3 与 JPype1 1.6.0。模型在本地检查，不上传外部渲染服务。

从成果根目录运行；`--bridge-dir` 指向 JPype1 安装目录，已在当前 Python 安装时可传该 site-packages：

```bash
python3 05_整体检查与修改说明/SysML原生校验/原生校验与导出.py --model-dir 01_系统边界与逻辑化表达/修改后的SysML模型 --report 05_整体检查与修改说明/SysML原生校验/修改后原生诊断.json --export-dir 05_整体检查与修改说明/SysML原生校验/官方视图导出 --jar /path/to/jupyter-sysml-kernel-0.63.1-all.jar --library /path/to/sysml.library --bridge-dir /path/to/site-packages
python3 06_模型渲染图/生成模型渲染图.py --jar /path/to/plantuml-1.2026.9.jar
python3 06_模型渲染图/校验渲染图.py
python3 05_整体检查与修改说明/SysML原生校验/校验增量语义.py
```

## 结论范围及未完成的工程决定

本次确实运行了原生工具，当前版本静态检查通过，渲染关系有实际模型依据。该结论不等于 OMG 认证、所有业务语义均被工具证明或实车仿真通过。用户原建模平台的导入兼容性仍需在该平台确认。

活动是需求层单次评估快照：接收请求、分类等仍为抽象动作，其数据产生、采样调度和跨活动调用尚未细化。需求约束中的属性也尚未与部署实现建立 binding/satisfy/verify 关系；本轮未伪造这些证明。Real 温度、SOC、转速仍沿用原接口的 ℃、百分数、r/min 数值约定，未完成量纲类型化。两项温度阈值、90% 外循环、1000 r/min 标定、仲裁 XX 阈值、重复 AUTO 交互、后风窗、未知初始保护态、物理部署等未决项继续保留，不能据此直接作为量产控制器代码。
