// 修改说明：以逻辑功能表达内部职责；原技术信号与需求短ID保留，物理组件映射见Excel。
package '需求活动图_3312_空调制热' {
    private import ScalarValues::*;

    doc /*
       需求编号：3.3.1.2 空调制热。
       主要设计依据：CCU Component Technical Specification 6.11.1.3，印刷页59–60。
       补充依据：6.13.1.4；SL29 4.6.3.5仅补充电加热温度检测背景。
       建模方式采用需求层活动图ACT：通过场景包、需求层活动、嵌套action、doc注释及ActionFlowView生成活动视图。
       本图保留原阶段并增加显式使能和温度保护分支。
    */

    package 'REQ_3312_空调制热' {
        package '需求层活动' {
            action '需求活动执行流程' {
                doc /* 本活动为一次评估快照。条件与互斥路径由显式决策/守卫/合并建模；抽象动作不代表控制算法或实车仿真。 */
                in airflowEnabled : Boolean;
                in targetTemperature : Real;
                in cabinTemperature : Real;
                in highVoltageAvailable : Boolean;
                in vehicleFaultActive : Boolean;
                in stateOfCharge : Real;
                in heaterTemperature : Real;
                in cutOffTemperature : Real;
                in recoveryTemperature : Real;
                in protectionWasActive : Boolean;
                out heatingAllowed : Boolean = airflowEnabled and targetTemperature > cabinTemperature and highVoltageAvailable and not vehicleFaultActive and stateOfCharge > 10;
                out protectionRequiredNext : Boolean = heaterTemperature >= cutOffTemperature or (protectionWasActive and heaterTemperature > recoveryTemperature);
                out heatingPermitted : Boolean = heatingAllowed and not protectionRequiredNext;
                // Real温度值沿用原℃信号约定；cutOff/recovery为XXX待标定输入，不设置默认值。
                // protectionWasActive由调用方传入，下一快照使用protectionRequiredNext；不假设初始状态。

                action '接收制热请求并读取目标温度' {
                    doc /*
                       对应设计需求：SL30-LC05-SF01 手动电加热控制。
                       用户通过IVI发起制热请求并设置目标温度；IVI将请求和相关参数发送给CCU。
                       Excel还提到物理控制输入，其具体输入路径需进一步确认。
                    */
                }
                action '检查电加热使能条件' {
                    doc /*
                       电加热允许加热的条件包括：空气输送功能开启、目标温度高于室内温度、车辆处于高压状态、
                       整车无故障且SOC大于10%。条件不满足时不得请求电加热。
                       对应设计需求：SL30-LC05-SF01。
                    */
                }
                action '根据使能条件控制电加热通断' {
                    doc /*
                       使能条件满足时，CCU控制电加热通断实施加热；条件不满足时保持电加热关闭。
                       本轮将使能结果落实为显式守卫；条件不满足时走禁止加热分支。
                    */
                }
                action '监测电加热温度并执行过温保护' {
                    doc /*
                       电加热接通后持续监测电加热温度。达到温度上限时停止电加热输出；
                       温度下降至恢复阈值后才允许恢复电加热输出。上限与恢复阈值在PDF中为XXX℃，待标定。
                       补充依据：SL29 4.6.3.5，CCU初始化后通过硬线每隔50 ms检测电加热温度。
                    */
                }
                action '反馈电加热状态与功率信息' {
                    doc /*
                       向总线反馈电加热通断状态、电加热当前温度、工作状态、实际功率和最大工作功率。
                       持续监测与加热控制属于本活动内部的持续行为。
                       待确认：电池热负荷如何参与乘员舱制热输出优化，当前设计依据未给出明确仲裁逻辑。
                    */
                }

                action '允许电加热输出' {
                    doc /* 全部使能条件满足后的许可；仍受后续过温保护约束。 */
                }
                action '禁止或保持关闭加热' {
                    doc /* 任一使能条件不满足时不得请求电加热。 */
                }
                action '判断保护恢复条件' {
                    doc /* 依据已触发保护状态和原待标定恢复温度判断；不假设初始保护状态。 */
                }
                action '重新允许加热' {
                    doc /* 温度满足恢复条件后才允许恢复，仍须满足全部使能条件及未达过温上限。 */
                }
                action '保持保护禁止状态' {
                    doc /* 已触发保护而尚未满足恢复条件时继续禁止输出。 */
                }
                action '停止加热并进入保护' {
                    doc /* 温度达到过温上限时必须停止加热；上限保留为外部待标定参数。 */
                }
                action '按当前许可调节输出' {
                    doc /* 未达到过温上限且未保持过温保护时按当前使能许可控制。 */
                }
                decide heatingEnableChoice;
                decide overtemperatureChoice;
                decide protectionMemoryChoice;
                decide recoveryChoice;
                merge enableMerged;
                merge protectionMerged;
                first start then '接收制热请求并读取目标温度';
                first '接收制热请求并读取目标温度' then '检查电加热使能条件';
                first '检查电加热使能条件' then '根据使能条件控制电加热通断';
                first '根据使能条件控制电加热通断' then heatingEnableChoice;
                first heatingEnableChoice if heatingAllowed then '允许电加热输出';
                first heatingEnableChoice if not heatingAllowed then '禁止或保持关闭加热';
                first '允许电加热输出' then enableMerged;
                first '禁止或保持关闭加热' then enableMerged;
                first enableMerged then '监测电加热温度并执行过温保护';
                first '监测电加热温度并执行过温保护' then overtemperatureChoice;
                first overtemperatureChoice if heaterTemperature >= cutOffTemperature then '停止加热并进入保护';
                first overtemperatureChoice if heaterTemperature < cutOffTemperature then protectionMemoryChoice;
                first protectionMemoryChoice if protectionWasActive then '判断保护恢复条件';
                first protectionMemoryChoice if not protectionWasActive then '按当前许可调节输出';
                first '判断保护恢复条件' then recoveryChoice;
                first recoveryChoice if heaterTemperature <= recoveryTemperature then '重新允许加热';
                first recoveryChoice if heaterTemperature > recoveryTemperature then '保持保护禁止状态';
                first '停止加热并进入保护' then protectionMerged;
                first '按当前许可调节输出' then protectionMerged;
                first '重新允许加热' then protectionMerged;
                first '保持保护禁止状态' then protectionMerged;
                first protectionMerged then '反馈电加热状态与功率信息';
                first '反馈电加热状态与功率信息' then done;
            }
        }
    }

    view 'ACT_3312_空调制热'
        : $::StandardViewDefinitions::ActionFlowView {
        expose 'REQ_3312_空调制热'::'需求层活动'::'需求活动执行流程';
        render $::Views::asInterconnectionDiagram;
    }
}
