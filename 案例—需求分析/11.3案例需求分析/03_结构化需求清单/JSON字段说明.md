# JSON字段与更新规则

根结构延续原需求条目的数组；每条均严格包含七个顶层键，不增删：

|键|类型|本批用法|
|---|---|---|
|req_id|str|保留3.3.1.2/6/9；指标IND-001—041；场景SC1/2/3编号|
|name|str|逻辑化需求/指标名称|
|description|str|要求正文，含必要TBD/标定与适用条件|
|type|str|功能需求或指标，不与category合并|
|category|str|主要类别：功能性、非功能性、性能、安全性、可靠性|
|source_refs|list[dict]|备份内相对文件路径及sheet/row/section/pdf_pages/原req_id定位|
|extras|dict|指标专属属性或场景分析信息|

原3条功能需求仍完整保留使能、模式变化、安全等约束，type统一为功能需求，category取主要目的功能性；混合分类原值保存在备份，没有因归一化删除约束。特别补充原3.3.1.6遗漏的AC按键后AUTO反馈Close；局部自动功能保持不能误写成AUTO状态保持。

指标独立记录的type均为“指标”。表格指标类型放在extras.indicator_type；与顶层type不是同一个概念。extras.measurement_unit、measurement_range、default_value、component_function_name分别对应单位、范围、默认值、归属。extras.function_id连接逻辑目录，parent_requirement、original_row、original_indicator_name、original_measurement_text仅在需要追溯时保存。

未给出单位：表格“未提供”与JSON null对应；未给出默认值：表格空白与JSON null对应。范围原句保留为字符串，避免把未知阈值当成数值。原材料无布尔默认指标，不能将截图true复制为项目默认值。

source_refs中Excel旧文件名“热管理(1).xlsx”更正为本次上传文件名。原JSON引用SL29印刷34—35/16—17页与实际上传PDF不符，已改用可复核的pdf_pages=30/13—14，同时保留original_printed_pages记录差异；章节ID不变。PDF页码均为本附件从1开始的页面序号。

场景记录是用户要求的功能分解结果，不作为原Function List已存在条目的伪造转录。场景功能与原三个空调模式需求属于不同视角，不能未经证据一一合并。
