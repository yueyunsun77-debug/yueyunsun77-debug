package Behaviour_3_3_1_9 {
    public import ScalarValues::*;
    public import SEOV_FunctionActions::*;
    enum def WindscreenKind { frontDefrost; frontDemist; rearUnspecified; unresolved; }
    doc /* 分析级行为模型。快照动作产生每周期外部输入，布尔分类和未定阈值由适配契约提供。守卫与控制节点真实建模；未实现车辆动力学、执行器算法或源理工具仿真。 */
    action '行为评估流程' {
        action '获取本周期快照' {
            doc /* 功能引用：行为适配/上下文。 */
                    out attribute stopRequested : Boolean;
                    out attribute requestKind : WindscreenKind;
                    out attribute soc : Real;
                    out attribute coolingRequestedByEnvironment : Boolean;
        }
        decide '是否继续评估';
        decide '风窗请求判断';
        decide '环境除湿判断';
        decide '低电量许可判断';
        fork '并行配置风窗参数';
        join '汇合风窗参数';
        merge '合并制冷决定';
        merge '合并风窗路径';
        action '接收风窗请求' : F_LF_016 {
            doc /* 功能引用：LF-016。 */

        }
        action '记录后风窗或未知依据缺口' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '处理前风窗控制模式' : F_LF_026 {
            doc /* 功能引用：LF-026。 */

        }
        action '仲裁热管理能力请求' : F_LF_023 {
            doc /* 功能引用：LF-023。 */
            doc /* 前除霜 > 电池高温冷却 > 座舱制冷 > 电池非高温冷却。电池高温分界XX及完整仲裁算法仍待定义；本节点保留该功能契约，不擅自用35℃补值。 */
            doc /* 本节点属性是行为决策所需的分析投影，不重新定义继承的概念级输出端口。 */
        }
        action '请求风窗送风模式' : F_LF_017 {
            doc /* 功能引用：LF-017。 */

        }
        action '请求最大送风量' : F_LF_018 {
            doc /* 功能引用：LF-018。 */

        }
        action '请求来源规定的外循环' : F_LF_019 {
            doc /* 功能引用：LF-019。 */

        }
        action '保持当前温度设定' : F_LF_021 {
            doc /* 功能引用：LF-021。 */

        }
        action '允许制冷除湿请求' : F_LF_020 {
            doc /* 功能引用：LF-020, LF-024。 */

        }
        action '禁止低电量非前除霜制冷' : F_LF_024 {
            doc /* 功能引用：LF-024。 */

        }
        action '不提出环境除湿请求' : F_LF_020 {
            doc /* 功能引用：LF-020。 */

        }
        action '记录SOC等于10的边界缺口' {
            doc /* 功能引用：LF-024。 */

        }
        action '反馈风窗与空调状态' : F_LF_022 {
            doc /* 功能引用：LF-022。 */

        }
        first start then '获取本周期快照';
        first '获取本周期快照' then '是否继续评估';
        first '是否继续评估' if '获取本周期快照'.stopRequested then done;
        first '是否继续评估' if not '获取本周期快照'.stopRequested then '接收风窗请求';
        first '接收风窗请求' then '风窗请求判断';
        first '风窗请求判断' if '获取本周期快照'.requestKind == WindscreenKind::frontDefrost or '获取本周期快照'.requestKind == WindscreenKind::frontDemist then '处理前风窗控制模式';
        first '处理前风窗控制模式' then '并行配置风窗参数';
        first '风窗请求判断' if not ('获取本周期快照'.requestKind == WindscreenKind::frontDefrost or '获取本周期快照'.requestKind == WindscreenKind::frontDemist) then '记录后风窗或未知依据缺口';
        first '并行配置风窗参数' then '请求风窗送风模式';
        first '请求风窗送风模式' then '汇合风窗参数';
        first '并行配置风窗参数' then '请求最大送风量';
        first '请求最大送风量' then '汇合风窗参数';
        first '并行配置风窗参数' then '请求来源规定的外循环';
        first '请求来源规定的外循环' then '汇合风窗参数';
        first '并行配置风窗参数' then '保持当前温度设定';
        first '保持当前温度设定' then '汇合风窗参数';
        first '汇合风窗参数' then '仲裁热管理能力请求';
        first '仲裁热管理能力请求' then '环境除湿判断';
        first '环境除湿判断' if '获取本周期快照'.coolingRequestedByEnvironment then '低电量许可判断';
        first '环境除湿判断' if not '获取本周期快照'.coolingRequestedByEnvironment then '不提出环境除湿请求';
        first '低电量许可判断' if '获取本周期快照'.soc > 10.0 or ('获取本周期快照'.soc < 10.0 and '获取本周期快照'.requestKind == WindscreenKind::frontDefrost) then '允许制冷除湿请求';
        first '低电量许可判断' if '获取本周期快照'.soc < 10.0 and '获取本周期快照'.requestKind != WindscreenKind::frontDefrost then '禁止低电量非前除霜制冷';
        first '低电量许可判断' if '获取本周期快照'.soc == 10.0 then '记录SOC等于10的边界缺口';
        first '允许制冷除湿请求' then '合并制冷决定';
        first '禁止低电量非前除霜制冷' then '合并制冷决定';
        first '不提出环境除湿请求' then '合并制冷决定';
        first '记录SOC等于10的边界缺口' then '合并制冷决定';
        first '合并制冷决定' then '合并风窗路径';
        first '记录后风窗或未知依据缺口' then '合并风窗路径';
        first '合并风窗路径' then '反馈风窗与空调状态';
        first '反馈风窗与空调状态' then '获取本周期快照';
    }
    view 'ACT_3319_需求活动图' : $::StandardViewDefinitions::ActionFlowView {
        expose '行为评估流程';
        render $::Views::asInterconnectionDiagram;
    }
}
