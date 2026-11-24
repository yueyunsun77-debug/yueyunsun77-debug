package Behaviour_3_3_1_2 {
    public import ScalarValues::*;
    public import SEOV_FunctionActions::*;
    doc /* 分析级行为模型。快照动作产生每周期外部输入，布尔分类和未定阈值由适配契约提供。守卫与控制节点真实建模；未实现车辆动力学、执行器算法或源理工具仿真。 */
    action '行为评估流程' {
        action '获取本周期快照' {
            doc /* 功能引用：LF-027。 */
                    out attribute stopRequested : Boolean;
                    out attribute heatingRequested : Boolean;
                    out attribute blowerActive : Boolean;
                    out attribute targetTemperature : Real;
                    out attribute cabinTemperature : Real;
                    out attribute highVoltageAvailable : Boolean;
                    out attribute vehicleFaultActive : Boolean;
                    out attribute soc : Real;
                    out attribute heaterTemperature : Real;
                    out attribute cutOffTemperature : Real;
                    out attribute recoveryTemperature : Real;
                    out attribute calibrationValid : Boolean;
                    out attribute protectionWasActive : Boolean;
        }
        decide '是否继续评估';
        decide '使能条件判断';
        decide '标定有效性判断';
        decide '过温判断';
        decide '保护记忆判断';
        decide '恢复条件判断';
        merge '合并控制结果';
        action '判定全部加热许可' {
            doc /* 功能引用：LF-001, LF-002, LF-003。 */

        }
        action '抑制电加热请求' : F_LF_004 {
            doc /* 功能引用：LF-004。 */
            attribute requestedEnable : Boolean = false;
            doc /* 本节点属性是行为决策所需的分析投影，不重新定义继承的概念级输出端口。 */
        }
        action '记录标定参数缺口' {
            doc /* 功能引用：LF-005, LF-006。 */

        }
        action '切断过温加热请求' : F_LF_005 {
            doc /* 功能引用：LF-005。 */
            attribute requestedEnable : Boolean = false;
            doc /* 本节点属性是行为决策所需的分析投影，不重新定义继承的概念级输出端口。 */
        }
        action '维持保护禁止状态' : F_LF_006 {
            doc /* 功能引用：LF-006。 */
            attribute recoveryAllowed : Boolean = false;
            doc /* 本节点属性是行为决策所需的分析投影，不重新定义继承的概念级输出端口。 */
        }
        action '允许恢复后的加热请求' : F_LF_004 {
            doc /* 功能引用：LF-006, LF-004。 */
            attribute requestedEnable : Boolean = true;
            doc /* 本节点属性是行为决策所需的分析投影，不重新定义继承的概念级输出端口。 */
        }
        action '允许正常加热请求' : F_LF_004 {
            doc /* 功能引用：LF-004。 */
            attribute requestedEnable : Boolean = true;
            doc /* 本节点属性是行为决策所需的分析投影，不重新定义继承的概念级输出端口。 */
        }
        action '反馈电加热运行状态' : F_LF_007 {
            doc /* 功能引用：LF-007。 */

        }
        first start then '获取本周期快照';
        first '获取本周期快照' then '是否继续评估';
        first '是否继续评估' if '获取本周期快照'.stopRequested then done;
        first '是否继续评估' if not '获取本周期快照'.stopRequested then '判定全部加热许可';
        first '判定全部加热许可' then '使能条件判断';
        first '使能条件判断' if '获取本周期快照'.heatingRequested and '获取本周期快照'.blowerActive and '获取本周期快照'.targetTemperature > '获取本周期快照'.cabinTemperature and '获取本周期快照'.highVoltageAvailable and not '获取本周期快照'.vehicleFaultActive and '获取本周期快照'.soc > 10.0 then '标定有效性判断';
        first '使能条件判断' if not ('获取本周期快照'.heatingRequested and '获取本周期快照'.blowerActive and '获取本周期快照'.targetTemperature > '获取本周期快照'.cabinTemperature and '获取本周期快照'.highVoltageAvailable and not '获取本周期快照'.vehicleFaultActive and '获取本周期快照'.soc > 10.0) then '抑制电加热请求';
        first '标定有效性判断' if '获取本周期快照'.calibrationValid then '过温判断';
        first '标定有效性判断' if not '获取本周期快照'.calibrationValid then '记录标定参数缺口';
        first '过温判断' if '获取本周期快照'.heaterTemperature >= '获取本周期快照'.cutOffTemperature then '切断过温加热请求';
        first '过温判断' if '获取本周期快照'.heaterTemperature < '获取本周期快照'.cutOffTemperature then '保护记忆判断';
        first '保护记忆判断' if '获取本周期快照'.protectionWasActive then '恢复条件判断';
        first '保护记忆判断' if not '获取本周期快照'.protectionWasActive then '允许正常加热请求';
        first '恢复条件判断' if '获取本周期快照'.heaterTemperature <= '获取本周期快照'.recoveryTemperature then '允许恢复后的加热请求';
        first '恢复条件判断' if '获取本周期快照'.heaterTemperature > '获取本周期快照'.recoveryTemperature then '维持保护禁止状态';
        first '抑制电加热请求' then '合并控制结果';
        first '记录标定参数缺口' then '合并控制结果';
        first '切断过温加热请求' then '合并控制结果';
        first '维持保护禁止状态' then '合并控制结果';
        first '允许恢复后的加热请求' then '合并控制结果';
        first '允许正常加热请求' then '合并控制结果';
        first '合并控制结果' then '反馈电加热运行状态';
        first '反馈电加热运行状态' then '获取本周期快照';
    }
    view 'ACT_3312_需求活动图' : $::StandardViewDefinitions::ActionFlowView {
        expose '行为评估流程';
        render $::Views::asInterconnectionDiagram;
    }
}
