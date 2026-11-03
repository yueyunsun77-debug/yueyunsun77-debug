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

## 本轮增量规则

原3个主需求、41个IND及31个SC的ID全部保留，总数仍为75。SC记录通过extras.record_role与baseline_status明确为“场景功能分析记录”，不能将分析分解当成已批准新增产品需求。IND通过indicator_scope区分原表迁移/拆分、PDF补充、场景量化条件；新增logical_responsibility供矩阵核对，不等同正式SysML satisfy/allocate关系。IND-008主要类别调整为安全性，可靠性作为辅助类别保留。七个顶层字段不变。

新增原Excel图片source_ref只作部署差异上下文，明确不据图裁定控制器归属；原图片仍保留本地。字段级变化清单记录本轮相对08198b8的具体字段，未改写原附件。

## 当前表格范围与字段2对应规则

统一清单保留41个指标记录，IND-001—036进入两张三需求主表，IND-037—041进入场景参数表；不是删除5条原记录或改变其ID。extras.in_selected_requirement_tables为筛选标记，table_scope为范围说明。分析表的“部件/功能名称”对应extras.analysis_function_name（主要原需求），分配表对应extras.component_function_name（LF逻辑功能）；两个层级通过parent_requirement、applicable_requirement_ids及映射表连接。其余7列与同一JSON指标一一对应。

IND-033/034是关联规范中的共用采样支撑约束，分别主要归AUTO/制热，并保留另一需求为兼涉对象；IND-035/036主要归AUTO。10项待定条目仍未冻结。七个顶层字段无增删，不为表格范围修改原度量值、默认值、类别或来源。
