// 修改说明：以逻辑功能表达内部职责；原技术信号与需求短ID保留，物理组件映射见Excel。
package '需求活动图_3316_自动空调模式' {
    private import ScalarValues::*;
    enum def AutoOperation { temperature; circulation; airflow; distribution; frontDefrost; ac; autoRepeat; noChange; }

    doc /*
       需求编号：3.3.1.6 自动空调模式。
       主要设计依据：CCU Component Technical Specification 6.13.1.3，印刷页67–68。
       补充依据：6.13.1.4；SL29 4.6.3.4–4.6.3.5补充温度信号检测背景。
       建模方式采用需求层活动图ACT：通过场景包、需求层活动、嵌套action、doc注释及ActionFlowView生成活动视图。
       本图表达主要阶段顺序；AUTO模式下各按钮的行为差异在对应动作说明中归纳。
       渲染图依据本轮显式决策与守卫导出；终点仅表示一次评估快照结束。
    */

    package 'REQ_3316_自动空调模式' {
        package '需求层活动' {
            action '需求活动执行流程' {
                doc /* 本活动为一次评估快照。条件与互斥路径由显式决策/守卫/合并建模；抽象动作不代表控制算法或实车仿真。 */
                in operation : AutoOperation;
                // operation是分析级按键分类，不作为新增CAN报文枚举。
                // 请求处理动作产生实际AUTO激活状态；未定义的重复AUTO策略保持抽象，不擅自赋值。

                action '接收AUTO模式请求' {
                    doc /*
                       对应设计需求：SL30-LC07-SF01 自动空调控制。
                       CCU接收用户通过IVI的AUTO按键发出的自动模式开启或关闭请求。
                    */
                }
                action '处理请求并反馈AUTO状态' {
                    doc /*
                       CCU响应AUTO模式开启/关闭请求，并将自动模式状态反馈给IVI显示。
                       AUTO状态下再次操作AUTO按键的处理在来源中标记为invalid，具体策略需按设计定义确认。
                    */

                    out autoModeActive : Boolean;
}
                action '采集环境与温度信号' {
                    doc /*
                       获取室内温度、室外温度、日照负荷信息，以及供热入口温度/电加热源温度等控制输入。
                       补充依据：SL29 4.6.3.4–4.6.3.5描述相关温度信号检测。
                    */
                }
                action '协调热量与空气调节服务' {
                    doc /*
                       CCU依据环境和温度信号，自动协调空气输送能力、送风温度调节、送风模式调节、循环方式调节、
                       制冷执行能力请求（转速接口）及电加热功率，使乘员舱温度趋近用户设定的目标温度。
                       对应设计需求：SL30-LC07-SF01、SL30-LC07-SF02。
                    */
                }
                action '处理用户操作与模式切换' {
                    doc /*
                       温度设置或循环设置变化时保持AUTO；操作风量或吹风模式按钮时退出AUTO；
                       操作前除霜按钮时切换至前除霜状态；操作AC按钮时关闭制冷执行功能请求，其他自动控制项继续工作；按CCU PDF第68页，AUTO状态反馈为Close。
                       各按钮行为依据SL30-LC07-SF01。
                    */
                }
                action '更新控制输出并持续反馈状态' {
                    doc /*
                       按当前AUTO状态及用户操作更新控制输出和模式状态，持续执行自动调节。
                       待确认：制冷执行功能、空气输送功能与电加热功率之间的匹配关系，以及温度LO/HI边界的具体控制和标定策略。
                    */
                }

                action '保持AUTO并更新设置' {
                    doc /* 温度或循环操作保持AUTO，仅更新对应设置。 */
                }
                action '退出AUTO且其余指定项仍自动' {
                    doc /* 风量或吹风模式操作退出AUTO，但除操作项外其他状态仍自动控制。 */
                }
                action '进入前除霜状态' {
                    doc /* 前除霜操作进入前除霜模式。 */
                }
                action '关闭制冷请求且转速请求为零' {
                    doc /* AUTO内AC操作关闭制冷请求且转速请求为0。 */
                }
                action 'AUTO反馈Close且局部功能仍自动' {
                    doc /* AC操作时AUTO反馈Close；风量、温度、模式、循环仍保持自动控制。 */
                }
                action '重复AUTO操作待确认' {
                    doc /* 原文为invalid，不自行解释为切换、忽略或报错。 */
                }
                action '无新操作保持当前调节' {
                    doc /* 表示一次控制评估中没有新增按键；不新增产品功能。 */
                }
                decide autoActiveChoice;
                decide userOperationChoice;
                merge operationMerged;
                merge feedbackMerged;
                first start then '接收AUTO模式请求';
                first '接收AUTO模式请求' then '处理请求并反馈AUTO状态';
                first '处理请求并反馈AUTO状态' then autoActiveChoice;
                first autoActiveChoice if '处理请求并反馈AUTO状态'.autoModeActive then '采集环境与温度信号';
                first autoActiveChoice if not '处理请求并反馈AUTO状态'.autoModeActive then feedbackMerged;
                first '采集环境与温度信号' then '协调热量与空气调节服务';
                first '协调热量与空气调节服务' then '处理用户操作与模式切换';
                first '处理用户操作与模式切换' then userOperationChoice;
                first userOperationChoice if operation == AutoOperation::temperature or operation == AutoOperation::circulation then '保持AUTO并更新设置';
                first userOperationChoice if operation == AutoOperation::airflow or operation == AutoOperation::distribution then '退出AUTO且其余指定项仍自动';
                first userOperationChoice if operation == AutoOperation::frontDefrost then '进入前除霜状态';
                first userOperationChoice if operation == AutoOperation::ac then '关闭制冷请求且转速请求为零';
                first userOperationChoice if operation == AutoOperation::autoRepeat then '重复AUTO操作待确认';
                first userOperationChoice if operation == AutoOperation::noChange then '无新操作保持当前调节';
                first '关闭制冷请求且转速请求为零' then 'AUTO反馈Close且局部功能仍自动';
                first '保持AUTO并更新设置' then operationMerged;
                first '退出AUTO且其余指定项仍自动' then operationMerged;
                first '进入前除霜状态' then operationMerged;
                first 'AUTO反馈Close且局部功能仍自动' then operationMerged;
                first '重复AUTO操作待确认' then operationMerged;
                first '无新操作保持当前调节' then operationMerged;
                first operationMerged then feedbackMerged;
                first feedbackMerged then '更新控制输出并持续反馈状态';
                first '更新控制输出并持续反馈状态' then done;
            }
        }
    }

    view 'ACT_3316_自动空调模式'
        : $::StandardViewDefinitions::ActionFlowView {
        expose 'REQ_3316_自动空调模式'::'需求层活动'::'需求活动执行流程';
        render $::Views::asInterconnectionDiagram;
    }
}
