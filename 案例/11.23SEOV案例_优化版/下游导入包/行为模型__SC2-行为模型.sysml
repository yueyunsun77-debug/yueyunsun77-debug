package Behaviour_SC2 {
    public import ScalarValues::*;
    public import SEOV_FunctionActions::*;
    doc /* 分析级行为模型。快照动作产生每周期外部输入，布尔分类和未定阈值由适配契约提供。守卫与控制节点真实建模；未实现车辆动力学、执行器算法或源理工具仿真。 */
    action '行为评估流程' {
        action '获取本周期快照' {
            doc /* 功能引用：行为适配/上下文。 */
                    out attribute stopRequested : Boolean;
                    out attribute elapsedSeconds : Real;
                    out attribute referenceProfileAccepted : Boolean;
                    out attribute cellTemperatureValid : Boolean;
                    out attribute maxValidCellTemperature : Real;
                    out attribute supplyCapabilityAvailable : Boolean;
                    out attribute supplyFeedbackValid : Boolean;
                    out attribute actualAirflowPositive : Boolean;
                    out attribute independentAirBoundaries : Boolean;
        }
        decide '是否继续评估';
        decide '驾驶阶段判断';
        decide '参考规则采用判断';
        decide '电芯温度有效性判断';
        decide '电池供风需求判断';
        decide '供风实际建立判断';
        decide '热边界独立性判断';
        merge '汇合驾驶阶段';
        fork '并行温控换热';
        merge '合并主动供风路径';
        join '汇合温控换热';
        merge '合并热边界结果';
        action '初始化驾驶循环与空调请求' : F_S2_F01 {
            doc /* 功能引用：S2-F01。 */

        }
        action '执行静置预冷工况' : F_S2_F02 {
            doc /* 功能引用：S2-F02。 */

        }
        action '执行匀速行驶工况' : F_S2_F03 {
            doc /* 功能引用：S2-F03。 */

        }
        action '处理座舱降温请求' : F_S2_F04 {
            doc /* 功能引用：S2-F04。 */

        }
        action '获取有效电池控制温度' : F_S2_F05 {
            doc /* 功能引用：S2-F05。 */

        }
        action '评估有符号环境换热' : F_S2_F07 {
            doc /* 功能引用：S2-F07。 */

        }
        action '获取实际供风条件' : F_S2_F09_01 {
            doc /* 功能引用：S2-F09-01。 */

        }
        action '判定实际供风状态' : F_S2_F09_02 {
            doc /* 功能引用：S2-F09-02。 */

        }
        action '计算主动供风换热量' : F_S2_F09_03 {
            doc /* 功能引用：S2-F09-03。 */

        }
        action '汇总独立空气侧热流' : F_S2_F10 {
            doc /* 功能引用：S2-F10。 */

        }
        action '提出电池主动供风请求' {
            doc /* 功能引用：S2-F06, S2-F08。 */

        }
        action '撤销电池供风请求' {
            doc /* 功能引用：S2-F06。 */

        }
        action '记录供风未实际建立' {
            doc /* 功能引用：S2-F09-02。 */

        }
        action '记录无有效温度缺口' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '记录参考规则未批准' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '更新被替换的空气边界' {
            doc /* 功能引用：S2-F10。 */

        }
        action '反馈本周期热状态' {
            doc /* 功能引用：S2-F10。 */

        }
        first start then '初始化驾驶循环与空调请求';
        first '初始化驾驶循环与空调请求' then '获取本周期快照';
        first '获取本周期快照' then '是否继续评估';
        first '是否继续评估' if '获取本周期快照'.stopRequested or '获取本周期快照'.elapsedSeconds >= 1320.0 then done;
        first '是否继续评估' if not '获取本周期快照'.stopRequested and '获取本周期快照'.elapsedSeconds < 1320.0 then '驾驶阶段判断';
        first '驾驶阶段判断' if '获取本周期快照'.elapsedSeconds < 120.0 then '执行静置预冷工况';
        first '驾驶阶段判断' if '获取本周期快照'.elapsedSeconds >= 120.0 then '执行匀速行驶工况';
        first '执行静置预冷工况' then '汇合驾驶阶段';
        first '执行匀速行驶工况' then '汇合驾驶阶段';
        first '汇合驾驶阶段' then '并行温控换热';
        first '并行温控换热' then '处理座舱降温请求';
        first '处理座舱降温请求' then '汇合温控换热';
        first '并行温控换热' then '评估有符号环境换热';
        first '评估有符号环境换热' then '汇合温控换热';
        first '并行温控换热' then '参考规则采用判断';
        first '参考规则采用判断' if '获取本周期快照'.referenceProfileAccepted then '获取有效电池控制温度';
        first '参考规则采用判断' if not '获取本周期快照'.referenceProfileAccepted then '记录参考规则未批准';
        first '获取有效电池控制温度' then '电芯温度有效性判断';
        first '电芯温度有效性判断' if '获取本周期快照'.cellTemperatureValid then '电池供风需求判断';
        first '电芯温度有效性判断' if not '获取本周期快照'.cellTemperatureValid then '记录无有效温度缺口';
        first '电池供风需求判断' if '获取本周期快照'.maxValidCellTemperature >= 35.0 then '提出电池主动供风请求';
        first '电池供风需求判断' if '获取本周期快照'.maxValidCellTemperature < 35.0 then '撤销电池供风请求';
        first '提出电池主动供风请求' then '获取实际供风条件';
        first '获取实际供风条件' then '判定实际供风状态';
        first '判定实际供风状态' then '供风实际建立判断';
        first '供风实际建立判断' if '获取本周期快照'.supplyCapabilityAvailable and '获取本周期快照'.supplyFeedbackValid and '获取本周期快照'.actualAirflowPositive then '计算主动供风换热量';
        first '供风实际建立判断' if not ('获取本周期快照'.supplyCapabilityAvailable and '获取本周期快照'.supplyFeedbackValid and '获取本周期快照'.actualAirflowPositive) then '记录供风未实际建立';
        first '计算主动供风换热量' then '合并主动供风路径';
        first '撤销电池供风请求' then '合并主动供风路径';
        first '记录供风未实际建立' then '合并主动供风路径';
        first '记录无有效温度缺口' then '合并主动供风路径';
        first '记录参考规则未批准' then '合并主动供风路径';
        first '合并主动供风路径' then '汇合温控换热';
        first '汇合温控换热' then '热边界独立性判断';
        first '热边界独立性判断' if '获取本周期快照'.independentAirBoundaries then '汇总独立空气侧热流';
        first '热边界独立性判断' if not '获取本周期快照'.independentAirBoundaries then '更新被替换的空气边界';
        first '汇总独立空气侧热流' then '合并热边界结果';
        first '更新被替换的空气边界' then '合并热边界结果';
        first '合并热边界结果' then '反馈本周期热状态';
        first '反馈本周期热状态' then '获取本周期快照';
    }
}
